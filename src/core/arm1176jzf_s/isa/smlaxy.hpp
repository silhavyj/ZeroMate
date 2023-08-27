// ---------------------------------------------------------------------------------------------------------------------
/// \file smlaxy.hpp
/// \date 25. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a SMLAxy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-multiply-instructions/SMLAxy
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSMLAxy
    /// \brief This class represents a CSMLAxy instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CSMLAxy final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief This enumeration represents different types of the CSMLAxy instruction.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            BB = 0b00U, ///< Lower 16 bits of Rm * lower 16 bit of Rs
            BT = 0b10U, ///< Lower 16 bits of Rm * upper 16 bit of Rs
            TB = 0b01U, ///< Upper 16 bits of Rm * lower 16 bit of Rs
            TT = 0b11U  ///< Upper 16 bits of Rm * upper 16 bit of Rs
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CSMLAxy(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (accumulate).
        /// \return Index of the Rs register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rs register (operand 2).
        /// \return Index of the Rs register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rs_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register (operand 1).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the SMLAxy instruction.
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa
