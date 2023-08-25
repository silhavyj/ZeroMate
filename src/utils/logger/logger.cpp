// ---------------------------------------------------------------------------------------------------------------------
/// \file logger.cpp
/// \date 22. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a general logger interface.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "zero_mate/utils/logger.hpp"

namespace zero_mate::utils
{
    ILogger::ILogger()
    : m_logging_level{ NLogging_Level::Debug }
    {
    }

    void ILogger::Set_Logging_Level(NLogging_Level logging_level)
    {
        m_logging_level = logging_level;
    }

} // namespace zero_mate::utils