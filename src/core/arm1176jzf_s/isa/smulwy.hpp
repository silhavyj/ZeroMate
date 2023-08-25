// ---------------------------------------------------------------------------------------------------------------------
/// \file smulwy.hpp
/// \date 23. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a SMULWy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/ddi0597/2020-12/Base-Instructions/
/// SMULWB--SMULWT--Signed-Multiply--word-by-halfword--
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSMULWy
    /// \brief This class represents a CSMULWy instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CSMULWy final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief Enumeration of different types of the instruction.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            B = 0, ///< Take the lower 16-bits of the second operand
            T = 1  ///< Take the upper 16-bits of the second operand
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CSMULWy(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rs register (operand 1).
        /// \return Index of the Rs register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rs_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register (operand 2).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the CSMULWy instruction.
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa