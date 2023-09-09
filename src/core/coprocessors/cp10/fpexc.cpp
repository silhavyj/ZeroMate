// ---------------------------------------------------------------------------------------------------------------------
/// \file fpexc.cpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the FPEXC register of coprocessor CP10.
///
/// To see more information about the register, see https://developer.arm.com/documentation/ddi0406/c/
/// System-Level-Architecture/System-Control-Registers-in-a-PMSA-implementation/
/// PMSA-System-control-registers-descriptions--in-register-order/FPEXC--Floating-Point-Exception-Control-register--PMSA
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "fpexc.hpp"

namespace zero_mate::coprocessor::cp10
{
    CFPEXC::CFPEXC()
    : m_value{ 0 }
    {
    }

    CFPEXC& CFPEXC::operator=(std::uint32_t value)
    {
        m_value = value;
        return *this;
    }

    bool CFPEXC::Is_Flag_Set(NFlag flag) const noexcept
    {
        return static_cast<bool>((m_value >> static_cast<std::uint32_t>(flag)) & 0b1U);
    }

} // namespace zero_mate::coprocessor::cp10