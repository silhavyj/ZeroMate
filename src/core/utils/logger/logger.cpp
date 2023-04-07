#include <ranges>
#include <algorithm>

#include <fmt/format.h>

#include "logger.hpp"

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

    void CLogging_System::Add_Logger(std::shared_ptr<ILogger> logger)
    {
        m_loggers.push_back(logger);
    }

    std::string_view CLogging_System::Extract_Filename(const std::source_location& location)
    {
        const std::string_view full_filename = location.file_name();
        return full_filename.substr(full_filename.find_last_of('/') + 1);
    }

    void CLogging_System::Print(const char* msg)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Print(msg); });
    }

    void CLogging_System::Debug(const char* msg, const std::source_location& location)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        const auto filename = Extract_Filename(location);
        const std::string msg_formatted = fmt::format("{} [{}:{}:{}] {}", DEBUG_MSG_PREFIX, filename, location.line(), location.function_name(), msg);

        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Debug(msg_formatted.c_str()); });
    }

    void CLogging_System::Info(const char* msg, const std::source_location& location)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        const auto filename = Extract_Filename(location);
        const std::string msg_formatted = fmt::format("{} [{}:{}:{}] {}", INFO_MSG_PREFIX, filename, location.line(), location.function_name(), msg);

        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Info(msg_formatted.c_str()); });
    }

    void CLogging_System::Warning(const char* msg, const std::source_location& location)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        const auto filename = Extract_Filename(location);
        const std::string msg_formatted = fmt::format("{} [{}:{}:{}] {}", WARNING_MSG_PREFIX, filename, location.line(), location.function_name(), msg);

        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Warning(msg_formatted.c_str()); });
    }

    void CLogging_System::Error(const char* msg, const std::source_location& location)
    {
        const std::lock_guard<std::mutex> lock(m_mtx);

        const auto filename = Extract_Filename(location);
        const std::string msg_formatted = fmt::format("{} [{}:{}:{}] {}", ERROR_MSG_PREFIX, filename, location.line(), location.function_name(), msg);

        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Error(msg_formatted.c_str()); });
    }
}