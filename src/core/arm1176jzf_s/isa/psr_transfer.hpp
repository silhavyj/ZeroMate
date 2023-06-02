// ---------------------------------------------------------------------------------------------------------------------
/// \file psr_transfer.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a PSR instruction (MRS, MSR).
///
/// To find more information about this instruction, please visit
/// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.6)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CPSR_Transfer
    /// \brief This class represents a PSR instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CPSR_Transfer final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NRegister
        /// \brief This enumeration represents the special registers that can be involved in the operation.
        // -------------------------------------------------------------------------------------------------------------
        enum class NRegister : std::uint32_t
        {
            CPSR = 0, ///< CPSR register (current processor state register)
            SPSR = 1  ///< SPSR register (saved processor state register)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief This enumeration represents the type of operation to be performed.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            MRS = 0, ///< Transfer PSR contents to an ARM register
            MSR = 1  ///< Transfer the content of an ARM register to PSR
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CPSR_Transfer(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the special register involved in the operation.
        /// \return Type of the special register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NRegister Get_Register_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the operation to be performed.
        /// \return Type of the operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register (source register; see #Is_Immediate).
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rd register (destination register).
        /// \return Index of the Rd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a mask that protects different part of the special register.
        ///
        /// The special register is divided up to 4 parts: flag bits, status bits, extension bits, and control bits
        /// (see https://www.ques10.com/p/54453/explain-functions-of-different-registers-availab-1/).
        ///
        /// \return Mask to protect different parts of the special register when setting a new value to it
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Mask() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the I bit.
        ///
        /// 0 = source operand is a register;
        /// 1 = source operand is an immediate value
        ///
        /// \return true, if the I bit is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Immediate() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the shift amount to be applied to the immediate value.
        /// \return Value the immediate value will be rotated by
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rotate() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the immediate value (source value; see #Is_Immediate).
        /// \return Immediate value
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Immediate() const noexcept;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the F bit (helper function).
        ///
        /// If the F bit is set, the flag bits of the special register will remain unaffected.
        ///
        /// \return true, if the F bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_F_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the S bit (helper function).
        ///
        /// If the S bit is set, the status bits of the special register will remain unaffected.
        ///
        /// \return true, if the S bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_S_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the X bit (helper function).
        ///
        /// If the X bit is set, the extension bits of the special register will remain unaffected.
        ///
        /// \return true, if the X bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_X_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the C bit (helper function).
        ///
        /// If the C bit is set, the control bits of the special register will remain unaffected.
        ///
        /// \return true, if the C bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_C_Bit_Set() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa