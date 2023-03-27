#include <fmt/format.h>

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
        m_buffer.clear();
        m_line_offsets.clear();
        m_line_offsets.push_back(0);
    }

    void CLog_Window::Add_Log(const char* fmt, ...)
    {
        int old_size = m_buffer.size();

        va_list args;
        va_start(args, fmt);

        m_buffer.appendfv(fmt, args);
        va_end(args);

        for (const int new_size = m_buffer.size(); old_size < new_size; ++old_size)
        {
            if (m_buffer[old_size] == '\n')
            {
                m_line_offsets.push_back(old_size + 1);
            }
        }
    }

    void CLog_Window::Render()
    {
        if (!ImGui::Begin("Logs"))
        {
            ImGui::End();
        }

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

            const char* buf = m_buffer.begin();
            const char* buf_end = m_buffer.end();

            if (m_filter.IsActive())
            {
                for (int line_no = 0; line_no < m_line_offsets.Size; ++line_no)
                {
                    const char* line_start = buf + m_line_offsets[line_no];
                    const char* line_end = (line_no + 1 < m_line_offsets.Size) ? (buf + m_line_offsets[line_no + 1] - 1) : buf_end;

                    if (m_filter.PassFilter(line_start, line_end))
                    {
                        Set_Log_Message_Color({ line_start, line_end });
                        ImGui::TextUnformatted(line_start, line_end);
                        ImGui::PopStyleColor();
                    }
                }
            }
            else
            {
                ImGuiListClipper clipper;
                clipper.Begin(m_line_offsets.Size);

                while (clipper.Step())
                {
                    for (int line_no = clipper.DisplayStart; line_no < clipper.DisplayEnd; line_no++)
                    {
                        const char* line_start = buf + m_line_offsets[line_no];
                        const char* line_end = (line_no + 1 < m_line_offsets.Size) ? (buf + m_line_offsets[line_no + 1] - 1) : buf_end;

                        Set_Log_Message_Color({ line_start, line_end });
                        ImGui::TextUnformatted(line_start, line_end);
                        ImGui::PopStyleColor();
                    }
                }
                clipper.End();
            }
            ImGui::PopStyleVar();

            if (m_auto_scroll && ImGui::GetScrollY() >= ImGui::GetScrollMaxY())
            {
                ImGui::SetScrollHereY(1.0f);
            }
        }

        ImGui::EndChild();
        ImGui::End();
    }

    void CLog_Window::Set_Log_Message_Color(const std::string& message) const
    {
        if (message.starts_with(DEBUG_MSG_PREFIX))
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 0.7f, 1.0f, 1.0f));
        }
        else if (message.starts_with(INFO_MSG_PREFIX))
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f));
        }
        else if (message.starts_with(WARNING_MSG_PREFIX))
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 0.0f, 1.0f));
        }
        else if (message.starts_with(ERROR_MSG_PREFIX))
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
        Add_Log("%s\n", msg);
    }

    void CLog_Window::Debug(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Debug)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        Add_Log("%s\n", fmt::format("{} [{}:{}:{}] {}", DEBUG_MSG_PREFIX, filename, location.line(), location.function_name(), msg).c_str());
    }

    void CLog_Window::Info(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Info)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        Add_Log("%s\n", fmt::format("{} [{}:{}:{}] {}", INFO_MSG_PREFIX, filename, location.line(), location.function_name(), msg).c_str());
    }

    void CLog_Window::Warning(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Warning)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        Add_Log("%s\n", fmt::format("{} [{}:{}:{}] {}", WARNING_MSG_PREFIX, filename, location.line(), location.function_name(), msg).c_str());
    }

    void CLog_Window::Error(const char* msg, const std::source_location& location)
    {
        if (m_logging_level > NLogging_Level::Error)
        {
            return;
        }

        const auto filename = ILogger::Extract_Filename(location);
        Add_Log("%s\n", fmt::format("{} [{}:{}:{}] {}", ERROR_MSG_PREFIX, filename, location.line(), location.function_name(), msg).c_str());
    }
}