// ---------------------------------------------------------------------------------------------------------------------
/// \file logger.cpp
/// \date 31. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a general logger interface as well as a logging system that is used in the project.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <ranges>
#include <algorithm>
/// \endcond

// 3rd party library includes

#include <fmt/format.h>

// Project file imports

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
        // Get the path of the source file.
        const std::string_view full_filename = location.file_name();

        // Strip out the filename from the path.
        return full_filename.substr(full_filename.find_last_of('/') + 1);
    }

    void CLogging_System::Print(const char* msg)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Print(msg); });
    }

    void CLogging_System::Debug(const char* msg, const std::source_location& location)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // clang-format off
        const std::string msg_formatted = fmt::format("{} [{}:{}] {}",
                                                      DEBUG_MSG_PREFIX, filename, location.line(), msg);
        // clang-format on

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Debug(msg_formatted.c_str());
        });
    }

    void CLogging_System::Info(const char* msg, const std::source_location& location)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // clang-format off
        const std::string msg_formatted = fmt::format("{} [{}:{}] {}",
                                                      INFO_MSG_PREFIX, filename, location.line(), msg);
        // clang-format on

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Info(msg_formatted.c_str());
        });
    }

    void CLogging_System::Warning(const char* msg, const std::source_location& location)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // clang-format off
        const std::string msg_formatted = fmt::format("{} [{}:{}] {}",
                                                      WARNING_MSG_PREFIX, filename, location.line(), msg);
        // clang-format on

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Warning(msg_formatted.c_str());
        });
    }

    void CLogging_System::Error(const char* msg, const std::source_location& location)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // clang-format off
        const std::string msg_formatted = fmt::format("{} [{}:{}] {}",
                                                      ERROR_MSG_PREFIX, filename, location.line(), msg);
        // clang-format on

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Error(msg_formatted.c_str());
        });
    }

} // namespace zero_mate::utils