#pragma once

#include <vector>
#include <memory>
#include <cstdint>
#include <source_location>

namespace zero_mate::utils
{
    class ILogger
    {
    public:
        enum class NLogging_Level : std::uint8_t
        {
            Debug = 0,
            Info = 1,
            Warning = 2,
            Error = 3
        };

        ILogger();
        virtual ~ILogger() = default;

        ILogger(const ILogger&) = delete;
        ILogger& operator=(const ILogger&) = delete;
        ILogger(ILogger&&) = delete;
        ILogger& operator=(ILogger&&) = delete;

        void Set_Logging_Level(NLogging_Level debug_level);
        virtual void Debug(const char* msg, const std::source_location& location = std::source_location::current()) = 0;
        virtual void Info(const char* msg, const std::source_location& location = std::source_location::current()) = 0;
        virtual void Warning(const char* msg, const std::source_location& location = std::source_location::current()) = 0;
        virtual void Error(const char* msg, const std::source_location& location = std::source_location::current()) = 0;
        virtual void Print(const char* msg) = 0;

    protected:
        NLogging_Level m_logging_level;
    };

    class CLogging_System final
    {
    public:
        void Add_Logger(std::shared_ptr<ILogger> logger);

        void Debug(const char* msg, const std::source_location& location = std::source_location::current());
        void Info(const char* msg, const std::source_location& location = std::source_location::current());
        void Warning(const char* msg, const std::source_location& location = std::source_location::current());
        void Error(const char* msg, const std::source_location& location = std::source_location::current());
        void Print(const char* msg);

    private:
        std::vector<std::shared_ptr<ILogger>> m_loggers;
    };
}