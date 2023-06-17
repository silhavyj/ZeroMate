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
#include <filesystem>
/// \endcond

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

    void CLogging_System::Add_Logger(std::shared_ptr<ILogger> logger)
    {
        m_loggers.push_back(logger);
    }

    std::string CLogging_System::Extract_Filename(const std::source_location& location)
    {
        // Use std::filesystem::path to extract the filename from the path.
        const std::filesystem::path full_path{ location.file_name() };

        return full_path.filename().string();
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
        const std::string msg_formatted = std::string(Debug_Msg_Prefix) +
                                          "[" + filename + ":" + std::to_string(location.line())  + "] "
                                          + msg;
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
        const std::string msg_formatted = std::string(Info_Msg_Prefix) +
                                          "[" + filename + ":" + std::to_string(location.line())  + "] "
                                          + msg;
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
        const std::string msg_formatted = std::string(Warning_Msg_Prefix) +
                                          "[" + filename + ":" + std::to_string(location.line())  + "] "
                                          + msg;
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
        const std::string msg_formatted = std::string(Error_Msg_Prefix) +
                                          "[" + filename + ":" + std::to_string(location.line())  + "] "
                                          + msg;
        // clang-format on

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Error(msg_formatted.c_str());
        });
    }

} // namespace zero_mate::utils