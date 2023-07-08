// ---------------------------------------------------------------------------------------------------------------------
/// \file log_window.hpp
/// \date 08. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that displays log messages.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include <mutex>
#include <vector>

// 3rd party libraries

#include "imgui/imgui.h"

// Project file imports

#include "../window.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCircular_Log_Buffer
    /// \brief This class represents a circular buffer (for log messages)
    /// \tparam Type Type of a log message (e.g. std::string)
    /// \tparam Size Size of the buffer (maximum number of elements it can hold at a time)
    // -----------------------------------------------------------------------------------------------------------------
    template<typename Type, std::size_t Size>
    class CCircular_Log_Buffer final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CCircular_Log_Buffer() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Adds a log message into the buffer.
        /// \param value Log message to be added into the circular buffer.
        // -------------------------------------------------------------------------------------------------------------
        void Add(Type value)
        {
            // Check if the maximum number of elements has been exceeded.
            if (m_data.size() >= Size)
            {
                // Remove the first element.
                m_data.erase(m_data.begin());
            }

            m_data.push_back(value);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears the circular buffer (deletes all log messages).
        // -------------------------------------------------------------------------------------------------------------
        void Clear()
        {
            m_data.clear();
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a collection of log messages currently stored in the buffer.
        /// \return Collection of log messages.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const auto& Get_Data() const
        {
            return m_data;
        }

    private:
        std::vector<Type> m_data; ///< Collection of log messages
    };

    // Assigned colors of different kinds of log messages.
    namespace color
    {
        static constexpr ImVec4 White{ 1.0F, 1.0F, 1.0F, 1.0F };
        static constexpr ImVec4 Blue{ 0.0F, 0.7F, 1.0F, 1.0F };
        static constexpr ImVec4 Green{ 0.0F, 1.0F, 0.0F, 1.0F };
        static constexpr ImVec4 Yellow{ 1.0F, 1.0F, 0.0F, 1.0F };
        static constexpr ImVec4 Red{ 1.0F, 0.0F, 0.0F, 1.0F };

    } // namespace color

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CLog_Window
    /// \brief This class represents a window that displays log messages.
    // -----------------------------------------------------------------------------------------------------------------
    class CLog_Window final : public utils::ILogger, public IGUI_Window
    {
    public:
        /// Maximum number of log messages stored in a circular buffer (zero_mate::gui::CCircular_Log_Buffer)
        static constexpr std::size_t Max_Logs = 256;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CLog_Window();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a plain-text message (no formatting is taking place, utils::ILogger interface).
        /// \param msg Plain-text message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Print(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a debug message (utils::ILogger interface).
        /// \param msg Debug message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Debug(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an info message (utils::ILogger interface).
        /// \param msg Info message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Info(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs a warning message (utils::ILogger interface).
        /// \param msg Warning message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Warning(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Logs an error message (utils::ILogger interface).
        /// \param msg Error message to be logged
        // -------------------------------------------------------------------------------------------------------------
        void Error(const char* msg) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the window (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears all log messages.
        // -------------------------------------------------------------------------------------------------------------
        void Clear();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the color of a log message based on its type (error, info, etc.)
        /// \param msg Formatted error message
        // -------------------------------------------------------------------------------------------------------------
        static void Set_Log_Message_Color(const std::string& msg);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders log messages that satisfy the criteria given by a message filter.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Filtered_Log_Messages();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders all log messages (no filter activated).
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_All_Log_Messages();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the top bar of the window (the options, clear button, and the filter)
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Top_Bar();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the message scrolling area.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Message_Area();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a popup menu (options).
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Window_Options();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a clear button for clearing the message area.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Clear_Button();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a message filer.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Filter();

    private:
        ImGuiTextFilter m_filter;                             ///< Filer for log messages
        bool m_auto_scroll;                                   ///< Autoscroll enabled
        CCircular_Log_Buffer<std::string, Max_Logs> m_buffer; ///< Buffer containing log messages
        std::mutex m_mtx;                                     ///< Mutual exclusion (thread-safe)
    };

} // namespace zero_mate::gui