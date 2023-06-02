// ---------------------------------------------------------------------------------------------------------------------
/// \file rfe.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an RFE instruction (return from exception).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/rfe
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CRFE
    /// \brief This class represents an RFE instruction (return from exception).
    // -----------------------------------------------------------------------------------------------------------------
    class CRFE final : CInstruction
    {
    public:
        /// Total number of register to be transferred (popped off the stack).
        static constexpr std::size_t NUMBER_OF_REGS_TO_TRANSFER = 2;

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
        explicit CRFE(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the addressing mode used in the instruction.
        /// \return Addressing mode
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NAddressing_Mode Get_Addressing_Mode() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the W bit (the final address is written back into Rn).
        /// \return true, if the W bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (base address).
        /// \return Index of the Rn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns whether the Rn register should be decremented or not (helper function).
        ///
        /// The Rn register should be decremented if CRFE::NAddressing_Mode is either DB or DA.
        ///
        /// \return true, if the Rn register should be decremented. false, if it should be incremented
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Should_Rn_Be_Decremented() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa