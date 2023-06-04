// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor_register_transfer.hpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a coprocessor register transfer (MRC, MCR).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/mrc-and-mrc2
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/mcr-and-mcr2
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCoprocessor_Reg_Transfer
    /// \brief This class represents a coprocessor register transfer instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CCoprocessor_Reg_Transfer final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CCoprocessor_Reg_Transfer(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the coprocessor operation mode (3-bit coprocessor-specific code).
        /// \return Coprocessor operation mode
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Opcode1() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the L bit (bit 20 = load/store bit).
        ///
        /// 0 = Store to Co-Processor;
        /// 1 = Load from Co-Processor
        ///
        /// \return true, if the L bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the CRn register (coprocessor source/destination register).
        /// \return Index of the CRn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CRn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (ARM source/destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the coprocessor number (ID of the coprocessor involved in the register transfer).
        /// \return Coprocessor ID
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Coprocessor_ID() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns coprocessor information (optional 3-bit coprocessor-specific opcode).
        /// \return Coprocessor information (opcode 2)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Opcode2() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the CRm register (coprocessor operand register).
        /// \return Index of the CRm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CRm_Idx() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa