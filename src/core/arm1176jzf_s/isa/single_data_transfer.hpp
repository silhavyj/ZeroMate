// ---------------------------------------------------------------------------------------------------------------------
/// \file single_data_transfer.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines single data transfer instruction (LDR, STR).
///
/// To find more information about this instruction, please visit
/// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.9)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSingle_Data_Transfer
    /// \brief This class represents a single data transfer instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CSingle_Data_Transfer final : CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CSingle_Data_Transfer(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the I bit (immediate offset).
        ///
        /// 0 = offset is an immediate value;
        /// 1 = offset is a register
        ///
        /// \return true, if the I bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_I_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the P bit (pre/post indexing bit).
        ///
        /// 0 = post (add offset after transfer);
        /// 1 = pre (add offset before transfer)
        ///
        /// \return true, if the P bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_P_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the U bit (up/down bit).
        ///
        /// 0 = down (subtract offset from base);
        /// 1 = up (add offset to base)
        ///
        /// \return true, if the U bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the B bit (byte/word bit).
        ///
        /// 0 = transfer word quantity;
        /// 1 = transfer byte quantity
        ///
        /// \return true, if the B bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_B_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the W bit (write-back bit).
        ///
        /// 0 = no write-back;
        /// 1 = write address into base
        ///
        /// \return true, if the W bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the L bit (load/store bit).
        ///
        /// 0 = Store to memory;
        /// 1 = Load from memory
        ///
        /// \return true, if the L bit is set. false, otherwise
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
        /// \brief Return the immediate offset value (see #Is_I_Bit_Set).
        /// \return Immediate offset
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Immediate_Offset() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register (offset register).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the shift amount to be applied to the Rm register.
        /// \return Shift amount
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Shift_Amount() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of a shift operation to applied to the Rm register.
        /// \return Type of the shift operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NShift_Type Get_Shift_Type() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa