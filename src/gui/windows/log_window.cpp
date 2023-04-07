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
        m_buffer.Clear();
    }

    void CLog_Window::Render()
    {
        if (ImGui::Begin("Logs"))
        {
            if (ImGui::BeginPopup("Options"))
            {
                ImGui::Checkbox("Auto-scroll", &m_auto_scroll);
                ImGui::EndPopup();
            }

            if (ImGui::Button("Options"))
            {
                ImGui::OpenPopup("Options");
            }

            ImGui::SameLine();
            const bool clear_btn_pressed = ImGui::Button("Clear");
            ImGui::SameLine();
            const bool copy_btn_pressed = ImGui::Button("Copy");
            ImGui::SameLine();
            m_filter.Draw("Filter", -100.0f);

            ImGui::Separator();

            if (ImGui::BeginChild("scrolling", ImVec2(0, 0), false, ImGuiWindowFlags_HorizontalScrollbar))
            {
                if (clear_btn_pressed)
                {
                    Clear();
                }
                if (copy_btn_pressed)
                {
                    ImGui::LogToClipboard();
                }

                ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 0));

                if (m_filter.IsActive())
                {
                    Render_Filtered_Log_Messages();
                }
                else
                {
                    Render_All_Log_Messages();
                }

                ImGui::PopStyleVar();

                if (m_auto_scroll && ImGui::GetScrollY() >= ImGui::GetScrollMaxY())
                {
                    ImGui::SetScrollHereY(1.0f);
                }
            }

            ImGui::EndChild();
        }

        ImGui::End();
    }

    void CLog_Window::Render_Filtered_Log_Messages()
    {
        for (const auto& log_msg : m_buffer.Get_Data())
        {
            const char* line_start = log_msg.c_str();
            const char* line_end = line_start + log_msg.length();

            if (m_filter.PassFilter(line_start, line_end))
            {
                Set_Log_Message_Color({ line_start, line_end });
                ImGui::TextUnformatted(line_start, line_end);
                ImGui::PopStyleColor();
            }
        }
    }

    void CLog_Window::Render_All_Log_Messages()
    {
        ImGuiListClipper clipper;
        clipper.Begin(static_cast<int>(m_buffer.Get_Data().size()));

        while (clipper.Step())
        {
            for (int line_no = clipper.DisplayStart; line_no < clipper.DisplayEnd; ++line_no)
            {
                const char* line_start = m_buffer.Get_Data()[static_cast<std::size_t>(line_no)].c_str();
                const char* line_end = line_start + m_buffer.Get_Data()[static_cast<std::size_t>(line_no)].length();

                Set_Log_Message_Color({ line_start, line_end });
                ImGui::TextUnformatted(line_start, line_end);
                ImGui::PopStyleColor();
            }
        }
        clipper.End();
    }

    void CLog_Window::Set_Log_Message_Color(const std::string& msg)
    {
        if (msg.starts_with(utils::CLogging_System::DEBUG_MSG_PREFIX))
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 0.7f, 1.0f, 1.0f));
        }
        else if (msg.starts_with(utils::CLogging_System::INFO_MSG_PREFIX))
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f));
        }
        else if (msg.starts_with(utils::CLogging_System::WARNING_MSG_PREFIX))
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 0.0f, 1.0f));
        }
        else if (msg.starts_with(utils::CLogging_System::ERROR_MSG_PREFIX))
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 1.0f));
        }
        else
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 1.0f));
        }
    }

    void CLog_Window::Print(const char* msg)
    {
        m_buffer.Add(msg);
    }

    void CLog_Window::Debug(const char* msg)
    {
        if (m_logging_level <= NLogging_Level::Debug)
        {
            m_buffer.Add(msg);
        }
    }

    void CLog_Window::Info(const char* msg)
    {
        if (m_logging_level <= NLogging_Level::Info)
        {
            m_buffer.Add(msg);
        }
    }

    void CLog_Window::Warning(const char* msg)
    {
        if (m_logging_level <= NLogging_Level::Warning)
        {
            m_buffer.Add(msg);
        }
    }

    void CLog_Window::Error(const char* msg)
    {
        if (m_logging_level <= NLogging_Level::Error)
        {
            m_buffer.Add(msg);
        }
    }
}