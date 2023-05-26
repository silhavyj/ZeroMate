// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor_data_operation.hpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a coprocessor data operation (CDP).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/cdp-and-cdp2
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCoprocessor_Data_Operation
    /// \brief This class represents a coprocessor data operation.
    // -----------------------------------------------------------------------------------------------------------------
    class CCoprocessor_Data_Operation final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CCoprocessor_Data_Operation(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the coprocessor operation code (4-bit coprocessor specific code).
        /// \return Coprocessor operation code
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CP_OP_Code() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the CRn register (coprocessor operand register).
        /// \return Index of the CRn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CRn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the CRd register (coprocessor destination register).
        /// \return Index of the CRd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CRd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the coprocessor number (ID of the coprocessor o which the operation should be performed).
        /// \return Coprocessor ID
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Coprocessor_ID() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns coprocessor information (optional 3-bit coprocessor-specific opcode).
        /// \return Coprocessor information
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Coprocessor_Information() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the CRm register (coprocessor operand register).
        /// \return Index of the CRm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_CRm_Idx() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa