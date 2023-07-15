// ---------------------------------------------------------------------------------------------------------------------
/// \file c8.cpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the primary register C8 of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "c8.hpp"

namespace zero_mate::coprocessor::cp15
{
    CC8::CC8()
    {
        Init_CRm_R7();
    }

    void CC8::Init_CRm_R7()
    {
        // Index of the C7 secondary register.
        const auto crm_c7_idx = static_cast<std::uint32_t>(NCRm::C7);

        // Initialize all registers of the C7 secondary register (indexed by op2).
        m_regs[crm_c7_idx][static_cast<std::uint32_t>(NCRm_C7_Register::Invalidate_Unified_TLB_Unlocked_Entries)] = 1;
    }

    bool CC8::Is_Invalidate_Unified_TLB_Unlocked_Entries_Set() const
    {
        const auto crm_c7_idx = static_cast<std::uint32_t>(NCRm::C7);
        const auto crm_c7_0_idx = static_cast<std::uint32_t>(NCRm_C7_Register::Invalidate_Unified_TLB_Unlocked_Entries);

        // Check if the register is NOT set to 0.
        return m_regs.at(crm_c7_idx).at(crm_c7_0_idx) == 0;
    }

    void CC8::TLB_Has_Been_Invalidated()
    {
        const auto crm_c7_idx = static_cast<std::uint32_t>(NCRm::C7);
        const auto crm_c7_0_idx = static_cast<std::uint32_t>(NCRm_C7_Register::Invalidate_Unified_TLB_Unlocked_Entries);

        m_regs[crm_c7_idx][crm_c7_0_idx] = 1;
    }

} // namespace zero_mate::coprocessor::cp15