// ---------------------------------------------------------------------------------------------------------------------
/// \file extend.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an extend instruction.
///
/// The following instructions are considered to be extend instructions:
/// SXTAB16, UXTAB16, SXTB16, UXTB16, SXTAB, UXTAB, SXTB, UXTB, SXTAH, UXTAH, SXTH, and UXTH.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/sxtab16 (the other instruction types
/// can be find in the next sections).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CExtend
    /// \brief This class represents an extend instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CExtend final : CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief This enumeration represents different types of the extend instruction.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            // Category (0)

            SXTAB16 = 0, ///< Sign extend two Bytes with Add, to extend two 8-bit values to two 16-bit values
            UXTAB16 = 1, ///< Zero extend two Bytes and Add
            SXTB16 = 2,  ///< Sign extend two bytes
            UXTB16 = 3,  ///< Zero extend two Bytes

            // Category (1)

            SXTAB = 4,   ///< Sign extend Byte with Add, to extend an 8-bit value to a 32-bit value
            UXTAB = 5,   ///< Zero extend Byte and Add
            SXTB = 6,    ///< Sign extend Byte, to extend an 8-bit value to a 32-bit value
            UXTB = 7,    ///< Zero extend Byte

            // Category (2)

            SXTAH = 8,   ///< Sign extend Halfword with Add, to extend a 16-bit value to a 32-bit value
            UXTAH = 9,   ///< Zero extend Halfword and Add
            SXTH = 10,   ///< Sign extend Halfword
            UXTH = 11    ///< Zero extend Halfword
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CExtend(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the extend instruction (what operation shall be performed).
        /// \return Type of the extend instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (value to be added to the result).
        /// \return Index of the Rn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Return the index of the Rd register (destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Value by which the Rm register (see #Get_Rm_Idx) will be right-roted (ROR).
        ///
        /// ROR #8 (value from Rm is rotated right 8 bits);
        /// ROR #16 (value from Rm is rotated right 16 bits);
        /// ROR #24 (value from Rm is rotated right 24 bits)
        ///
        /// \return Value (amount) used to rotate the contents of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rot() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register (register to be rotated).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCategory_Mask
        /// \brief This enumeration is used to determine the type of the extend instruction.
        ///
        /// It is a helper technique to figure out the type using different bit masks (bits 22, 21, and 20).
        /// Category_1_1 means the first type in category (1).
        // -------------------------------------------------------------------------------------------------------------
        enum class NCategory_Mask
        {
            Category_0_0 = 0b000, ///< Category 0, item 0 (SXTAB16)
            Category_0_1 = 0b100, ///< Category 0, item 1 (UXTAB16)
            Category_1_0 = 0b010, ///< Category 1, item 0 (SXTAB)
            Category_1_1 = 0b110, ///< Category 1, item 1 (UXTAB)
            Category_2_0 = 0b011, ///< Category 2, item 0 (SXTAH)
            Category_2_1 = 0b111, ///< Category 2, item 1 (UXTAH)
        };
    };

} // namespace zero_mate::arm1176jzf_s::isa