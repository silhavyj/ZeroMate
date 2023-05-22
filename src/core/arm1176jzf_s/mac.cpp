// =====================================================================================================================
/// \file mac.cpp
/// \date 22. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the functionality of the CPU multiplier (MAC unit).
// =====================================================================================================================

// Project file imports

#include "mac.hpp"
#include "../utils/math.hpp"

namespace zero_mate::arm1176jzf_s::mac
{
    // Anonymous namespace to make its content visible only to this translation unit.
    namespace
    {
        // =============================================================================================================
        /// \brief Multiples two given values.
        /// \tparam Type Datatype used in the operation
        /// \param value1 First operand
        /// \param value2 Second operand
        /// \param acc_value Value to be added to the result
        /// \param accumulate Indication of whether it is a multiply or multiply-add operations.
        /// \return \p value1 * \p value2. If \p accumulate, \p acc_value is added to the result
        // =============================================================================================================
        template<typename Type>
        [[nodiscard]] std::uint64_t Multiply_Acc(Type value1, Type value2, Type acc_value, bool accumulate) noexcept
        {
            Type result_value = value1 * value2;

            if (accumulate)
            {
                result_value += acc_value;
            }

            return static_cast<std::uint64_t>(result_value);
        }
    }

    TResult Execute(isa::CMultiply instruction,
                    std::uint32_t reg_rm_val,
                    std::uint32_t reg_rs_val,
                    std::uint32_t reg_rn_val) noexcept
    {
        TResult result{};

        // Conversion to 64-bit variables
        const auto reg_rm_64u = static_cast<std::uint64_t>(reg_rm_val);
        const auto reg_rs_64u = static_cast<std::uint64_t>(reg_rs_val);
        const auto reg_rn_64u = static_cast<std::uint64_t>(reg_rn_val);

        // Perform the multiply-add operation itself.
        std::uint64_t result_64u = reg_rm_64u * reg_rs_64u;
        if (instruction.Is_A_Bit_Set())
        {
            result_64u += reg_rn_64u;
        }

        // Store the result of the operation.
        result.value_lo = static_cast<std::uint32_t>(result_64u);
        result.set_fags = instruction.Is_S_Bit_Set();

        // Check if any flags should be set.
        if (result.set_fags)
        {
            result.n_flag = utils::math::Is_Negative<std::uint32_t>(result.value_lo);
            result.z_flag = (result.value_lo == 0);
        }

        return result;
    }

    TResult Execute(isa::CMultiply_Long instruction,
                    std::uint32_t reg_rm_val,
                    std::uint32_t reg_rs_val,
                    std::uint32_t reg_rd_lo,
                    std::uint32_t reg_rd_hi) noexcept
    {
        TResult result{};
        std::uint64_t result_value_64u{};

        const auto reg_rs_32s = static_cast<std::int32_t>(reg_rs_val);
        const auto reg_rm_32s = static_cast<std::int32_t>(reg_rm_val);

        const auto reg_rs_64u = static_cast<std::uint64_t>(reg_rs_val);
        const auto reg_rm_64u = static_cast<std::uint64_t>(reg_rm_val);

        const auto reg_rs_64s = static_cast<std::int64_t>(reg_rs_32s);
        const auto reg_rm_64s = static_cast<std::int64_t>(reg_rm_32s);

        // Construct the acc value as an unsigned 64-bit integer
        const auto acc_value_64u =
        (static_cast<std::uint64_t>(reg_rd_hi) << 32U) + static_cast<std::uint64_t>(reg_rd_lo);

        // Convert it into a signed 64-bit integer as well.
        const auto acc_value_64s = static_cast<std::int64_t>(acc_value_64u);

        if (instruction.Is_U_Bit_Set())
        {
            // Perform the multiply-add operation (unsigned).
            result_value_64u = Multiply_Acc(reg_rs_64s, reg_rm_64s, acc_value_64s, instruction.Is_A_Bit_Set());
        }
        else
        {
            // Perform the multiply-add operation (signed).
            result_value_64u = Multiply_Acc(reg_rs_64u, reg_rm_64u, acc_value_64u, instruction.Is_A_Bit_Set());
        }

        // Store the results (split the 64 bits into 2 32-bit values)
        result.set_fags = instruction.Is_S_Bit_Set();
        result.value_hi = static_cast<std::uint32_t>((result_value_64u >> 32U) & 0xFFFFFFFFU);
        result.value_lo = static_cast<std::uint32_t>(result_value_64u & 0xFFFFFFFFU);

        // Check if any flags should be set.
        if (result.set_fags)
        {
            result.n_flag = utils::math::Is_Negative<std::uint64_t>(result_value_64u);
            result.z_flag = (result_value_64u == 0);
        }

        return result;
    }

} // namespace zero_mate::arm1176jzf_s::mac