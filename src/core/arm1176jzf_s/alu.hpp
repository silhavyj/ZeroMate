#pragma once

#include "cpu_core.hpp"
#include "isa/data_processing.hpp"

namespace zero_mate::arm1176jzf_s::alu
{
    struct TResult
    {
        std::uint32_t value{};
        bool write_back{};
        bool set_flags{};
        bool n_flag{};
        bool z_flag{};
        bool c_flag{};
        bool v_flag{};
    };

    [[nodiscard]] TResult Execute(const CCPU_Core& cpu, isa::CData_Processing instruction, std::uint32_t first_operand, std::uint32_t second_operand, bool carry_out) noexcept;
}