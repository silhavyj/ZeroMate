// ---------------------------------------------------------------------------------------------------------------------
/// \file multiply.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a multiplication instruction (MUL, MLA).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-multiply-instructions/MUL-and-MLA
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CMultiply
    /// \brief This class represents a multiplication instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CMultiply final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CMultiply(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the A bit (accumulate).
        ///
        /// 0 = multiply only;
        /// 1 = multiply and accumulate
        ///
        /// \return true, if the A bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_A_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the S bit (Set condition flags).
        ///
        /// 0 = do not alter condition codes;
        /// 1 = set condition codes
        ///
        /// \return true, if the S bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (accumulate value).
        ///
        /// If the A bit is set (see #Is_A_Bit_Set), the value stored in this register will be added to the
        /// final result of the multiplication.
        ///
        /// \return Index of the Rn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rs register (first operand).
        /// \return Index of the Rs register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rs_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register (second operand).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa