#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CSRS final : CInstruction
    {
    public:
        enum class NAddressing_Mode : std::uint32_t
        {
            IB = 0b11, // Increment before
            IA = 0b01, // Increment after
            DB = 0b10, // Decrement before
            DA = 0b00  // Decrement after
        };

    public:
        explicit CSRS(CInstruction instruction) noexcept;

        [[nodiscard]] NAddressing_Mode Get_Addressing_Mode() const noexcept;
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_CPU_Mode() const noexcept;
        [[nodiscard]] bool Should_Be_Decremented() const noexcept;
    };
}