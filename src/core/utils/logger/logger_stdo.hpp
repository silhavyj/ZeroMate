// ---------------------------------------------------------------------------------------------------------------------
/// \file logger_stdo.hpp
/// \date 02. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a standard output logger (STDO).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <mutex>
/// \endcond

// Project file imports

#include "logger.hpp"

namespace zero_mate::utils
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CLogger_STDO
    /// \brief This class represents a logger that logs messages to the standard output (STDO).
    // -----------------------------------------------------------------------------------------------------------------
    class CLogger_STDO final : public ILogger
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        // -------------------------------------------------------------------------------------------------------------
        CLogger_STDO() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Prints out a given message without any special formatting applied (ILogger interface).
        /// \param msg Plain text message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Print(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a debug message (ILogger interface).
        /// \param msg Debug message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Debug(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an info message (ILogger interface).
        /// \param msg Info message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Info(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a warning message (ILogger interface).
        /// \param msg Warning message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Warning(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an error message (ILogger interface).
        /// \param msg Error message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Error(const char* msg) override;

    private:
        std::mutex m_mtx; ///< Mutex for making logging thread-safe
    };

} // namespace zero_mate::utils