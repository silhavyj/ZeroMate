#include <bit>
#include <algorithm>

#include "register_transfer.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // clang-format off
    std::array<CRegister_Transfer::TInstruction_Lookup_Record, CRegister_Transfer::Instruction_Masks_Count> CRegister_Transfer::s_instruction_lookup_table = {{
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'0'00000000000'0'0'00'00000U, .type = CRegister_Transfer::NType::VMOV_ARM_Register_Single_Precision_Register },
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'111'0'00000000000'0'0'00'00000U, .type = CRegister_Transfer::NType::VMSR                                        },
    { .mask = 0b00000000'100'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'0'00000000000'1'0'00'00000U, .type = CRegister_Transfer::NType::VMOV_ARM_Register_Scalar                    },
    { .mask = 0b00000000'100'1'00000000000'1'0'10'00000U, .expected = 0b00000000'100'0'00000000000'1'0'00'00000U, .type = CRegister_Transfer::NType::VDUP                                        },
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'1'00000000000'0'0'00'00000U, .type = CRegister_Transfer::NType::VMOV_ARM_Register_Single_Precision_Register },
    { .mask = 0b00000000'111'1'00000000000'1'0'00'00000U, .expected = 0b00000000'111'1'00000000000'0'0'00'00000U, .type = CRegister_Transfer::NType::VMRS                                        },
    { .mask = 0b00000000'000'1'00000000000'1'0'00'00000U, .expected = 0b00000000'000'1'00000000000'1'0'00'00000U, .type = CRegister_Transfer::NType::VMOV_Scalar_ARM_Register                    },
    }};
    // clang-format on

    CRegister_Transfer::CRegister_Transfer(std::uint32_t value) noexcept
    : m_value{ value }
    {
        std::sort(s_instruction_lookup_table.begin(),
                  s_instruction_lookup_table.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return std::popcount(record1.mask) > std::popcount(record2.mask);
                  });
    }

    CRegister_Transfer::NType CRegister_Transfer::Get_Type() const noexcept
    {
        for (const auto& [mask, expected, type] : s_instruction_lookup_table)
        {
            if ((m_value & mask) == expected)
            {
                return type;
            }
        }

        return NType::Unknown;
    }
}