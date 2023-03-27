#include <spdlog/spdlog.h>

#include "logger_stdo.hpp"

namespace zero_mate::utils
{
    CLogger_STDO::CLogger_STDO()
    {
        spdlog::set_level(spdlog::level::debug);
    }

    void CLogger_STDO::Print(const char* msg)
    {
        spdlog::fmt_lib::print("{}\n", msg);
    }

    void CLogger_STDO::Info(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Info)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        spdlog::info("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Debug(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Debug)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        spdlog::debug("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Warning(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Warning)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        spdlog::warn("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Error(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Error)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        spdlog::error("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }
}