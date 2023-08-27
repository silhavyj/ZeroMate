// ---------------------------------------------------------------------------------------------------------------------
/// \file smulxy.hpp
/// \date 22. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a SMULxy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/100235/0004/the-cortex-m33-instruction-set/multiply-and-divide-instructions/
/// smul-and-smulw?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSMULxy
    /// \brief This class represents a SMULxy instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CSMULxy final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief This enumeration represents different types of the SMULxy instruction.
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
        explicit CSMULxy(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

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
        /// \brief Returns the type of the SMULxy instruction.
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa
