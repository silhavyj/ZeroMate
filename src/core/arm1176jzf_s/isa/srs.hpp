// ---------------------------------------------------------------------------------------------------------------------
/// \file srs.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an SRS instruction (store return state onto a stack).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/srs
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSRS
    /// \brief his class represents an SRS instruction (store return state onto a stack).
    // -----------------------------------------------------------------------------------------------------------------
    class CSRS final : CInstruction
    {
    public:
        /// Total number of register to be transferred (stored on the stack).
        static constexpr std::size_t Number_Of_Regs_To_Transfer = 2;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NAddressing_Mode
        /// \brief Addressing mode used in the data transfer.
        // -------------------------------------------------------------------------------------------------------------
        enum class NAddressing_Mode : std::uint32_t
        {
            IB = 0b11, ///< Increment before
            IA = 0b01, ///< Increment after
            DB = 0b10, ///< Decrement before
            DA = 0b00  ///< Decrement after
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CSRS(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the addressing mode used in the instruction.
        /// \return Addressing mode
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NAddressing_Mode Get_Addressing_Mode() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the W bit.
        ///
        /// If the W bit is set, the final address is written back into the SP of the mode specified by #Get_CPU_Mode.
        ///
        /// \return true, if the W bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the mode of the CPU used in the instruction.
        ///
        /// Specification of the mode whose banked SP is used as the base register.
        ///
        /// \return Mode of the CPU
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CPU_Mode() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns whether the Rn register should be decremented or not (helper function).
        ///
        /// The Rn register should be decremented if CRFE::NAddressing_Mode is either DB or DA.
        ///
        /// \return true, if the Rn register should be decremented. false, if it should be incremented
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Should_SP_Be_Decremented() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa