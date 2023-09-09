// ---------------------------------------------------------------------------------------------------------------------
/// \file fpexc.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the FPEXC register of coprocessor CP10.
///
/// To see more information about the register, see https://developer.arm.com/documentation/ddi0406/c/
/// System-Level-Architecture/System-Control-Registers-in-a-PMSA-implementation/
/// PMSA-System-control-registers-descriptions--in-register-order/FPEXC--Floating-Point-Exception-Control-register--PMSA
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CFPEXC
    /// \brief This class represents the FPEXC register of CP10.
    // -----------------------------------------------------------------------------------------------------------------
    class CFPEXC final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum  NFlag
        /// \brief Enumeration of different flags of the FPEXC register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NFlag : std::uint32_t
        {
            EX = 31U, ///< Exception bit (not being used)
            EN = 30U  ///< Enable bit?
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CFPEXC();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Copy construction of the class.
        /// \param other Another instance of CFPEXC
        // -------------------------------------------------------------------------------------------------------------
        CFPEXC(const CFPEXC& other) = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Assigns the register a given 32-bit value.
        /// \param value New value of the register
        /// \return Reference to this instance of the class
        // -------------------------------------------------------------------------------------------------------------
        CFPEXC& operator=(std::uint32_t value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a given flag is set or not.
        /// \param flag Flag that will be checked
        /// \return true if the flag is set. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;

    private:
        std::uint32_t m_value; ///< Register value
    };

} // namespace zero_mate::coprocessor::cp10