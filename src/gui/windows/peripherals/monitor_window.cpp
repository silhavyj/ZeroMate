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
            ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(255, 255, 0, 255));

            for (std::uint32_t y = 0; y < peripheral::CMonitor::HEIGHT; ++y)
            {
                ImGui::Text("%s", m_monitor->Get_Data().substr(static_cast<std::size_t>(y) * peripheral::CMonitor::WIDTH, peripheral::CMonitor::WIDTH).c_str());
            }

            ImGui::PopStyleColor();
        }

        ImGui::End();
    }
}