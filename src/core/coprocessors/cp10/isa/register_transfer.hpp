#pragma once

#include <array>
#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CRegister_Transfer
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
        explicit CRegister_Transfer(std::uint32_t value) noexcept;

        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        std::uint32_t m_value;

        static constexpr std::size_t Instruction_Masks_Count = 7;
        static std::array<TInstruction_Lookup_Record, Instruction_Masks_Count> s_instruction_lookup_table;
    };
}