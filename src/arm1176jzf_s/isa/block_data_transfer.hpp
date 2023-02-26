#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CBlock_Data_Transfer final : CInstruction
    {
    public:
        explicit CBlock_Data_Transfer(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_P_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;

        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Register_List() const noexcept;
    };
}