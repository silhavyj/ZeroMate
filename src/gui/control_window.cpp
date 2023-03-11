#include <imgui/imgui.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

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

        static bool s_running{ false };

        Render_Control_Buttons(s_running);
        Render_CPU_State(s_running);
        Render_ImGUI_Demo();

        if (s_running)
        {
            if (!m_cpu->Step())
            {
                s_running = false;
            }
        }

        ImGui::End();
    }

    void CControl_Window::Render_Control_Buttons(bool& running)
    {
        if (ImGui::Button(ICON_FA_STEP_FORWARD " Next") && !running)
        {
            m_cpu->Step(true);
        }

        ImGui::SameLine();

        if (ImGui::Button(ICON_FA_PLAY_CIRCLE " Run"))
        {
            running = true;
            m_cpu->Step(true);
        }

        ImGui::SameLine();

        if (ImGui::Button(ICON_FA_STOP " Stop"))
        {
            running = false;
        }
    }

    void CControl_Window::Render_CPU_State(bool running)
    {
        ImGui::Text("State:");
        ImGui::SameLine();

        if (running)
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.f, 1.f, 0.f, 1.f));
            ImGui::Text("running");
        }
        else
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.f, 0.f, 0.f, 1.f));
            ImGui::Text("stopped");
        }
        ImGui::PopStyleColor();
    }

    void CControl_Window::Render_ImGUI_Demo()
    {
        static bool s_show_demo_window{ false };

        ImGui::Checkbox("Show demo window", &s_show_demo_window);
        if (s_show_demo_window)
        {
            ImGui::ShowDemoWindow();
        }
    }
}