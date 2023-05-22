// =====================================================================================================================
/// \file mac.hpp
/// \date 22. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the functionality of the CPU multiplier (MAC unit).
// =====================================================================================================================

#pragma once

// Project file imports

#include "isa/multiply.hpp"
#include "isa/multiply_long.hpp"

namespace zero_mate::arm1176jzf_s::mac
{
    // =================================================================================================================
    /// \struct TResult
    /// \brief Result of a multiplication operation
    // =================================================================================================================
    struct TResult
    {
        std::uint32_t value_lo{}; ///< Lower 32 bits of the result of the operation
        std::uint32_t value_hi{}; ///< Higher 32 bits of the result of the operation
        bool set_fags{};          ///< Indication of whether flags should be set of not
        bool n_flag{};            ///< Value of the N flag (negative flag)
        bool z_flag{};            ///< Value of the Z flag (zero flag)
    };

    // =================================================================================================================
    /// \brief Multiples two 32-bit values (the result it treated as a 32-value as well).
    ///
    /// If the A bit is set in the isa::CMultiply instruction. It adds the \p reg_rn_val value to the result of
    /// \p reg_rm_val * \p reg_rs_val.
    ///
    /// \param instruction Multiply instruction (32 bits)
    /// \param reg_rm_val First operand
    /// \param reg_rs_val Second operand
    /// \param reg_rn_val Value to be added to the result if the A bit is set
    /// \return \p reg_rm_val * \p reg_rs_val, if the A bit is NOT set.
    ///         Otherwise, it returns (\p reg_rm_val * \p reg_rs_val) + \p reg_rn_val.
    // =================================================================================================================
    [[nodiscard]] TResult Execute(isa::CMultiply instruction,
                                  std::uint32_t reg_rm_val,
                                  std::uint32_t reg_rs_val,
                                  std::uint32_t reg_rn_val) noexcept;

    // =================================================================================================================
    /// \brief Multiples two 32-bit values (the result is a 64-bit value split up into two 32-bit values).
    ///
    /// if the A bit is set in the isa::CMultiply_Long instruction, ((\p reg_rd_hi << 32U) | \p reg_rd_lo) is added
    /// to the final result of the multiplication (\p reg_rm_val * \p reg_rs_val). The result is treated as a 64-bit
    /// value split up into two 32-bit values.
    ///
    /// \param instruction Multiply long instruction
    /// \param reg_rm_val First operand
    /// \param reg_rs_val Second operand
    /// \param reg_rd_lo Lower 32 bits of the accumulate value
    /// \param reg_rd_hi Higher 32 bits of the accumulate value
    /// \return \p reg_rm_val * \p reg_rs_val is the A bit is not set.
    ///         Otherwise, it returns (\p reg_rm_val * \p reg_rs_val) + ((\p reg_rd_hi << 32U) | \p reg_rd_lo).
    // =================================================================================================================
    [[nodiscard]] TResult Execute(isa::CMultiply_Long instruction,
                                  std::uint32_t reg_rm_val,
                                  std::uint32_t reg_rs_val,
                                  std::uint32_t reg_rd_lo,
                                  std::uint32_t reg_rd_hi) noexcept;

} // namespace zero_mate::arm1176jzf_s::mac