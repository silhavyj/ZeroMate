// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/Advanced-SIMD-and-Floating-point-Instruction-Encoding/Floating-point-data-processing-instructions?lang=en

#pragma once

#include <array>
#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CCP_Data_Processing_Inst final
    {
    public:
        enum class NType : std::uint32_t
        {
            VMLA_VMLS,
            VNMLA_VNMLS_VNMUL,
            VMUL,
            VADD,
            VSUB,
            VDIV,
            VMOV_Register,
            VABS,
            VNEG,
            VSQRT,
            VCMP_VCMPE,
            VCVT_Double_Precision_Single_Precision,
            VCVT_VCVTR_Floating_Point_Integer,
            Unknown
        };

    private:
        struct TInstruction_Lookup_Record
        {
            std::uint32_t mask;
            std::uint32_t expected;
            NType type;
        };

    public:
        explicit CCP_Data_Processing_Inst(std::uint32_t value) noexcept;

        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        std::uint32_t m_value;

        static constexpr std::size_t Instruction_Masks_Count = 16;
        static std::array<TInstruction_Lookup_Record, Instruction_Masks_Count> s_instruction_lookup_table;
    };
}