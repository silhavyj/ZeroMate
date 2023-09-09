// ---------------------------------------------------------------------------------------------------------------------
/// \file cp_data_transfer_inst.cpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a general CP10 data transfer instruction (load and store).
///
/// More information about instruction encoding can be found over at
/// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/
/// Advanced-SIMD-and-Floating-point-Instruction-Encoding/Extension-register-load-store-instructions?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <algorithm>
/// \endcond

// Project file imports

#include "cp_data_transfer_inst.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // clang-format off
    std::array<CCP_Instruction::TInstruction_Lookup_Record<CCP_Data_Transfer_Inst::NType>, CCP_Data_Transfer_Inst::Instruction_Masks_Count> CCP_Data_Transfer_Inst::s_instruction_lookup_table = {{
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'01000'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VSTM_Increment_After_No_Writeback },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'01010'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VSTM_Increment_After_Writeback    },
    { .mask = 0b0000000'10011'0000'0000000000000000U, .expected = 0b0000000'10000'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VSTR                              },
    { .mask = 0b0000000'11011'1111'0000000000000000U, .expected = 0b0000000'10010'1101'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VPUSH                             },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'10010'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VSTM_Decrement_Before_Writeback   },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'01001'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VLDM_Increment_After_No_Writeback },
    { .mask = 0b0000000'11011'1111'0000000000000000U, .expected = 0b0000000'01011'1101'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VPOP                              },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'01011'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VLDM_Increment_After_Writeback    },
    { .mask = 0b0000000'10011'0000'0000000000000000U, .expected = 0b0000000'10001'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VLDR                              },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'10011'0000'0000000000000000U, .type = CCP_Data_Transfer_Inst::NType::VLDM_Decrement_Before_Writeback   }
    }};
    // clang-format on

    CCP_Data_Transfer_Inst::CCP_Data_Transfer_Inst(std::uint32_t value) noexcept
    : CCP_Instruction{ value }
    {
        // Sort out the look-up table by the mask restrictiveness (from the most to the least restrictive mask).
        std::sort(s_instruction_lookup_table.begin(),
                  s_instruction_lookup_table.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return std::popcount(record1.mask) > std::popcount(record2.mask);
                  });
    }

    CCP_Data_Transfer_Inst::NType CCP_Data_Transfer_Inst::Get_Type() const noexcept
    {
        return CCP_Instruction::Get_Type<NType, decltype(s_instruction_lookup_table)>(s_instruction_lookup_table);
    }

} // namespace zero_mate::coprocessor::cp10::isa