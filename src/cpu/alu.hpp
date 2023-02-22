#pragma once

#include "ARM1176JZF_S.hpp"
#include "isa/data_processing.hpp"

namespace zero_mate::cpu::alu
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

    [[nodiscard]] TResult Execute(const CARM1176JZF_S& cpu, isa::CData_Processing instruction, std::uint32_t first_operand, std::uint32_t second_operand, std::uint32_t dest_reg, bool carry_out);
}