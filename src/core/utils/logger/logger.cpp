#include <algorithm>

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

    void CLogging_System::Print(const char* msg)
    {
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Print(msg); });
    }

    void CLogging_System::Debug(const char* msg, const std::source_location& location)
    {
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Debug(msg, location); });
    }

    void CLogging_System::Info(const char* msg, const std::source_location& location)
    {
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Info(msg, location); });
    }

    void CLogging_System::Warning(const char* msg, const std::source_location& location)
    {
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Warning(msg, location); });
    }

    void CLogging_System::Error(const char* msg, const std::source_location& location)
    {
        std::for_each(m_loggers.begin(), m_loggers.end(), [&](auto& logger) -> void { logger->Error(msg, location); });
    }
}