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

// 3rd party library includes

#include <fmt/format.h>

// Project file imports

#include "c1.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::coprocessor::cp15
{
    CC1::CC1()
    : m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_invalid_reg{ Invalid_Reg_Value }
    {
        Init_CRm_R0();
        Init_CRm_R1();
    }

    void CC1::Init_CRm_R0()
    {
        // Index of the C0 secondary register.
        const auto crm_c0_idx = static_cast<std::uint32_t>(NCRm::C0);

        // Initialize all register of the C0 secondary register (indexed by op2).
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Control)] = 0;
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Auxiliary_Control)] = 0;
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Coprocessor_Access_Control)] = 0;

        // Allow unaligned memory access by default.
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Control)] |=
        static_cast<std::uint32_t>(NC0_Control_Flags::Unaligned_Memory_Access_Enable);
    }

    void CC1::Init_CRm_R1()
    {
        // Index of the C0 secondary register.
        const auto crm_c1_idx = static_cast<std::uint32_t>(NCRm::C1);

        // Initialize all register of the C1 secondary register (indexed by op2).
        m_regs[crm_c1_idx][static_cast<std::uint32_t>(NCRm_C1_Register::Secure_Configuration)] = 0;
        m_regs[crm_c1_idx][static_cast<std::uint32_t>(NCRm_C1_Register::Secure_Debug_Enable)] = 0;
        m_regs[crm_c1_idx][static_cast<std::uint32_t>(NCRm_C1_Register::Non_Secure_Access_Control)] = 0;
    }

    bool CC1::Register_Exists(std::uint32_t crm_idx, std::uint32_t op2) const
    {
        // Make sure we always return the same value even if the caller modifies it.
        m_invalid_reg = Invalid_Reg_Value;

        // Check if the secondary register exists.
        if (!m_regs.contains(crm_idx))
        {
            m_logging_system.Error(fmt::format("CRm register {} has not been implemented yet", crm_idx).c_str());
            return false;
        }

        // Check if the secondary register contains a register index by op2.
        if (!m_regs.at(crm_idx).contains(op2))
        {
            // clang-format off
            m_logging_system.Error(fmt::format("Pair CRm-Op2 ({}-{}) has not been implemented yet",
                                               crm_idx, op2).c_str());
            // clang-format on

            return false;
        }

        return true;
    }

    std::uint32_t& CC1::Get_Reg(std::uint32_t crm_idx, std::uint32_t op2)
    {
        // Make sure such register exists.
        if (!Register_Exists(crm_idx, op2))
        {
            return m_invalid_reg;
        }

        return m_regs[crm_idx][op2];
    }

    const std::uint32_t& CC1::Get_Reg(std::uint32_t crm_idx, std::uint32_t op2) const
    {
        // Make sure such register exists.
        if (!Register_Exists(crm_idx, op2))
        {
            return m_invalid_reg;
        }

        return m_regs.at(crm_idx).at(op2);
    }

    bool CC1::Is_Unaligned_Access_Permitted() const
    {
        // Check if the flag is set or not.
        return IPrimary_Reg::Is_Flag_Set(
        m_regs.at(static_cast<std::uint32_t>(NCRm::C0)).at(static_cast<std::uint32_t>(NCRm_C0_Register::Control)),
        static_cast<std::uint32_t>(NC0_Control_Flags::Unaligned_Memory_Access_Enable));
    }

} // namespace zero_mate::coprocessor::cp15