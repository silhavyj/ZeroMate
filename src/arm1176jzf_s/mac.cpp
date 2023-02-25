#include "mac.hpp"
#include "../utils/math.hpp"

namespace zero_mate::arm1176jzf_s::mac
{
    TResult Execute(isa::CMultiply instruction, std::uint32_t reg_rm, std::uint32_t reg_rs, std::uint32_t reg_rn) noexcept
    {
        TResult result{};

        const auto reg_rm_64u = static_cast<std::uint64_t>(reg_rm);
        const auto reg_rs_64u = static_cast<std::uint64_t>(reg_rs);
        const auto reg_rn_64u = static_cast<std::uint64_t>(reg_rn);

        std::uint64_t result_64u = reg_rm_64u * reg_rs_64u;

        if (instruction.Is_A_Bit_Set())
        {
            result_64u += reg_rn_64u;
        }

        result.value_lo = static_cast<std::uint32_t>(result_64u);
        result.set_fags = instruction.Is_S_Bit_Set();

        if (result.set_fags)
        {
            result.n_flag = utils::math::Is_Negative<std::uint32_t>(result.value_lo);
            result.z_flag = (result.value_lo == 0);
        }

        return result;
    }

    template<typename Type>
    [[nodiscard]] static std::uint64_t Multiply_Acc(Type value1, Type value2, Type acc_value, bool accumulate) noexcept
    {
        Type result_value = value1 * value2;

        if (accumulate)
        {
            result_value += acc_value;
        }

        return static_cast<std::uint64_t>(result_value);
    }

    TResult Execute(isa::CMultiply_Long instruction, std::uint32_t reg_rm, std::uint32_t reg_rs, std::uint32_t reg_rd_lo, std::uint32_t reg_rd_hi) noexcept
    {
        TResult result{};
        std::uint64_t result_value_64u{};

        const auto reg_rs_32s = static_cast<std::int32_t>(reg_rs);
        const auto reg_rm_32s = static_cast<std::int32_t>(reg_rm);

        const auto reg_rs_64u = static_cast<std::uint64_t>(reg_rs);
        const auto reg_rm_64u = static_cast<std::uint64_t>(reg_rm);

        const auto reg_rs_64s = static_cast<std::int64_t>(reg_rs_32s);
        const auto reg_rm_64s = static_cast<std::int64_t>(reg_rm_32s);

        const auto acc_value_64u = (static_cast<std::uint64_t>(reg_rd_hi) << 32U) + static_cast<std::uint64_t>(reg_rd_lo);
        const auto acc_value_64s = static_cast<std::int64_t>(acc_value_64u);

        if (instruction.Is_U_Bit_Set())
        {
            result_value_64u = Multiply_Acc(reg_rs_64s, reg_rm_64s, acc_value_64s, instruction.Is_A_Bit_Set());
        }
        else
        {
            result_value_64u = Multiply_Acc(reg_rs_64u, reg_rm_64u, acc_value_64u, instruction.Is_A_Bit_Set());
        }

        result.set_fags = instruction.Is_S_Bit_Set();
        result.value_hi = static_cast<std::uint32_t>((result_value_64u >> 32U) & 0xFFFFFFFFU);
        result.value_lo = static_cast<std::uint32_t>(result_value_64u & 0xFFFFFFFFU);

        if (result.set_fags)
        {
            result.n_flag = utils::math::Is_Negative<std::uint64_t>(result_value_64u);
            result.z_flag = (result_value_64u == 0);
        }

        return result;
    }
}