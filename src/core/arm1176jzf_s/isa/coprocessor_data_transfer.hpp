// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor_data_transfer.hpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a coprocessor data transfer (LDC, STC).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/ldc-and-ldc2,
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/stc-and-stc2
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCoprocessor_Data_Transfer
    /// \brief This class represents a coprocessor data transfer instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CCoprocessor_Data_Transfer final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CCoprocessor_Data_Transfer(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the P bit (bit 24).
        ///
        /// 0 = post (add offset after transfer);
        /// 1 = pre (add offset before transfer)
        ///
        /// \return true, if the P bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_P_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the U bit (bit 23).
        ///
        /// 0 = down (subtract offset from base);
        /// 1 = up (add offset to base)
        ///
        /// \return true, if the U bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the N bit (bit 22 = transfer length).
        /// \return true, if the N bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_N_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the W bit (bit 21).
        ///
        /// 0 = no write-back;
        /// 1 = write address into base
        ///
        /// \return true, if the W bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the L bit (bit 20).
        ///
        /// 0 = Store to memory;
        /// 1 = Load from memory
        ///
        /// \return true, if the L bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (ARM register involved in the transfer).
        /// \return Index of the Rn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the the CRd register (coprocessor register involved in the transfer).
        /// \return Index of the CRd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CRd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the coprocessor number (ID of the coprocessor involved in the data transfer).
        /// \return Coprocessor ID
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Coprocessor_ID() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns an unsigned 8-bit immediate offset.
        /// \return Immediate offset
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Offset() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa