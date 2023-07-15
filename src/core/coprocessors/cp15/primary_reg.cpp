// ---------------------------------------------------------------------------------------------------------------------
/// \file primary_reg.cpp
/// \date 26. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a primary register interface of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party library includes

#include <fmt/format.h>

// Project file imports

#include "primary_reg.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::coprocessor::cp15
{
    IPrimary_Reg::IPrimary_Reg()
    : m_invalid_reg{ IPrimary_Reg::Invalid_Reg_Value }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
    }

    bool IPrimary_Reg::Is_Flag_Set(std::uint32_t reg, std::uint32_t flag)
    {
        return static_cast<bool>(reg & flag);
    }

    bool IPrimary_Reg::Register_Exists(const Registers_t& regs, std::uint32_t crm_idx, std::uint32_t op2) const
    {
        // Make sure we always return the same value even if the caller modifies it.
        m_invalid_reg = IPrimary_Reg::Invalid_Reg_Value;

        // Check if the secondary register exists.
        if (!regs.contains(crm_idx))
        {
            m_logging_system.Error(fmt::format("CRm register {} has not been implemented yet", crm_idx).c_str());
            return false;
        }

        // Check if the secondary register contains a register index by op2.
        if (!regs.at(crm_idx).contains(op2))
        {
            // clang-format off
            m_logging_system.Error(fmt::format("Pair CRm-Op2 ({}-{}) has not been implemented yet",
                                               crm_idx, op2).c_str());
            // clang-format on

            return false;
        }

        return true;
    }

    std::uint32_t& IPrimary_Reg::Get_Reg(std::uint32_t crm_idx, std::uint32_t op2)
    {
        // Make sure such register exists.
        if (!Register_Exists(m_regs, crm_idx, op2))
        {
            return m_invalid_reg;
        }

        return m_regs[crm_idx][op2];
    }

    const std::uint32_t& IPrimary_Reg::Get_Reg(std::uint32_t crm_idx, std::uint32_t op2) const
    {
        // Make sure such register exists.
        if (!Register_Exists(m_regs, crm_idx, op2))
        {
            return m_invalid_reg;
        }

        return m_regs.at(crm_idx).at(op2);
    }

} // namespace zero_mate::coprocessor::cp15