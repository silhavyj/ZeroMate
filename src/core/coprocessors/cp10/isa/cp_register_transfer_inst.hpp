// ---------------------------------------------------------------------------------------------------------------------
/// \file cp_register_transfer_inst.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a general CP10 register transfer instruction
///
/// More information about instruction encoding can be found over at
/// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/
/// Advanced-SIMD-and-Floating-point-Instruction-Encoding/
/// 8--16--and-32-bit-transfer-between-ARM-core-and-extension-registers?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "cp_instruction.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP_Register_Transfer_Inst
    /// \brief This class represents a general CP10 register transfer instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CCP_Register_Transfer_Inst final : public CCP_Instruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief Enumeration of different instructions that are categorized as register transfer instructions.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType
        {
            VMOV_ARM_Register_Single_Precision_Register, ///< Move of general register between CP10 and ARM
            VMSR,                                        ///< Move of an ARM's register to a CP10 special register
            VMOV_ARM_Register_Scalar,                    ///< Not used (1)
            VDUP,                                        ///< Not used (2)
            VMRS,                                        ///< Move of a CP10's special register to an ARM register
            VMOV_Scalar_ARM_Register,                    ///< Not used (3)
            Unknown                                      ///< Helper enumeration record
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as a 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP_Register_Transfer_Inst(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the instruction.
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        /// Total number of rows in the instruction look-up table
        static constexpr std::size_t Instruction_Masks_Count = 7;

        /// Instruction look-up table
        static std::array<TInstruction_Lookup_Record<NType>, Instruction_Masks_Count> s_instruction_lookup_table;
    };

} // namespace zero_mate::coprocessor::cp10::isa