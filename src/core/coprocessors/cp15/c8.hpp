// ---------------------------------------------------------------------------------------------------------------------
/// \file c8.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the primary register C8 of coprocessor CP15.
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
    /// \class CC8
    /// \brief This class represents primary register C8 of coprocessor CP15
    // -----------------------------------------------------------------------------------------------------------------
    class CC8 final : public IPrimary_Reg
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm
        /// \brief Enumeration of secondary registers of the C8 primary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm : std::uint32_t
        {
            C7 = 7 ///< CRm = 7
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C7_Register
        /// \brief Enumeration of the registers of the NCRm::C7 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C7_Register : std::uint32_t
        {
            Invalidate_Unified_TLB_Unlocked_Entries = 0 ///< Invalidate unified TLB unlocked entries
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        ///
        /// All secondary registers (CC8::NCRm) get initialized upon object construction.
        // -------------------------------------------------------------------------------------------------------------
        CC8();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the invalidate unified TLB unlocked entries register is NOT set to 0.
        /// \return true if the register is not zero. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Invalidate_Unified_TLB_Unlocked_Entries_Set() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the flag that indicates that the TLB entries should be invalidated.
        // -------------------------------------------------------------------------------------------------------------
        void TLB_Has_Been_Invalidated();

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C7.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R7();
    };

} // namespace zero_mate::coprocessor::cp15