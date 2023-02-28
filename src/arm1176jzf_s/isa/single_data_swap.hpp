#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CSingle_Data_Swap final : public CInstruction
    {
    public:
        explicit CSingle_Data_Swap(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_B_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };
}