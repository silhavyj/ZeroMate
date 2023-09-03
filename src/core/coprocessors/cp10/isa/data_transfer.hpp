// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/Advanced-SIMD-and-Floating-point-Instruction-Encoding/Extension-register-load-store-instructions?lang=en

#pragma once

#include <array>
#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CData_Transfer final
    {
    public:
        enum class NType
        {
            VSTM_Increment_After_No_Writeback,
            VSTM_Increment_After_Writeback,
            VSTR,
            VSTM_Decrement_Before_Writeback,
            VPUSH,
            VLDM_Increment_After_No_Writeback,
            VLDM_Increment_After_Writeback,
            VPOP,
            VLDR,
            VLDM_Decrement_Before_Writeback,
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
        explicit CData_Transfer(std::uint32_t value) noexcept;

        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        std::uint32_t m_value;

        static constexpr std::size_t Instruction_Masks_Count = 10;
        static std::array<TInstruction_Lookup_Record, Instruction_Masks_Count> s_instruction_lookup_table;
    };
}