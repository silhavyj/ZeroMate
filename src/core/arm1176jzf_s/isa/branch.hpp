// ---------------------------------------------------------------------------------------------------------------------
/// \file branch.hpp
/// \date 25. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a branch instruction (B, BL).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0068/b/CIHFDDAF
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CBranch
    /// \brief This class represents a branch instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CBranch final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CBranch(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the L bit (bit 24).
        ///
        /// 0 = Branch;
        /// 1 = Branch with Link
        ///
        /// \return true, if the L bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the offset of the branch instruction.
        ///
        /// The offset is stored as a signed 2's complement 24-bit value. It is added to the current value
        /// of the PC address to determine the destination address.
        ///
        /// \return Offset of the branch instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::int32_t Get_Offset() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa