// ---------------------------------------------------------------------------------------------------------------------
/// \file cps.hpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a change processor state instruction (CPS).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0489/c/arm-and-thumb-instructions/miscellaneous-instructions/cps
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCPS
    /// \brief This class represents a change processor state instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CCPS final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief This enumeration defines the type of the instruction (operation it performs)
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            CPSIE = 0b10U, ///< Interrupt of abort enable
            CPSID = 0b11U  ///< Interrupt of abort disable
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CCPS(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the operation (see NType).
        /// \return Type of the operation performed by the instruction.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the M bit (bit 17).
        ///
        /// If the M bit is set, the mode of the CPU will be changed to the value stored in the least
        /// significant 5 bits of the instruction (see #Get_Mode).
        ///
        /// \return true, if the M bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_M_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the A bit (bit 8).
        ///
        /// If the A bit is set, the A flag in the CPSR register will be either enabled/disabled based on CCPS::NType.
        ///
        /// \return true, if the A bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_A_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the I bit (bit 7 = interrupts).
        ///
        /// If the I bit is set, interrupts (I flag in CPSR) will be either enabled/disabled based on CCPS::NType.
        ///
        /// \return true, if the I bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_I_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the F bit (bit 6 = i nterrupts).
        ///
        /// If the I bit is set, fast interrupts (F flag in CPSR) will be either enabled/disabled based on CCPS::NType.
        ///
        /// \return true, if the F bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_F_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the new mode of the CPU (5 bits).
        ///
        /// If the M bit is set (see #Is_M_Bit_Set), the value returned from this function will be the new
        /// mode of the CPU.
        ///
        /// \return New mode of the CPU
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Mode() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa