// ---------------------------------------------------------------------------------------------------------------------
/// \file cp_register_transfer_inst.cpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a general CP10 register transfer instruction
///
/// More information about instruction encoding can be found over at
/// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/
/// Advanced-SIMD-and-Floating-point-Instruction-Encoding/
/// 8--16--and-32-bit-transfer-between-ARM-core-and-extension-registers?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <algorithm>
/// \endcond

// Project file imports

#include "cp_register_transfer_inst.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // clang-format off
    std::array<CCP_Instruction::TInstruction_Lookup_Record<CCP_Register_Transfer_Inst::NType>, CCP_Register_Transfer_Inst::Instruction_Masks_Count> CCP_Register_Transfer_Inst::s_instruction_lookup_table = {{
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'0'00000000000'0'0'00'00000U, .type = CCP_Register_Transfer_Inst::NType::VMOV_ARM_Register_Single_Precision_Register },
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'111'0'00000000000'0'0'00'00000U, .type = CCP_Register_Transfer_Inst::NType::VMSR                                        },
    { .mask = 0b00000000'100'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'0'00000000000'1'0'00'00000U, .type = CCP_Register_Transfer_Inst::NType::VMOV_ARM_Register_Scalar                    },
    { .mask = 0b00000000'100'1'00000000000'1'0'10'00000U, .expected = 0b00000000'100'0'00000000000'1'0'00'00000U, .type = CCP_Register_Transfer_Inst::NType::VDUP                                        },
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'1'00000000000'0'0'00'00000U, .type = CCP_Register_Transfer_Inst::NType::VMOV_ARM_Register_Single_Precision_Register },
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'111'1'00000000000'0'0'00'00000U, .type = CCP_Register_Transfer_Inst::NType::VMRS                                        },
    { .mask = 0b00000000'000'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'1'00000000000'1'0'00'00000U, .type = CCP_Register_Transfer_Inst::NType::VMOV_Scalar_ARM_Register                    },
    }};
    // clang-format on

    CCP_Register_Transfer_Inst::CCP_Register_Transfer_Inst(std::uint32_t value) noexcept
    : CCP_Instruction{ value }
    {
        // Sort out the look-up table by the mask restrictiveness (from the most to the least restrictive mask).
        std::sort(s_instruction_lookup_table.begin(),
                  s_instruction_lookup_table.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return std::popcount(record1.mask) > std::popcount(record2.mask);
                  });
    }

    CCP_Register_Transfer_Inst::NType CCP_Register_Transfer_Inst::Get_Type() const noexcept
    {
        return CCP_Instruction::Get_Type<NType, decltype(s_instruction_lookup_table)>(s_instruction_lookup_table);
    }

} // namespace zero_mate::coprocessor::cp10::isa