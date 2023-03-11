#include <imgui/imgui.h>

#include "control_window.hpp"

namespace zero_mate::gui
{
    CControl_Window::CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu)
    : m_cpu{ cpu }
    {
    }

    void CControl_Window::Render()
    {
        ImGui::Begin("Control");

        static bool s_run{ false };
        static bool s_show_demo_window{ false };

        if (ImGui::Button("Next") && !s_run)
        {
            m_cpu->Step();
        }

        ImGui::SameLine();

        if (ImGui::Button("Run"))
        {
            s_run = true;
        }

        ImGui::SameLine();

        if (ImGui::Button("Stop"))
        {
            s_run = false;
        }

        if (s_run)
        {
            if (!m_cpu->Step())
            {
                s_run = false;
            }
        }

        // TODO add colors
        ImGui::Text("State: %s", s_run ? "running" : "stopped");

        ImGui::Checkbox("Show demo window", &s_show_demo_window);
        if (s_show_demo_window)
        {
            ImGui::ShowDemoWindow();
        }

        ImGui::End();
    }
}