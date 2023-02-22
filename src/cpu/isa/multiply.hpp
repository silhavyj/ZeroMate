#pragma once

#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    class CMultiply final : public CInstruction
    {
    public:
        explicit CMultiply(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_A_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rs() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };
}