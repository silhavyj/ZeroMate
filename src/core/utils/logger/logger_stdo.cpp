#include <fmt/format.h>

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

        if (m_logging_level <= NLogging_Level::Info)
        {
            fmt::print("{}\n", msg);
        }
    }

    void CLogger_STDO::Debug(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        if (m_logging_level <= NLogging_Level::Debug)
        {
            fmt::print("{}\n", msg);
        }
    }

    void CLogger_STDO::Warning(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        if (m_logging_level <= NLogging_Level::Warning)
        {
            fmt::print("{}\n", msg);
        }
    }

    void CLogger_STDO::Error(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        if (m_logging_level <= NLogging_Level::Error)
        {
            fmt::print("{}\n", msg);
        }
    }
}