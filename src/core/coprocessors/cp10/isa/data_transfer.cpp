#include <bit>
#include <algorithm>

#include "data_transfer.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // clang-format off
    std::array<CData_Transfer::TInstruction_Lookup_Record, CData_Transfer::Instruction_Masks_Count> CData_Transfer::s_instruction_lookup_table = {{
    { .mask = 0b0000000'11110'0000'0000000000000000U, .expected = 0b0000000'01000'0000'0000000000000000U, .type = CData_Transfer::NType::VSTM_Increment_After_No_Writeback },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'01010'0000'0000000000000000U, .type = CData_Transfer::NType::VSTM_Increment_After_Writeback    },
    { .mask = 0b0000000'10011'0000'0000000000000000U, .expected = 0b0000000'10000'0000'0000000000000000U, .type = CData_Transfer::NType::VSTR                              },
    { .mask = 0b0000000'11011'1111'0000000000000000U, .expected = 0b0000000'10010'1101'0000000000000000U, .type = CData_Transfer::NType::VPUSH                             },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'10010'0000'0000000000000000U, .type = CData_Transfer::NType::VSTM_Decrement_Before_Writeback   },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'01001'0000'0000000000000000U, .type = CData_Transfer::NType::VLDM_Increment_After_No_Writeback },
    { .mask = 0b0000000'11011'1111'0000000000000000U, .expected = 0b0000000'01011'1101'0000000000000000U, .type = CData_Transfer::NType::VPOP                              },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'01011'0000'0000000000000000U, .type = CData_Transfer::NType::VLDM_Increment_After_Writeback    },
    { .mask = 0b0000000'10011'0000'0000000000000000U, .expected = 0b0000000'10001'0000'0000000000000000U, .type = CData_Transfer::NType::VLDR                              },
    { .mask = 0b0000000'11011'0000'0000000000000000U, .expected = 0b0000000'10011'0000'0000000000000000U, .type = CData_Transfer::NType::VLDM_Decrement_Before_Writeback   }
    }};
    // clang-format on

    CData_Transfer::CData_Transfer(std::uint32_t value) noexcept
    : m_value{ value }
    {
        std::sort(s_instruction_lookup_table.begin(),
                  s_instruction_lookup_table.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return std::popcount(record1.mask) > std::popcount(record2.mask);
                  });
    }

    CData_Transfer::NType CData_Transfer::Get_Type() const noexcept
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