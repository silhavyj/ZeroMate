// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/Advanced-SIMD-and-Floating-point-Instruction-Encoding/8--16--and-32-bit-transfer-between-ARM-core-and-extension-registers?lang=en

#pragma once

#include <array>
#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CCP_Register_Transfer_Inst
    {
    public:
        enum class NType
        {
            VMOV_ARM_Register_Single_Precision_Register,
            VMSR,
            VMOV_ARM_Register_Scalar,
            VDUP,
            VMRS,
            VMOV_Scalar_ARM_Register,
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
        explicit CCP_Register_Transfer_Inst(std::uint32_t value) noexcept;

        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        std::uint32_t m_value;

        static constexpr std::size_t Instruction_Masks_Count = 7;
        static std::array<TInstruction_Lookup_Record, Instruction_Masks_Count> s_instruction_lookup_table;
    };
}