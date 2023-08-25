// ---------------------------------------------------------------------------------------------------------------------
/// \file logger_stdo.cpp
/// \date 02. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a standard output logging_system (STDO) as defined in logger_stdo.hpp.
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party library includes

#include <fmt/format.h>

// Project file imports

#include "logger_stdo.hpp"

namespace zero_mate::utils
{
    void CLogger_STDO::Print(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        fmt::print("{}\n", msg);
    }

    void CLogger_STDO::Info(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Make sure the logging level is at least Info.
        if (m_logging_level <= NLogging_Level::Info)
        {
            fmt::print("{}\n", msg);
        }
    }

    void CLogger_STDO::Debug(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Make sure the logging level is at least Debug.
        if (m_logging_level <= NLogging_Level::Debug)
        {
            fmt::print("{}\n", msg);
        }
    }

    void CLogger_STDO::Warning(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Make sure the logging level is at least Warning.
        if (m_logging_level <= NLogging_Level::Warning)
        {
            fmt::print("{}\n", msg);
        }
    }

    void CLogger_STDO::Error(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Make sure the logging level is at least Error.
        if (m_logging_level <= NLogging_Level::Error)
        {
            fmt::print("{}\n", msg);
        }
    }

} // namespace zero_mate::utils