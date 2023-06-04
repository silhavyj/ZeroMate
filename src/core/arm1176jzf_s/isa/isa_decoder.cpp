// ---------------------------------------------------------------------------------------------------------------------
/// \file isa_decoder.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements an instruction decoder defined in isa_decoder.hpp.
///
/// It takes a 32-bit value and returns an instruction type that matches the value.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <algorithm>
/// \endcond

// Project file imports

#include "../../utils/math.hpp"
#include "isa_decoder.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // clang-format off
    std::array<CISA_Decoder::TInstruction_Lookup_Record, CISA_Decoder::NUMBER_OF_INSTRUCTION_MASKS> CISA_Decoder::s_instruction_lookup_table = {{
    { .mask = 0b0000'1111'1111'1111'1111'1111'1101'0000U, .expected = 0b0000'0001'0010'1111'1111'1111'0001'0000U, .type = CInstruction::NType::Branch_And_Exchange           },
    { .mask = 0b0000'1110'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'1010'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Branch                        },
    { .mask = 0b0000'1100'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'0000'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Data_Processing               },
    { .mask = 0b0000'1111'1100'0000'0000'0000'1111'0000U, .expected = 0b0000'0000'0000'0000'0000'0000'1001'0000U, .type = CInstruction::NType::Multiply                      },
    { .mask = 0b0000'1111'1000'0000'0000'0000'1111'0000U, .expected = 0b0000'0000'1000'0000'0000'0000'1001'0000U, .type = CInstruction::NType::Multiply_Long                 },
    { .mask = 0b0000'1100'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'0100'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Single_Data_Transfer          },
    { .mask = 0b0000'1110'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'1000'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Block_Data_Transfer           },
    { .mask = 0b0000'1110'0000'0000'0000'0000'1001'0000U, .expected = 0b0000'0000'0000'0000'0000'0000'1001'0000U, .type = CInstruction::NType::Halfword_Data_Transfer        },
    { .mask = 0b0000'1111'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'1111'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Software_Interrupt            },
    { .mask = 0b0000'1111'1000'0000'0000'0011'1111'0000U, .expected = 0b0000'0110'1000'0000'0000'0000'0111'0000U, .type = CInstruction::NType::Extend                        },
    { .mask = 0b0000'1111'1001'1111'0000'1111'1111'1111U, .expected = 0b0000'0001'0000'1111'0000'0000'0000'0000U, .type = CInstruction::NType::PSR_Transfer                  },
    { .mask = 0b0000'1111'1001'0000'1111'1111'1111'0000U, .expected = 0b0000'0001'0000'0000'1111'0000'0000'0000U, .type = CInstruction::NType::PSR_Transfer                  },
    { .mask = 0b0000'1111'1011'0000'1111'0000'0000'0000U, .expected = 0b0000'0011'0010'0000'1111'0000'0000'0000U, .type = CInstruction::NType::PSR_Transfer                  },
    { .mask = 0b1111'1111'1111'0001'1111'1110'0010'0000U, .expected = 0b1111'0001'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::CPS                           },
    { .mask = 0b1111'1111'1111'1111'1111'1111'1111'1111U, .expected = 0b1110'0011'0010'0000'1111'0000'0000'0000U, .type = CInstruction::NType::NOP                           },
    { .mask = 0b0000'1111'0000'0000'0000'0000'0001'0000U, .expected = 0b0000'1110'0000'0000'0000'0000'0001'0000U, .type = CInstruction::NType::Coprocessor_Register_Transfer },
    { .mask = 0b0000'1110'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'1100'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Coprocessor_Data_Transfer     },
    { .mask = 0b0000'1111'0000'0000'0000'0000'0001'0000U, .expected = 0b0000'1110'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Coprocessor_Data_Operation    },
    { .mask = 0b1111'1110'0101'1111'1111'1111'1110'0000U, .expected = 0b1111'1000'0100'1101'0000'0101'0000'0000U, .type = CInstruction::NType::SRS                           },
    { .mask = 0b1111'1110'0101'0000'1111'1111'1111'1111U, .expected = 0b1111'1000'0001'0000'0000'1010'0000'0000U, .type = CInstruction::NType::RFE                           },
    { .mask = 0b0000'1111'1111'1111'0000'1111'1111'0000U, .expected = 0b0000'0001'0110'1111'0000'1111'0001'0000U, .type = CInstruction::NType::CLZ                           }
    }};
    // clang-format on

    CISA_Decoder::CISA_Decoder() noexcept
    {
        // Sort out the look-up table by the mask restrictiveness (from the most to the least restrictive mask).
        std::sort(s_instruction_lookup_table.begin(),
                  s_instruction_lookup_table.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return std::popcount(record1.mask) > std::popcount(record2.mask);
                  });
    }

    CInstruction::NType CISA_Decoder::Get_Instruction_Type(CInstruction instruction) noexcept
    {
        for (const auto& [mask, expected, type] : s_instruction_lookup_table)
        {
            // Apply the mask to the instruction (32-bit value) and check if it matches the expected value.
            if ((instruction.Get_Value() & mask) == expected)
            {
                return type;
            }
        }

        return CInstruction::NType::Unknown;
    }

} // namespace zero_mate::arm1176jzf_s::isa