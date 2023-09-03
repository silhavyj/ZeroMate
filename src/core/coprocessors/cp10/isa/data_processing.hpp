// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/Advanced-SIMD-and-Floating-point-Instruction-Encoding/Floating-point-data-processing-instructions?lang=en

#pragma once

#include <array>
#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CData_Processing final
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
            VFNMA_VFNMS,
            VFMA_VFMS,
            VMOV_Immediate,
            VMOV_Register,
            VABS,
            VNEG,
            VSQRT,
            VCVTB_VCVTT,
            VCMP_VCMPE,
            VCVT_Double_Precision_Single_Precision,
            VCVT_VCVTR_Floating_Point_Integer,
            VCVT_Floating_Point_Fixed_Point,
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
        explicit CData_Processing(std::uint32_t value) noexcept;

        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        std::uint32_t m_value;

        static constexpr std::size_t Instruction_Masks_Count = 22;
        static std::array<TInstruction_Lookup_Record, Instruction_Masks_Count> s_instruction_lookup_table;
    };
}