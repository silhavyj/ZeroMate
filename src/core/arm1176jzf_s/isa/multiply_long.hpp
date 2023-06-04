// ---------------------------------------------------------------------------------------------------------------------
/// \file multiply_long.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a multiplication (long) instruction.
///
/// The following instructions are considered to be multiplication long instructions:
/// UMULL, UMLAL, SMULL, and SMLAL.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/umull (the other instruction types
/// can be found in the following sections).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CMultiply_Long
    /// \brief This class represents a multiplication long instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CMultiply_Long final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CMultiply_Long(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the U bit (unsigned).
        ///
        /// 0 = unsigned;
        /// 1 = signed
        ///
        /// \return true, if the U bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the A bit (accumulate).
        ///
        /// 0 = multiply only;
        /// 1 = multiply and accumulate
        ///
        /// \return true, if the A bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_A_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the S bit (set condition flags).
        ///
        /// The accumulate value is the current contents of the Rd registers (low, high).
        /// 0 = do not alter condition codes;
        /// 1 = set condition codes
        ///
        /// \return true, if the S bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the destination register holding the upper 32-bits of the result.
        /// \return Index of the Rd (high) register.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Hi_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the destination register holding the lower 32-bits of the result.
        /// \return Index of the Rd (low) register.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Lo_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the the Rs register (first operand).
        /// \return Index of the Rs register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rs_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the the Rm register (second operand).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa