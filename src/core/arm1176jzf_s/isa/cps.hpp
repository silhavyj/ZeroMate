#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CCPS final : public CInstruction
    {
    public:
        enum class NType : std::uint32_t
        {
            CPSIE = 0b10U,
            CPSID = 0b11U
        };

        explicit CCPS(CInstruction instruction) noexcept;

        [[nodiscard]] NType Get_Type() const noexcept;
        [[nodiscard]] bool Is_M_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_A_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_I_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_F_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Mode() const noexcept;
    };
}