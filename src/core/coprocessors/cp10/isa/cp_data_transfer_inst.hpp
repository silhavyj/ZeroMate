// ---------------------------------------------------------------------------------------------------------------------
/// \file cp_data_transfer_inst.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a general CP10 data transfer instruction (load and store).
///
/// More information about instruction encoding can be found over at
/// https://developer.arm.com/documentation/ddi0406/c/Application-Level-Architecture/
/// Advanced-SIMD-and-Floating-point-Instruction-Encoding/Extension-register-load-store-instructions?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "cp_instruction.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP_Data_Transfer_Inst
    /// \brief This class represents a general CP10 data transfer instruction (load/store).
    // -----------------------------------------------------------------------------------------------------------------
    class CCP_Data_Transfer_Inst final : public CCP_Instruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief Enumeration of different instructions that are categorized as data transfer instructions.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType
        {
            VSTM_Increment_After_No_Writeback, ///< STMIA!
            VSTM_Increment_After_Writeback,    ///< STMIA
            VSTR,                              ///< Store a CP10 register into memory
            VSTM_Decrement_Before_Writeback,   ///< STMDB!
            VPUSH,                             ///< Push a CP10 register onto the stack
            VLDM_Increment_After_No_Writeback, ///< LDMIA
            VLDM_Increment_After_Writeback,    ///< LDMIA!
            VPOP,                              ///< Pop a CP10 register off of the stack
            VLDR,                              ///< Load a CP10 register from memory
            VLDM_Decrement_Before_Writeback,   ///< LDMDB!
            Unknown                            ///< Helper enumeration record
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP_Data_Transfer_Inst(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the instruction.
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const noexcept;

    private:
        /// Total number of rows in the instruction look-up table
        static constexpr std::size_t Instruction_Masks_Count = 10;

        /// Instruction look-up table
        static std::array<TInstruction_Lookup_Record<NType>, Instruction_Masks_Count> s_instruction_lookup_table;
    };

} // namespace zero_mate::coprocessor::cp10::isa