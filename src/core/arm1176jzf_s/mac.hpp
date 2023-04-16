#pragma once

#include "isa/multiply.hpp"
#include "isa/multiply_long.hpp"

namespace zero_mate::arm1176jzf_s::mac
{
    struct TResult
    {
        std::uint32_t value_lo{};
        std::uint32_t value_hi{};
        bool set_fags{};
        bool n_flag{};
        bool z_flag{};
    };

    [[nodiscard]] TResult Execute(isa::CMultiply instruction, std::uint32_t reg_rm_val, std::uint32_t reg_rs_val, std::uint32_t reg_rn_val) noexcept;
    [[nodiscard]] TResult Execute(isa::CMultiply_Long instruction, std::uint32_t reg_rm_val, std::uint32_t reg_rs_val, std::uint32_t reg_rd_lo, std::uint32_t reg_rd_hi) noexcept;
}