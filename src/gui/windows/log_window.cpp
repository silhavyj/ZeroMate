// ---------------------------------------------------------------------------------------------------------------------
/// \file log_window.cpp
/// \date 08. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that displays log messages.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "log_window.hpp"

namespace zero_mate::gui
{
    CLog_Window::CLog_Window()
    : m_auto_scroll{ true }
    {
        Clear();
    }

    void CLog_Window::Clear()
    {
        // Clear all log messages.
        m_buffer.Clear();
    }

    void CLog_Window::Render()
    {
        // Make sure that adding a new log message does not interrupt rendering of the window.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Render the window.
        if (ImGui::Begin("Logs"))
        {
            Render_Top_Bar();
            Render_Message_Area();
        }

        ImGui::End();
    }

    void CLog_Window::Render_Top_Bar()
    {
        // Options
        Render_Window_Options();
        ImGui::SameLine();

        // Clear button
        Render_Clear_Button();
        ImGui::SameLine();

        // Filter
        Render_Filter();
        ImGui::Separator();
    }

    void CLog_Window::Render_Message_Area()
    {
        // Render a scrolling area.
        if (ImGui::BeginChild("scrolling", ImVec2(0, 0), false, ImGuiWindowFlags_HorizontalScrollbar))
        {
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 0));

            // Check if the filer is activated or not.
            if (m_filter.IsActive())
            {
                // Render only filtered messages.
                Render_Filtered_Log_Messages();
            }
            else
            {
                // Render all message.
                Render_All_Log_Messages();
            }

            ImGui::PopStyleVar();

            // If autoscroll is enabled, scroll to the very bottom.
            if (m_auto_scroll && ImGui::GetScrollY() >= ImGui::GetScrollMaxY())
            {
                ImGui::SetScrollHereY(1.0f);
            }
        }

        ImGui::EndChild();
    }

    void CLog_Window::Render_Filter()
    {
        m_filter.Draw("Filter", -100.0f);
    }

    void CLog_Window::Render_Clear_Button()
    {
        // Render the button and check if it is being pressed
        if (ImGui::Button("Clear"))
        {
            Clear();
        }
    }

    void CLog_Window::Render_Window_Options()
    {
        // Define the popup menu (it does not show it yet).
        if (ImGui::BeginPopup("Options"))
        {
            ImGui::Checkbox("Auto-scroll", &m_auto_scroll);
            ImGui::EndPopup();
        }

        // When the options button is clicked, the popup menu will appear.
        if (ImGui::Button("Options"))
        {
            ImGui::OpenPopup("Options");
        }
    }

    void CLog_Window::Render_Filtered_Log_Messages()
    {
        // Go through all log messages.
        for (const auto& log_msg : m_buffer.Get_Data())
        {
            // Get the start and end pointer of the current message.
            const char* line_start = log_msg.c_str();
            const char* line_end = line_start + log_msg.length();

            // Check if the message passes the filter.
            if (m_filter.PassFilter(line_start, line_end))
            {
                // Render the message.
                Set_Log_Message_Color({ line_start, line_end });
                ImGui::TextUnformatted(line_start, line_end);
                ImGui::PopStyleColor();
            }
        }
    }

    void CLog_Window::Render_All_Log_Messages()
    {
        // Use a clipper to figure out what messages fit into the window and therefore should be rendered.
        ImGuiListClipper clipper;
        clipper.Begin(static_cast<int>(m_buffer.Get_Data().size()));

        while (clipper.Step())
        {
            // Render only those messages that fit into the window (that are visible to the user).
            for (int line_no = clipper.DisplayStart; line_no < clipper.DisplayEnd; ++line_no)
            {
                // Get the start and end pointer of the current message.
                const char* line_start = m_buffer.Get_Data()[static_cast<std::size_t>(line_no)].c_str();
                const char* line_end = line_start + m_buffer.Get_Data()[static_cast<std::size_t>(line_no)].length();

                // Render the message.
                Set_Log_Message_Color({ line_start, line_end });
                ImGui::TextUnformatted(line_start, line_end);
                ImGui::PopStyleColor();
            }
        }

        clipper.End();
    }

    void CLog_Window::Set_Log_Message_Color(const std::string& msg)
    {
        // If the message is not prefixed with a timestamp, return the default color (white).
        if (msg.length() <= utils::CLogging_System::Timestamp_Length)
        {
            ImGui::PushStyleColor(ImGuiCol_Text, color::White);
        }

        // Cut off the prefix of the message (timestamp).
        const std::string msg_with_no_timestamp = msg.substr(utils::CLogging_System::Timestamp_Length);

        // Determine the color based on the type of the message.
        if (msg_with_no_timestamp.starts_with(utils::CLogging_System::Debug_Msg_Prefix))
        {
            // Debug
            ImGui::PushStyleColor(ImGuiCol_Text, color::Blue);
        }
        else if (msg_with_no_timestamp.starts_with(utils::CLogging_System::Info_Msg_Prefix))
        {
            // Info
            ImGui::PushStyleColor(ImGuiCol_Text, color::Green);
        }
        else if (msg_with_no_timestamp.starts_with(utils::CLogging_System::Warning_Msg_Prefix))
        {
            // Warning
            ImGui::PushStyleColor(ImGuiCol_Text, color::Yellow);
        }
        else if (msg_with_no_timestamp.starts_with(utils::CLogging_System::Error_Msg_Prefix))
        {
            // Error
            ImGui::PushStyleColor(ImGuiCol_Text, color::Red);
        }
        else
        {
            // If an invalid type is detected, return the default color (white).
            ImGui::PushStyleColor(ImGuiCol_Text, color::White);
        }
    }

    void CLog_Window::Print(const char* msg)
    {
        // Make added a log message thread-sage.
        const std::lock_guard<std::mutex> lock(m_mtx);

        m_buffer.Add(msg);
    }

    void CLog_Window::Debug(const char* msg)
    {
        // Make added a log message thread-sage.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Check if the logging level is set to Debug or less.
        if (m_logging_level <= NLogging_Level::Debug)
        {
            m_buffer.Add(msg);
        }
    }

    void CLog_Window::Info(const char* msg)
    {
        // Make added a log message thread-sage.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Check if the logging level is set to Info or less.
        if (m_logging_level <= NLogging_Level::Info)
        {
            m_buffer.Add(msg);
        }
    }

    void CLog_Window::Warning(const char* msg)
    {
        // Make added a log message thread-sage.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Check if the logging level is set to Warning or less.
        if (m_logging_level <= NLogging_Level::Warning)
        {
            m_buffer.Add(msg);
        }
    }

    void CLog_Window::Error(const char* msg)
    {
        // Make added a log message thread-sage.
        const std::lock_guard<std::mutex> lock(m_mtx);

        // Check if the logging level is set to Error or less.
        if (m_logging_level <= NLogging_Level::Error)
        {
            m_buffer.Add(msg);
        }
    }

} // namespace zero_mate::gui