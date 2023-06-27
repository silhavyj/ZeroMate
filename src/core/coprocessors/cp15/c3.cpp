// ---------------------------------------------------------------------------------------------------------------------
/// \file c3.cpp
/// \date 27. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the primary register C3 of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "c3.hpp"

namespace zero_mate::coprocessor::cp15
{
    CC3::CC3()
    {
        Init_CRm_R0();
    }

    void CC3::Init_CRm_R0()
    {
        // Index of the C0 secondary register.
        const auto crm_c1_idx = static_cast<std::uint32_t>(NCRm::C0);

        // Initialize all registers of the C0 secondary register (indexed by op2).
        m_regs[crm_c1_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Domain_Access_Control)] = 0;
    }

    CC3::NDomain_Value CC3::Get_Domain_Value(NDomain domain) const
    {
        // clang-format off
        const auto reg_value = m_regs.at(
            static_cast<std::uint32_t>(NCRm::C0)).at(
                static_cast<std::uint32_t>(NCRm_C0_Register::Domain_Access_Control
            )
        );
        // clang-format on

        const auto domain_mask = static_cast<std::uint32_t>(domain);

        return static_cast<NDomain_Value>((reg_value >> domain_mask) & 0b11U);
    }

} // namespace zero_mate::coprocessor::cp15