#include <bit>
#include <algorithm>

#include "data_processing.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // clang-format off
    std::array<CData_Processing::TInstruction_Lookup_Record, CData_Processing::Instruction_Masks_Count> CData_Processing::s_instruction_lookup_table = {{

    // Table 7.16. Three-register Floating-point data-processing instructions

    { .mask = 0b00000000'1011'0000'00000000'00'00'0000U, .expected = 0b00000000'0001'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VNMLA_VNMLS_VNMUL                      },
    { .mask = 0b00000000'1011'0000'00000000'00'00'0000U, .expected = 0b00000000'0000'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VMLA_VMLS                              },
    { .mask = 0b00000000'1011'0000'00000000'01'00'0000U, .expected = 0b00000000'0010'0000'00000000'01'00'0000U, .type = CData_Processing::NType::VNMLA_VNMLS_VNMUL                      },
    { .mask = 0b00000000'1011'0000'00000000'01'00'0000U, .expected = 0b00000000'0010'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VMUL                                   },
    { .mask = 0b00000000'1011'0000'00000000'01'00'0000U, .expected = 0b00000000'0011'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VADD                                   },
    { .mask = 0b00000000'1011'0000'00000000'01'00'0000U, .expected = 0b00000000'0011'0000'00000000'01'00'0000U, .type = CData_Processing::NType::VSUB                                   },
    { .mask = 0b00000000'1011'0000'00000000'01'00'0000U, .expected = 0b00000000'1000'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VDIV                                   },
    { .mask = 0b00000000'1011'0000'00000000'01'00'0000U, .expected = 0b00000000'1000'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VDIV                                   },
    { .mask = 0b00000000'1011'0000'00000000'00'00'0000U, .expected = 0b00000000'1001'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VFNMA_VFNMS                            },
    { .mask = 0b00000000'1011'0000'00000000'00'00'0000U, .expected = 0b00000000'1010'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VFMA_VFMS                              },

    // Table 7.17. Other Floating-point data-processing instructions

    { .mask = 0b00000000'1011'0000'00000000'01'00'0000U, .expected = 0b00000000'1011'0000'00000000'00'00'0000U, .type = CData_Processing::NType::VMOV_Immediate                         },
    { .mask = 0b00000000'1011'1111'00000000'11'00'0000U, .expected = 0b00000000'1011'0000'00000000'01'00'0000U, .type = CData_Processing::NType::VMOV_Register                          },
    { .mask = 0b00000000'1011'1111'00000000'11'00'0000U, .expected = 0b00000000'1011'0000'00000000'11'00'0000U, .type = CData_Processing::NType::VABS                                   },
    { .mask = 0b00000000'1011'1111'00000000'11'00'0000U, .expected = 0b00000000'1011'0001'00000000'01'00'0000U, .type = CData_Processing::NType::VNEG                                   },
    { .mask = 0b00000000'1011'1111'00000000'11'00'0000U, .expected = 0b00000000'1011'0001'00000000'11'00'0000U, .type = CData_Processing::NType::VSQRT                                  },
    { .mask = 0b00000000'1011'1110'00000000'01'00'0000U, .expected = 0b00000000'1011'0010'00000000'01'00'0000U, .type = CData_Processing::NType::VCVTB_VCVTT                            },
    { .mask = 0b00000000'1011'1110'00000000'01'00'0000U, .expected = 0b00000000'1011'0100'00000000'01'00'0000U, .type = CData_Processing::NType::VCMP_VCMPE                             },
    { .mask = 0b00000000'1011'1111'00000000'11'00'0000U, .expected = 0b00000000'1011'0111'00000000'11'00'0000U, .type = CData_Processing::NType::VCVT_Double_Precision_Single_Precision },
    { .mask = 0b00000000'1011'1111'00000000'01'00'0000U, .expected = 0b00000000'1011'1000'00000000'01'00'0000U, .type = CData_Processing::NType::VCVT_VCVTR_Floating_Point_Integer      },
    { .mask = 0b00000000'1011'1110'00000000'01'00'0000U, .expected = 0b00000000'1011'1010'00000000'01'00'0000U, .type = CData_Processing::NType::VCVT_Floating_Point_Fixed_Point        },
    { .mask = 0b00000000'1011'1110'00000000'01'00'0000U, .expected = 0b00000000'1011'1100'00000000'01'00'0000U, .type = CData_Processing::NType::VCVT_VCVTR_Floating_Point_Integer      },
    { .mask = 0b00000000'1011'1110'00000000'01'00'0000U, .expected = 0b00000000'1011'1110'00000000'01'00'0000U, .type = CData_Processing::NType::VCVT_Floating_Point_Fixed_Point        }
    }};
    // clang-format on

    CData_Processing::CData_Processing(std::uint32_t value) noexcept
    : m_value{ value }
    {
        std::sort(s_instruction_lookup_table.begin(),
                  s_instruction_lookup_table.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return std::popcount(record1.mask) > std::popcount(record2.mask);
                  });
    }

    CData_Processing::NType CData_Processing::Get_Type() const noexcept
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