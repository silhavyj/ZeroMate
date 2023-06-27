// ---------------------------------------------------------------------------------------------------------------------
/// \file c3.hpp
/// \date 27. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the primary register C3 of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "primary_reg.hpp"

namespace zero_mate::coprocessor::cp15
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CC3
    /// \brief This class represents primary register C3 of coprocessor CP15
    // -----------------------------------------------------------------------------------------------------------------
    class CC3 final : public IPrimary_Reg
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm
        /// \brief Enumeration of secondary registers of the C3 primary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm : std::uint32_t
        {
            C0 = 0 ///< CRm = 0
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NDomain
        /// \brief Enumeration of different domain masks.
        // -------------------------------------------------------------------------------------------------------------
        enum class NDomain : std::uint32_t
        {
            D0 = 0U,   ///< Domain 0
            D1 = 2U,   ///< Domain 1
            D2 = 4U,   ///< Domain 2
            D3 = 6U,   ///< Domain 3
            D4 = 8U,   ///< Domain 4
            D5 = 10U,  ///< Domain 5
            D6 = 12U,  ///< Domain 6
            D7 = 14U,  ///< Domain 7
            D8 = 16U,  ///< Domain 8
            D9 = 18U,  ///< Domain 9
            D10 = 20U, ///< Domain 10
            D11 = 22U, ///< Domain 11
            D12 = 24U, ///< Domain 12
            D13 = 26U, ///< Domain 13
            D14 = 28U, ///< Domain 14
            D15 = 30U  ///< Domain 15
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C0_Register
        /// \brief Enumeration of the registers of the NCRm::C0 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C0_Register : std::uint32_t
        {
            Domain_Access_Control = 0 ///< Domain access control register
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NDomain_Value
        /// \brief Enumeration of different values a domain can have.
        // -------------------------------------------------------------------------------------------------------------
        enum class NDomain_Value : std::uint32_t
        {
            No_Access = 0b00U, ///< No access
            Client = 0b01U,    ///< Client
            Reserved = 0b10U,  ///< Reserved (not being used)
            Manager = 0b11U    ///< Manager
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        ///
        /// All secondary registers (CC3::NCRm) get initialized upon object construction.
        // -------------------------------------------------------------------------------------------------------------
        CC3();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the current value of a given domain.
        /// \param domain Domain whose value will be returned
        /// \return Value of the given domain
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NDomain_Value Get_Domain_Value(NDomain domain) const;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C0.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R0();
    };

} // namespace zero_mate::coprocessor::cp15