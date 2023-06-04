// ---------------------------------------------------------------------------------------------------------------------
/// \file data_processing.hpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a data processing instruction.
///
/// The following instructions are considered to be data processing instructions:
/// AND, EOR, SUB, RSB, ADD, ADC, SBS, RSC, TST, TEQ, CMP, CMN, ORR, MOV, BIC, and MVN.
///
/// To find more information about this instruction, please visit
/// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.5)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CData_Processing
    /// \brief This class represents a data processing instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CData_Processing final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NOpcode
        /// \brief This enumeration represents different opcodes determining the type of the instruction.
        // -------------------------------------------------------------------------------------------------------------
        enum class NOpcode : std::uint32_t
        {
            AND = 0b0000, ///< operand1 AND operand2
            EOR = 0b0001, ///< operand1 EOR operand2
            SUB = 0b0010, ///< operand1 - operand2
            RSB = 0b0011, ///< operand2 - operand1
            ADD = 0b0100, ///< operand1 + operand2
            ADC = 0b0101, ///< operand1 + operand2 + carry
            SBC = 0b0110, ///< operand1 - operand2 + carry - 1
            RSC = 0b0111, ///< operand2 - operand1 + carry - 1
            TST = 0b1000, ///< as AND, but result is not written
            TEQ = 0b1001, ///< as EOR, but result is not written
            CMP = 0b1010, ///< as SUB, but result is not written
            CMN = 0b1011, ///< as ADD, but result is not written
            ORR = 0b1100, ///< operand1 OR operand2
            MOV = 0b1101, ///< operand2(operand1 is ignored)
            BIC = 0b1110, ///< operand1 AND NOT operand2(Bit clear)
            MVN = 0b1111  ///< NOT operand2(operand1 is ignored)
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CData_Processing(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the I bit (bit 25 = immediate second operand).
        /// \return true, if the I bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_I_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Return the opcode of the instruction (what kind of operation shall be performed).
        /// \return Opcode of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NOpcode Get_Opcode() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the S bit (bit 20 = set flags).
        ///
        /// 0 = do not alter condition codes;
        /// 1 = set condition codes
        ///
        /// \return true, if the S bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the first operand register (Rn).
        /// \return Index of the Rn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the destination register (Rd).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the shift amount used when constructing the second operand (immediate second operand).
        /// \return Shift amount used to construct the second operand
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Shift_Amount() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the shift type used when constructing the second operand.
        /// \return Shift type used to construct the second operand
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NShift_Type Get_Shift_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether or not an immediate shift should be applied (bit 4).
        /// \return true, if an immediate shift should take place. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Immediate_Shift() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the shift register (Rs).
        /// \return Index of the shift register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rs_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the second operand register (Rm).
        /// \return Index of the second operand register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the shift amount to be applied to the immediate value.
        /// \return Shift amount the immediate value will be rotated/shifted by
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rotate() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Return the immediate value (unsigned 8-bit value).
        /// \return Immediate value used to construct the second operand
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Immediate() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa