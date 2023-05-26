// ---------------------------------------------------------------------------------------------------------------------
/// \file block_data_transfer.hpp
/// \date 25. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a block data transfer instruction (LDM, STM).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/ldm,
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/stm
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CBlock_Data_Transfer
    /// \brief This class represents a data block transfer instruction (it is inherited from the CInstruction class).
    // -----------------------------------------------------------------------------------------------------------------
    class CBlock_Data_Transfer final : CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NAddressing_Mode
        /// \brief Addressing mode used in the block data transfer instruction.
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
        explicit CBlock_Data_Transfer(CInstruction instruction) noexcept;

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
        /// \brief Returns the value of the S bit (bit 22).
        ///
        /// 0 = do not load PSR or force user mode;
        /// 1 = load PSR or force user mode
        ///
        /// \return true, if the S bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;

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
        /// \brief Returns the addressing mode used in the instruction.
        /// \return Addressing mode
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NAddressing_Mode Get_Addressing_Mode() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rn register (base register).
        /// \return Index of the base register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a list of registers to be transferred.
        ///
        /// Each bits represents a register index. If the bit is set to a 1, the corresponding register will be
        /// transferred. Otherwise, the register will be skipped.
        ///
        /// \return List of registers to be transferred
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Register_List() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa