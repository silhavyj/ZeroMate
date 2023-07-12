// ---------------------------------------------------------------------------------------------------------------------
/// \file monitor_window.cpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that visualizes the memory-mapped debug monitor.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "monitor_window.hpp"

namespace zero_mate::gui
{
    CMonitor_Window::CMonitor_Window(const std::shared_ptr<peripheral::CMonitor>& monitor)
    : m_monitor{ monitor }
    {
    }

    void CMonitor_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("Monitor"))
        {
            // Render information about the monitor.
            Render_Monitor_Info();
            ImGui::Separator();

            // Render the monitor itself.
            Render_Monitor();
            ImGui::Separator();
        }

        ImGui::End();
    }

    std::string CMonitor_Window::Get_Current_Row(std::size_t line_no)
    {
        // Start index in the buffer.
        const auto start_idx = static_cast<std::size_t>(line_no) * peripheral::CMonitor::Width;

        return m_monitor->Get_Data().substr(start_idx, peripheral::CMonitor::Width);
    }

    void CMonitor_Window::Render_Monitor()
    {
        for (std::uint32_t row = 0; row < peripheral::CMonitor::Height; ++row)
        {
            // Render the current line number.
            ImGui::PushStyleColor(ImGuiCol_Text, color::Gray);
            ImGui::Text("%2d:", row + 1);
            ImGui::SameLine();

            // Render the current line of the monitor.
            ImGui::PushStyleColor(ImGuiCol_Text, color::Yellow);
            ImGui::Text("%s", Get_Current_Row(row).c_str());

            // Pop out custom colors (current line number & monitor).
            ImGui::PopStyleColor(2);
        }
    }

    void CMonitor_Window::Render_Monitor_Info()
    {
        // Render general information about the monitor.
        ImGui::Text("Debug monitor: %dx%d 8-bit characters", peripheral::CMonitor::Width, peripheral::CMonitor::Height);
    }

} // namespace zero_mate::gui