#include <spdlog/spdlog.h>

#include "logger_stdo.hpp"

namespace zero_mate::utils
{
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

        const auto filename = Extract_Filename(location);
        spdlog::info("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Debug(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Debug)
        {
            return;
        }

        const auto filename = Extract_Filename(location);
        spdlog::debug("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Warning(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Warning)
        {
            return;
        }

        const auto filename = Extract_Filename(location);
        spdlog::warn("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }

    void CLogger_STDO::Error(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Error)
        {
            return;
        }

        const auto filename = Extract_Filename(location);
        spdlog::error("[{}:{}:{}] {}", filename, location.line(), location.function_name(), msg);
    }

    std::string_view CLogger_STDO::Extract_Filename(const std::source_location& location)
    {
        const std::string_view full_filename = location.file_name();
        return full_filename.substr(full_filename.find_last_of('/') + 1);
    }
}