#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CCLZ final : public CInstruction
    {

    public:
        explicit CCLZ(CInstruction instruction) noexcept;

        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };
}