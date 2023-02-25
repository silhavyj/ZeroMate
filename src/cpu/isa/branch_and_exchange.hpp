#pragma once

#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    class CBranch_And_Exchange final : public CInstruction
    {
    public:
        enum class NCPU_Instruction_Mode : std::uint8_t
        {
            ARM = 0,
            Thumb = 1
        };

        explicit CBranch_And_Exchange(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;
        [[nodiscard]] NCPU_Instruction_Mode Get_Instruction_Mode() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };
}