// ---------------------------------------------------------------------------------------------------------------------
/// \file smlawy.hpp
/// \date 25. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a SMLAWy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/ddi0597/2020-12/Base-Instructions/SMLAWB--SMLAWT--
/// Signed-Multiply-Accumulate--word-by-halfword--?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSMLAWy
    /// \brief This class represents a CSMLAWy instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CSMLAWy final : CInstruction
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
        explicit CSMLAWy(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (accumulate value).
        /// \return Index of the Rn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

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
        /// \brief Returns the type of the CSMLAWy instruction.
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa