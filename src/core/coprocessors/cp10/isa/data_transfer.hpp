// ---------------------------------------------------------------------------------------------------------------------
/// \file data_transfer.hpp
/// \date 10. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a data transfer instruction.
///
/// It groups up the functionality of the majority of the data transfer instructions.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CData_Transfer
    /// \brief This class represents a data transfer instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CData_Transfer final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as a 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CData_Transfer(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the U bit is set (add/subtract).
        /// \return true, if the U bit is set. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the W bit is set (write-back).
        /// \return true, if the W bit is set. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the offset of the Vd register (S{x} vs D{x}).
        /// \return Offset of the Vd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vd_Offset() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of an ARM register encoded in the instruction.
        /// \return Index of an ARM register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Vd register.
        /// \return Index of the Vd register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vd_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the immediate value (multiple of 4).
        /// \return Immediate value
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Immediate() const noexcept;

    private:
        std::uint32_t m_value; ///< Encoded instruction as a 32-bit integer
    };

} // namespace zero_mate::coprocessor::cp10::isa