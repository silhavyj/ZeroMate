// ---------------------------------------------------------------------------------------------------------------------
/// \file c1.cpp
/// \date 26. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the primary register C1 of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "c1.hpp"

namespace zero_mate::coprocessor::cp15
{
    CC1::CC1()
    {
        Init_CRm_R0();
        Init_CRm_R1();
    }

    void CC1::Init_CRm_R0()
    {
        // Index of the C0 secondary register.
        const auto crm_c0_idx = static_cast<std::uint32_t>(NCRm::C0);

        // Initialize all registers of the C0 secondary register (indexed by op2).
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Control)] = 0;
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Auxiliary_Control)] = 0;
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Coprocessor_Access_Control)] = 0;

        // Allow unaligned memory access by default.
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Control)] |=
        static_cast<std::uint32_t>(NC0_Control_Flags::Unaligned_Memory_Access_Enable);
    }

    void CC1::Init_CRm_R1()
    {
        // Index of the C1 secondary register.
        const auto crm_c1_idx = static_cast<std::uint32_t>(NCRm::C1);

        // Initialize all register of the C1 secondary register (indexed by op2).
        m_regs[crm_c1_idx][static_cast<std::uint32_t>(NCRm_C1_Register::Secure_Configuration)] = 0;
        m_regs[crm_c1_idx][static_cast<std::uint32_t>(NCRm_C1_Register::Secure_Debug_Enable)] = 0;
        m_regs[crm_c1_idx][static_cast<std::uint32_t>(NCRm_C1_Register::Non_Secure_Access_Control)] = 0;
    }

    bool CC1::Is_Control_Flag_Set(NC0_Control_Flags flag) const
    {
        // clang-format off
        return IPrimary_Reg::Is_Flag_Set(
            m_regs.at(static_cast<std::uint32_t>(NCRm::C0)).at(
                static_cast<std::uint32_t>(NCRm_C0_Register::Control)
            ),
            static_cast<std::uint32_t>(flag)
        );
        // clang-format on
    }

    CC1::NCoprocessor_Access_Type CC1::Get_Coprocessor_Access_Type(std::uint32_t cp_idx) const
    {
        // Make sure the index is within a given range
        if (cp_idx > CP_Max_Index)
        {
            return NCoprocessor_Access_Type::Access_Denied;
        }

        // Index of the C0 secondary register.
        const auto crm_c0_idx = static_cast<std::uint32_t>(NCRm::C0);

        // Index of the Coprocessor_Access_Control register.
        const auto cp_access_cntrl_reg_idx = static_cast<std::uint32_t>(NCRm_C0_Register::Coprocessor_Access_Control);

        return static_cast<NCoprocessor_Access_Type>(
        (m_regs.at(crm_c0_idx).at(cp_access_cntrl_reg_idx) >> (2U * cp_idx)) & 0b11U);
    }

} // namespace zero_mate::coprocessor::cp15