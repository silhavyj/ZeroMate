// ---------------------------------------------------------------------------------------------------------------------
/// \file fpscr.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the FPSCR register of coprocessor CP10.
///
/// To see more information about the register, see https://developer.arm.com/documentation/101273/0001/
/// Cortex-M55-Processor-level-components-and-system-registers---Reference-Material/Floating-point-and-MVE-support/
/// Floating-point-Status-Control-Register--FPSCR
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CFPSCR
    /// \brief This class represents the FPSCR register of CP10.
    // -----------------------------------------------------------------------------------------------------------------
    class CFPSCR final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NFlag
        /// \brief Enumeration of different flags of the FPSCR register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NFlag : std::uint32_t
        {
            N = 0b1U << 31U, ///< Negative condition code flag
            Z = 0b1U << 30U, ///< Zero condition code flag
            C = 0b1U << 29U, ///< Carry condition code flag
            V = 0b1U << 28U  ///< Overflow condition code flag
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CFPSCR();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Copy construction of the class.
        /// \param other Another instance of CFPSCR
        // -------------------------------------------------------------------------------------------------------------
        CFPSCR(const CFPSCR& other) = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Assigns the register a given 32-bit value.
        /// \param value New value of the register
        /// \return Reference to this instance of the class
        // -------------------------------------------------------------------------------------------------------------
        CFPSCR& operator=(std::uint32_t value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a given flag is set or not.
        /// \param flag Flag to be checked
        /// \return true if the flag is set. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the register.
        /// \return Current value the register holds
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Value() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets a given flag in the register value.
        /// \param flag Flag to be set
        /// \param set Indication of whether the flag should be set to a 0 or 1.
        // -------------------------------------------------------------------------------------------------------------
        void Set_Flag(NFlag flag, bool set);

    private:
        std::uint32_t m_value; ///< Register value
    };

} // namespace zero_mate::coprocessor::cp10