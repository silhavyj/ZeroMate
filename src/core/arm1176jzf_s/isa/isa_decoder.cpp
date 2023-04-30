#include <bit>
#include <algorithm>

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
    { .mask = 0b0000'1111'0000'0000'0000'0000'0001'0000U, .expected = 0b0000'1110'0000'0000'0000'0000'0001'0000U, .type = CInstruction::NType::Coprocessor_Register_Transfer }
    }};
    // clang-format on

    CISA_Decoder::CISA_Decoder() noexcept
    {
        std::sort(s_instruction_lookup_table.begin(),
                  s_instruction_lookup_table.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return std::popcount(record1.mask) >
                             std::popcount(record2.mask);
                  });
    }

    CInstruction::NType CISA_Decoder::Get_Instruction_Type(CInstruction instruction) noexcept
    {
        for (const auto& [mask, expected, type] : s_instruction_lookup_table)
        {
            if ((instruction.Get_Value() & mask) == expected)
            {
                return type;
            }
        }

        return CInstruction::NType::Unknown;
    }
}