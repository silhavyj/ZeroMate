// ---------------------------------------------------------------------------------------------------------------------
/// \file logging_system.cpp
/// \date 22. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a logging system that is used in the project.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <chrono>
#include <ranges>
#include <algorithm>
#include <filesystem>
/// \endcond

// Project file imports

#include "zero_mate/utils/logging_system.hpp"

namespace zero_mate::utils
{
    void CLogging_System::Add_Logger(std::shared_ptr<ILogger> logger)
    {
        m_loggers.push_back(logger);
    }

    std::string CLogging_System::Extract_Filename(const std::string& location)
    {
        // Use std::filesystem::path to extract the filename from the path.
        const std::filesystem::path full_path{ location };

        return full_path.filename().string();
    }

    void CLogging_System::Print(const char* msg)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Print(msg); });
    }

    void CLogging_System::Debug(const char* msg, const char* location, int line)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // Create a formatted message
        const std::string msg_formatted = Create_Formatted_Log_Msg(Debug_Msg_Prefix, filename, line, msg);

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Debug(msg_formatted.c_str());
        });
    }

    void CLogging_System::Info(const char* msg, const char* location, int line)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // Create a formatted message
        const std::string msg_formatted = Create_Formatted_Log_Msg(Info_Msg_Prefix, filename, line, msg);

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Info(msg_formatted.c_str());
        });
    }

    void CLogging_System::Warning(const char* msg, const char* location, int line)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // Create a formatted message
        const std::string msg_formatted = Create_Formatted_Log_Msg(Warning_Msg_Prefix, filename, line, msg);

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Warning(msg_formatted.c_str());
        });
    }

    void CLogging_System::Error(const char* msg, const char* location, int line)
    {
        // Make sure the function is thread-safe.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Get the filename from the location in the source code this function was called from.
        const auto filename = Extract_Filename(location);

        // Create a formatted message
        const std::string msg_formatted = Create_Formatted_Log_Msg(Error_Msg_Prefix, filename, line, msg);

        // Forward the log message to all registered loggers.
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void {
            logger->Error(msg_formatted.c_str());
        });
    }

    std::string CLogging_System::Create_Formatted_Log_Msg(const char* const prefix,
                                                          const std::string& filename,
                                                          std::size_t line_no,
                                                          const char* msg)
    {
        // Retrieve the current time timestamp and format it.
        const auto timestamp = Get_Timestamp();
        const std::string timestamp_formatted = Format_Timestamp(timestamp);

        // Format the log message.
        // clang-format off
        return "[" + timestamp_formatted + "]" +
               std::string(prefix) +
               "[" + filename + ":" + std::to_string(line_no) + "] " + msg;
        // clang-format on
    }

    CLogging_System::TTimestamp CLogging_System::Get_Timestamp()
    {
        auto now = std::chrono::system_clock::now();
        const std::time_t current_time = std::chrono::system_clock::to_time_t(now);

        // Convert the current time to a local time string.
        std::tm* local_time = std::localtime(&current_time);

        // Return the current hour, minute, and second.
        return { .hour = static_cast<std::uint32_t>(local_time->tm_hour),
                 .minute = static_cast<std::uint32_t>(local_time->tm_min),
                 .second = static_cast<std::uint32_t>(local_time->tm_sec) };
    }

    std::string CLogging_System::Format_Timestamp(const TTimestamp& timestamp)
    {
        // Make sure each value has at least 2 digits.
        const auto Make_Two_Digits = [&](std::uint32_t value) -> std::string {
            if (value < 10)
            {
                return "0" + std::to_string(value);
            }

            return std::to_string(value);
        };

        // Format the timestamp into hour:minute:second.
        return Make_Two_Digits(timestamp.hour) + ":" + Make_Two_Digits(timestamp.minute) + ":" +
               Make_Two_Digits(timestamp.second);
    }

} // namespace zero_mate::utils