#pragma once

#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    class CMultiply_Long final : public CInstruction
    {
    public:
        explicit CMultiply_Long(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_A_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_RdHi() const noexcept;
        [[nodiscard]] std::uint32_t Get_RdLo() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rs() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };
}