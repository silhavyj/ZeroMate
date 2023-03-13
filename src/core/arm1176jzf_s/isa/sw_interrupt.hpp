#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CSW_Interrupt final : CInstruction
    {
    public:
        explicit CSW_Interrupt(CInstruction instruction) noexcept;

        [[nodiscard]] std::uint32_t Get_Comment_Field() const noexcept;
    };
}