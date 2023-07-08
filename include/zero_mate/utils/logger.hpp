// ---------------------------------------------------------------------------------------------------------------------
/// \file logger.hpp
/// \date 30. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a general logger interface as well as a logging system that is used in the project.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <mutex>
#include <vector>
#include <memory>
#include <cstdint>
#include <string_view>
#include <source_location>
/// \endcond

namespace zero_mate::utils
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class ILogger
    /// \brief This class represents a logger interface.
    // -----------------------------------------------------------------------------------------------------------------
    class ILogger
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NLogging_Level
        /// \brief This enumeration defines different logging levels.
        // -------------------------------------------------------------------------------------------------------------
        enum class NLogging_Level : std::uint8_t
        {
            Debug = 0,   ///< Debug
            Info = 1,    ///< Info
            Warning = 2, ///< Warning
            Error = 3    ///< Error
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        ///
        /// It sets the default logging level to Debug.
        // -------------------------------------------------------------------------------------------------------------
        ILogger();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~ILogger() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        ILogger(const ILogger&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        ILogger& operator=(const ILogger&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        ILogger(ILogger&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        ILogger& operator=(ILogger&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets a new level of debugging
        /// \param logging_level Logging level
        // -------------------------------------------------------------------------------------------------------------
        void Set_Logging_Level(NLogging_Level logging_level);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a debug message.
        ///
        /// This function must be implemented by any class that implements the ILogger interface.
        ///
        /// \param msg Debug message to be logged
        // -------------------------------------------------------------------------------------------------------------
        virtual void Debug(const char* msg) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an info message.
        ///
        /// This function must be implemented by any class that implements the ILogger interface.
        ///
        /// \param msg Info message to be logged
        // -------------------------------------------------------------------------------------------------------------
        virtual void Info(const char* msg) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a warning message.
        ///
        /// This function must be implemented by any class that implements the ILogger interface.
        ///
        /// \param msg Warning message to be logged
        // -------------------------------------------------------------------------------------------------------------
        virtual void Warning(const char* msg) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an error message.
        ///
        /// This function must be implemented by any class that implements the ILogger interface.
        ///
        /// \param msg Error message to be logged
        // -------------------------------------------------------------------------------------------------------------
        virtual void Error(const char* msg) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Prints out a given message without any special formatting applied.
        ///
        /// This function must be implemented by any class that implements the ILogger interface.
        ///
        /// \param msg Plain text message to be logged
        // -------------------------------------------------------------------------------------------------------------
        virtual void Print(const char* msg) = 0;

    protected:
        NLogging_Level m_logging_level; ///< Logging level
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CLogging_System
    /// \brief This class defines a logging system that is used throughout the project.
    ///
    /// It holds a collection of loggers that are registered to the logging system. When a message is being logged,
    /// the logging system forwards the message to all its registers loggers.
    // -----------------------------------------------------------------------------------------------------------------
    class CLogging_System final
    {
    public:
        static constexpr const char* const Debug_Msg_Prefix = "[DEBUG]";     ///< Debug message prefix
        static constexpr const char* const Info_Msg_Prefix = "[INFO]";       ///< Info message prefix
        static constexpr const char* const Warning_Msg_Prefix = "[WARNING]"; ///< Warning message prefix
        static constexpr const char* const Error_Msg_Prefix = "[ERROR]";     ///< Error message prefix

        static constexpr std::size_t Timestamp_Length{ 10 };                 ///< Length of a timestamp (prefix)

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Registers a logger to the logging system.
        /// \param logger Logger to be registered
        // -------------------------------------------------------------------------------------------------------------
        void Add_Logger(std::shared_ptr<ILogger> logger);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a debug message via all registered loggers.
        /// \param msg Debug message to be logged
        /// \param location Location within the source code this function was called from
        // -------------------------------------------------------------------------------------------------------------
        void Debug(const char* msg, const std::source_location& location = std::source_location::current());

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an info message via all registered loggers.
        /// \param msg Info message to be logged
        /// \param location Location within the source code this function was called from
        // -------------------------------------------------------------------------------------------------------------
        void Info(const char* msg, const std::source_location& location = std::source_location::current());

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a warning message via all registered loggers.
        /// \param msg Warning message to be logged
        /// \param location Location within the source code this function was called from
        // -------------------------------------------------------------------------------------------------------------
        void Warning(const char* msg, const std::source_location& location = std::source_location::current());

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an error message via all registered loggers.
        /// \param msg Error message to be logged
        /// \param location Location within the source code this function was called from
        // -------------------------------------------------------------------------------------------------------------
        void Error(const char* msg, const std::source_location& location = std::source_location::current());

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a plain text message (without any formatting) via all registered loggers.
        /// \param msg Plain text message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Print(const char* msg);

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TTimestamp
        /// \brief Structure holding information about the current system time.
        // -------------------------------------------------------------------------------------------------------------
        struct TTimestamp
        {
            std::uint32_t hour;   ///< Current hour
            std::uint32_t minute; ///< Current number of minutes
            std::uint32_t second; ///< Current number of seconds
        };

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Extract the filename from a given location within the source files.
        /// \param location Location within the project (source file)
        /// \return Stripped filename of the source file
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static std::string Extract_Filename(const std::source_location& location);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates a formatted message to be logged.
        /// \param prefix Level of debugging (prefix)
        /// \param filename Filename where the log message comes from
        /// \param line_no Line number where the function was called (where the log comes from)
        /// \param msg Contents of the message to be logged
        /// \return Formatted message
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static std::string Create_Formatted_Log_Msg(const char* const prefix,
                                                                  const std::string& filename,
                                                                  std::size_t line_no,
                                                                  const char* msg);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the current timestamp that will be used in a log message.
        /// \return Current timestamp
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static TTimestamp Get_Timestamp();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Formats a given timestamp.
        /// \param timestamp Timestamp to be formatted
        /// \return Formatted timestamp
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static inline std::string Format_Timestamp(const TTimestamp& timestamp);

    private:
        std::vector<std::shared_ptr<ILogger>> m_loggers; ///< Collection of all registered loggers
        std::mutex m_mtx;                                ///< Mutex for making logging thread-safe
    };

} // namespace zero_mate::utils