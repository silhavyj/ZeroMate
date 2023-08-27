// ---------------------------------------------------------------------------------------------------------------------
/// \file logger.hpp
/// \date 22. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a general logger interface.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <mutex>
#include <vector>
#include <memory>
#include <cstdint>
#include <string_view>
/// \endcond

namespace zero_mate::utils
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class ILogger
    /// \brief This class represents a logging_system interface.
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

} // namespace zero_mate::utils