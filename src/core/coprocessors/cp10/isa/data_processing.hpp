// ---------------------------------------------------------------------------------------------------------------------
/// \file data_processing.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a data processing instruction.
///
/// It groups up the functionality of the majority of the data processing instructions.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CData_Processing
    /// \brief This class represents a data processing instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CData_Processing final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TRegisters
        /// \brief Structure of indexes of single-precision registers.
        // -------------------------------------------------------------------------------------------------------------
        struct TRegisters
        {
            std::uint32_t vd_idx; ///< Destination register
            std::uint32_t vn_idx; ///< First operand
            std::uint32_t vm_idx; ///< Second operand
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as a 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CData_Processing(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Vn register.
        /// \return Index of the Vn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Vd register.
        /// \return Index of the Vd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Vm register.
        /// \return Index of the Vm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vm_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the offset of the Vn register (S{x} vs D{x}).
        /// \return Offset of the Vn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vn_Offset() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the offset of the Vd register (S{x} vs D{x}).
        /// \return Offset of the Vd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vd_Offset() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the offset of the Vm register (S{x} vs D{x}).
        /// \return Offset of the Vm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vm_Offset() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the 6th bit is set or not (OP bit 1).
        /// \return true if the 6th bit is set. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_OP_6_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the 7th bit is set or not (OP bit 2).
        /// \return true if the 7th bit is set. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_OP_7_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a CPM should be done against zero or not.
        /// \return true if the CMP instruction is against zero. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Compare_With_Zero() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the instruction is an accumulate instruction or not.
        /// \return true if the instruction is an accumulate instruction. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Accumulate_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the CVT instruction is meant to convert a float to an integer.
        /// \return true, if the instruction should convert a float to an integer. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool To_Integer() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the CVT instruction involves a signed integer or not.
        /// \return true if a signed integer should be used. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Signed() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a collection of indexes of all three registers (Vd, Vn, and Vm).
        /// \return Indexes of all register encoded in the instruction
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] TRegisters Get_Register_Idxs() const noexcept;

    private:
        std::uint32_t m_value; ///< Encoded instruction as a 32-bit integer
    };

} // namespace zero_mate::coprocessor::cp10::isa