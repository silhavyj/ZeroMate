// ---------------------------------------------------------------------------------------------------------------------
/// \file instruction.hpp
/// \date 25. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the interface of a general ARM instruction.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
#include <cstddef>
/// \endcond

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CInstruction
    /// \brief This class represents a parent class for all ARM instructions used in the emulator.
    // -----------------------------------------------------------------------------------------------------------------
    class CInstruction
    {
    public:
        // TODO do this better
        /// Average number of cycles it takes the CPU to execute an instruction.
        static constexpr std::uint32_t Average_CPI{ 8 };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCondition
        /// \brief This enumeration defines different condition flags that can set in an instruction.
        ///
        /// Whether a condition is going to be executed is determined by these flags. Check out
        /// https://developer.arm.com/documentation/dui0801/g/Condition-Codes/Condition-code-suffixes.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCondition : std::uint32_t
        {
            EQ = 0b0000,           ///< Z set; equal
            NE = 0b0001,           ///< Z clear; not equal
            HS = 0b0010,           ///< C set; unsigned higher or same
            LO = 0b0011,           ///< C clear; unsigned lower
            MI = 0b0100,           ///< N set; negative
            PL = 0b0101,           ///< N clear; positive or zero
            VS = 0b0110,           ///< V set; overflow
            VC = 0b0111,           ///< V clear; no overflow
            HI = 0b1000,           ///< C set and Z clear; unsigned higher
            LS = 0b1001,           ///< C clear or Z set; unsigned lower or same
            GE = 0b1010,           ///< N equals V; greater or equal
            LT = 0b1011,           ///< N not equal to V; less than
            GT = 0b1100,           ///< Z clear AND (N equals V); greater than
            LE = 0b1101,           ///< Z set OR (N not equal to V); less than or equal
            AL = 0b1110,           ///< always
            Unconditioned = 0b1111 ///< always (condition is not applied)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief This enumeration represents different types of instructions supported by the emulator
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            Data_Processing,               ///< Data processing instruction
            Multiply,                      ///< Multiply instruction
            Multiply_Long,                 ///< Multiply long instruction
            Branch_And_Exchange,           ///< Branch and exchange instruction
            Halfword_Data_Transfer,        ///< Halfoword data transfer instruction
            Single_Data_Transfer,          ///< Single data transfer instruction
            Undefined,                     ///< Undefined instruction
            Block_Data_Transfer,           ///< Block data transfer instruction
            Branch,                        ///< Branch instruction
            Coprocessor_Data_Transfer,     ///< Coprocessor data transfer instruction
            Coprocessor_Data_Operation,    ///< Coprocessor data operation instruction
            Coprocessor_Register_Transfer, ///< Coprocessor register transfer instruction
            Software_Interrupt,            ///< Software interrupt (SWI)
            Extend,                        ///< Extend instruction (sign/unsigned extends a given value)
            PSR_Transfer,                  ///< PSR transfer instruction (MSR, MRS)
            CPS,                           ///< CPS instruction
            NOP,                           ///< Nop instruction
            SRS,                           ///< SRS instruction (store LR and SPSR)
            RFE,                           ///< RFE instruction (load LR and SPSR)
            CLZ,                           ///< Count leading zeros instruction
            SMULxy,                        ///< SMULxy instruction
            SMULWy,                        ///< SMULWy instruction
            SMLAxy,                        ///< SMLAxy instruction
            Unknown                        ///< Unknown instruction
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NShift_Type
        /// \brief This enumeration represents different shift types used not only in a data processing instruction.
        // -------------------------------------------------------------------------------------------------------------
        enum class NShift_Type : std::uint32_t
        {
            LSL = 0b00, ///< Logical shift left
            LSR = 0b01, ///< Logical shift right
            ASR = 0b10, ///< Arithmetic shift right
            ROR = 0b11  ///< Rotate right
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \note Implicit conversion is intentional (testing purposes)
        /// \param value 32-bit encoding of the instruction
        // -------------------------------------------------------------------------------------------------------------
        CInstruction(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Compares this instruction to the instruction passed in as a parameter.
        /// \param other Instruction this instruction will be compared to
        /// \return true, if the two instructions are the same. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool operator==(const CInstruction& other) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Compares this instruction to the instruction passed in as a parameter.
        /// \param other Instruction this instruction will be compared to
        /// \return true, if the two instructions are NOT the same. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool operator!=(const CInstruction& other) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the 32-bit value (encoding of the instruction).
        /// \return Instruction value itself
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Value() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the condition field of the instruction.
        /// \return Condition field of the instruction (most significant 5 bits)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NCondition Get_Condition() const noexcept;

    protected:
        std::uint32_t m_value; ///< Machine code encoding of the instruction (32-bit value)
    };

} // namespace zero_mate::arm1176jzf_s::isa
