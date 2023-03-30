#include <fmt/format.h>

#include "logger_stdo.hpp"

namespace zero_mate::utils
{
    void CLogger_STDO::Print(const char* msg)
    {
        fmt::print("{}\n", msg);
    }

    void CLogger_STDO::Info(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Info)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        fmt::print("[info][{}:{}:{}] {}\n", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Debug(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Debug)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        fmt::print("[debug][{}:{}:{}] {}\n", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Warning(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Warning)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        fmt::print("[{}:{}:{}] {}\n", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Error(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Error)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        fmt::print("[{}:{}:{}] {}\n", filename, location.line(), location.function_name(), msg);
    }
}