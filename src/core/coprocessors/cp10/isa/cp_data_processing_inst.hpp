// ---------------------------------------------------------------------------------------------------------------------
/// \file cp_data_processing_inst.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a general CP10 data processing instruction.
///
/// More information about instruction encoding can be found over at
/// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/
/// Advanced-SIMD-and-Floating-point-Instruction-Encoding/Floating-point-data-processing-instructions?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "cp_instruction.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP_Data_Processing_Inst
    /// \brief This class represents a general CP10 data processing instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CCP_Data_Processing_Inst final : public CCP_Instruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief Different floating point instructions that are classified as data processing instructions.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType : std::uint32_t
        {
            VMLA_VMLS,         ///< Multiply accumulate, multiply subtract
            VNMLA_VNMLS_VNMUL, ///< Negate multiply accumulate, negate multiply subtract, negate multiply
            VMUL,              ///< Multiply
            VADD,              ///< Add
            VSUB,              ///< Subtract
            VDIV,              ///< Divide
            VMOV_Register,     ///< Move (from a CP10 register to a CP10 register)
            VABS,              ///< Absolute value
            VNEG,              ///< Opposite value
            VSQRT,             ///< Square root
            VCMP_VCMPE,        ///< Compare
            VCVT_Double_Precision_Single_Precision, ///< Narrow-cast a double to a float
            VCVT_VCVTR_Floating_Point_Integer,      ///< Convert between a float and an integer
            Unknown                                 ///< Helper enumeration record
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP_Data_Processing_Inst(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the instruction.
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        /// Total number of rows in the instruction look-up table
        static constexpr std::size_t Instruction_Masks_Count = 16;

        /// Instruction look-up table
        static std::array<TInstruction_Lookup_Record<NType>, Instruction_Masks_Count> s_instruction_lookup_table;
    };

} // namespace zero_mate::coprocessor::cp10::isa