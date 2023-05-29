// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor.cpp
/// \date 29. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the common functionality of a general interface of a coprocessor.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "coprocessor.hpp"

namespace zero_mate::coprocessor
{
    ICoprocessor::ICoprocessor(arm1176jzf_s::CCPU_Context& cpu_context)
    : m_cpu_context{ cpu_context }
    {
    }

} // namespace zero_mate::coprocessor