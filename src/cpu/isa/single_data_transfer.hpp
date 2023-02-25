#pragma once

#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    class CSingle_Data_Transfer final : CInstruction
    {
    public:
        explicit CSingle_Data_Transfer(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_I_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_P_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_B_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Immediate_Offset() const noexcept;
        [[nodiscard]] std::uint32_t Get_Shift() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };
}