// ---------------------------------------------------------------------------------------------------------------------
/// \file halfword_data_transfer.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a Halfword data transfer instruction.
///
/// The following instructions are considered to be Halfword data transfer instruction:
/// LDRH, STRH, LDRSB, and LDRSH.
///
/// To find more information about this instruction, please visit
/// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.10)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CHalfword_Data_Transfer
    /// \brief This class represents a Halfword data transfer instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CHalfword_Data_Transfer final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief This enumeration defines different types of the instruction.
        /// \note Signed Halfwords shall not be stored
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            SWP = 0b00,                ///< SWP instruction // TODO this is not used in ARMv6?
            Unsigned_Halfwords = 0b01, ///< Unsigned halfwords (LDRH, STRH)
            Signed_Byte = 0b10,        ///< Signed byte (LDRSB)
            Signed_Halfwords = 0b11    ///< Signed halfwords (LDRSH)
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CHalfword_Data_Transfer(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the P bit (pre/post indexing).
        ///
        /// 0 = post: add/subtract offset after transfer;
        /// 1 = pre: add/subtract offset before transfer
        ///
        /// \return true, if the P bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_P_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the U bit (up/down).
        ///
        /// 0 = down: subtract offset from base;
        /// 1 = up: add offset to base
        ///
        /// \return true, if the U bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns whether or not the instruction uses an immediate value.
        /// \return true, if an immediate value is used. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Immediate_Offset() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the W bit (write-back).
        ///
        /// 0 = no write-back;
        /// 1 = write address into base
        ///
        /// \return true, if the W bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the L bit (Load/Store).
        ///
        /// 0 = store to memory;
        /// 1 = load from memory
        ///
        /// \return true, if the L bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (base register).
        /// \return Index of the Rn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (source/destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register (offset register).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns immediate offset high (high nibble).
        /// \return Immediate offset high
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Immediate_Offset_High() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns immediate offset low (low nibble).
        /// \return Immediate offset low
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Immediate_Offset_Low() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the instruction (see CHalfword_Data_Transfer::NType).
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa