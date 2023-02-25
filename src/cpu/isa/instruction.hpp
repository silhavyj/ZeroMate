#pragma once

#include <cstdint>

namespace zero_mate::cpu::isa
{
    class CInstruction
    {
    public:
        enum class NCondition : std::uint32_t
        {
            EQ = 0b0000, // Z set; equal
            NE = 0b0001, // Z clear; not equal
            HS = 0b0010, // C set; unsigned higher or same
            LO = 0b0011, // C clear; unsigned lower
            MI = 0b0100, // N set; negative
            PL = 0b0101, // N clear; positive or zero
            VS = 0b0110, // V set; overflow
            VC = 0b0111, // V clear; no overflow
            HI = 0b1000, // C set and Z clear; unsigned higher
            LS = 0b1001, // C clear or Z set; unsigned lower or same
            GE = 0b1010, // N equals V; greater or equal
            LT = 0b1011, // N not equal to V; less than
            GT = 0b1100, // Z clear AND (N equals V); greater than
            LE = 0b1101, // Z set OR (N not equal to V); less than or equal
            AL = 0b1110, // always
        };

        enum class NType : std::uint32_t
        {
            Data_Processing,
            Multiply,
            Multiply_Long,
            Single_Data_Swap,
            Branch_And_Exchange,
            Halfword_Data_Transfer_Register_Offset,
            Halfword_Data_Transfer_Immediate_Offset,
            Single_Data_Transfer,
            Undefined,
            Block_Data_Transfer,
            Branch,
            Coprocessor_Data_Transfer,
            Coprocessor_Data_Operation,
            Coprocessor_Register_Transfer,
            Software_Interrupt,
            Unknown
        };

        enum class NShift_Type : std::uint32_t
        {
            LSL = 0b00, // Logical shift left
            LSR = 0b01, // Logical shift right
            ASR = 0b10, // Arithmetic shift right
            ROR = 0b11  // Rotate right
        };

        CInstruction(std::uint32_t value) noexcept;

        [[nodiscard]] std::uint32_t Get_Value() const noexcept;
        [[nodiscard]] NCondition Get_Condition() const noexcept;

    protected:
        std::uint32_t m_value;
    };
}