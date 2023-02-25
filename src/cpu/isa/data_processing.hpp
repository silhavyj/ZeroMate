#pragma once

#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    class CData_Processing final : public CInstruction
    {
    public:
        enum class NOpcode : std::uint32_t
        {
            AND = 0b0000, // operand1 AND operand2
            EOR = 0b0001, // operand1 EOR operand2
            SUB = 0b0010, // operand1 - operand2
            RSB = 0b0011, // operand2 - operand1
            ADD = 0b0100, // operand1 + operand2
            ADC = 0b0101, // operand1 + operand2 + carry
            SBC = 0b0110, // operand1 - operand2 + carry - 1
            RSC = 0b0111, // operand2 - operand1 + carry - 1
            TST = 0b1000, // as AND, but result is not written
            TEQ = 0b1001, // as EOR, but result is not written
            CMP = 0b1010, // as SUB, but result is not written
            CMN = 0b1011, // as ADD, but result is not written
            ORR = 0b1100, // operand1 OR operand2
            MOV = 0b1101, // operand2(operand1 is ignored)
            BIC = 0b1110, // operand1 AND NOT operand2(Bit clear)
            MVN = 0b1111  // NOT operand2(operand1 is ignored)
        };

        explicit CData_Processing(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_I_Bit_Set() const noexcept;
        [[nodiscard]] NOpcode Get_Opcode() const noexcept;
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Shift_Amount() const noexcept;
        [[nodiscard]] NShift_Type Get_Shift_Type() const noexcept;
        [[nodiscard]] bool Is_Immediate_Shift() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rs() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rotate() const noexcept;
        [[nodiscard]] std::uint32_t Get_Immediate() const noexcept;
    };
}