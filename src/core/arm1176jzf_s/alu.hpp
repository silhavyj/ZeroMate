// =====================================================================================================================
/// \file alu.hpp
/// \date 22. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the functionality of the arithmetic logic unit (ALU).
// =====================================================================================================================

#pragma once

// Project file imports

#include "isa/data_processing.hpp"

namespace zero_mate::arm1176jzf_s::alu
{
    // =================================================================================================================
    /// \struct TResult
    /// \brief Result of an ALU operation.
    // =================================================================================================================
    struct TResult
    {
        std::uint32_t value{}; ///< Result of the operation itself
        bool write_back{};     ///< Indication of whether the result should be written back
        bool set_flags{};      ///< Indication of flags should be updated after the operation
        bool n_flag{};         ///< N flag (negative)
        bool z_flag{};         ///< Z flag (zero)
        bool c_flag{};         ///< C flag (carry)
        bool v_flag{};         ///< V flag (overflow)
    };

    // =================================================================================================================
    /// \brief Performs an ALU operation.
    /// \param instruction Data processing instruction (holds information about the type of the operation)
    /// \param first_operand First operand
    /// \param second_operand Second operand
    /// \param carry_out Carry out from the previous operation (calculation of the second operand)
    /// \param cpu_c_flag Current value of the C flag (carry) in the CPSR register
    /// \param cpu_v_flag Current value of the V flag (overflow) in the CPSR register
    /// \return Result of the operation
    // =================================================================================================================
    [[nodiscard]] TResult Execute(isa::CData_Processing instruction,
                                  std::uint32_t first_operand,
                                  std::uint32_t second_operand,
                                  bool carry_out,
                                  bool cpu_c_flag,
                                  bool cpu_v_flag) noexcept;

} // namespace zero_mate::arm1176jzf_s::alu