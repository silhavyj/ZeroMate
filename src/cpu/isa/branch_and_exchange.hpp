#pragma once

#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    class CBranch_And_Exchange final : public CInstruction
    {
    public:
        explicit CBranch_And_Exchange(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;
        [[nodiscard]] bool Switch_To_Thumb() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };
}