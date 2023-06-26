#include <imgui.h>

#include "monitor_window.hpp"

namespace zero_mate::gui
{
    CMonitor_Window::CMonitor_Window(const std::shared_ptr<peripheral::CMonitor>& monitor)
    : m_monitor{ monitor }
    {
    }

    void CMonitor_Window::Render()
    {
        if (ImGui::Begin("Monitor"))
        {
            ImGui::Text("Debug monitor: %dx%d 8-bit characters",
                        peripheral::CMonitor::Width,
                        peripheral::CMonitor::Height);
            ImGui::Separator();

            for (std::uint32_t y = 0; y < peripheral::CMonitor::Height; ++y)
            {
                ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.f, 1.f, 1.f, 0.65f));
                ImGui::Text("%2d:", y + 1);
                ImGui::SameLine();

                ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(255, 255, 0, 255));
                ImGui::Text(
                "%s",
                m_monitor->Get_Data()
                .substr(static_cast<std::size_t>(y) * peripheral::CMonitor::Width, peripheral::CMonitor::Width)
                .c_str());
                ImGui::PopStyleColor(2);
            }
            ImGui::Separator();
        }

        ImGui::End();
    }
}