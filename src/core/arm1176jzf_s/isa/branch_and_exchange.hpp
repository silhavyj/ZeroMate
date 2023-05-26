// ---------------------------------------------------------------------------------------------------------------------
/// \file branch_and_exchange.hpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a branch and exchange instruction (BX).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/bx
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CBranch_And_Exchange
    /// \brief This class represents a branch and exchange instruction (it is inherited from the CInstruction class).
    // -----------------------------------------------------------------------------------------------------------------
    class CBranch_And_Exchange final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCPU_Instruction_Mode
        /// \brief This enumeration represents different instruction sets an ARM CPU can use.
        /// \note The Thumb instruction set is not supported by the emulator
        // -------------------------------------------------------------------------------------------------------------
        enum class NCPU_Instruction_Mode : std::uint8_t
        {
            ARM = 0,  ///< ARM instruction set (32-bit encoding)
            Thumb = 1 ///< Thumb instruction set (16-bit encoding; not supported by the emulator)
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CBranch_And_Exchange(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the L bit (bit 5).
        ///
        /// 0 = Branch;
        /// 1 = Branch with Link
        ///
        /// \return true, if the L bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the mode the CPU will switch to after executing this instruction.
        ///
        /// If the least significant bit of the Rm register is set to 1, the CPU will switch to the
        /// NCPU_Instruction_Mode::Thumb mode. Otherwise, the CPU will remain in the NCPU_Instruction_Mode::ARM mode.
        ///
        /// \param rm_reg_value Value of the Rm register (destination address)
        /// \return Mode of the CPU
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NCPU_Instruction_Mode Get_Instruction_Mode(std::uint32_t rm_reg_value) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register holding the value of the destination address.
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa