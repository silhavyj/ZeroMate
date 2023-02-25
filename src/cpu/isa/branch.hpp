#pragma once

#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    class CBranch final : public CInstruction
    {
    public:
        explicit CBranch(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;
        [[nodiscard]] std::int32_t Get_Offset() const noexcept;
    };
}