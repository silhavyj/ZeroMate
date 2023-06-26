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

// Project file imports

#include "primary_reg.hpp"

namespace zero_mate::coprocessor::cp15
{
    bool IPrimary_Reg::Is_Flag_Set(std::uint32_t reg, std::uint32_t flag)
    {
        return static_cast<bool>(reg & flag);
    }

} // namespace zero_mate::coprocessor::cp15