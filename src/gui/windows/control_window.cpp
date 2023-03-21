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
        static bool s_breakpoint{ false };

        Render_Control_Buttons(s_running, s_breakpoint);
        Render_CPU_State(s_running, s_breakpoint);
        Render_ImGUI_Demo();

        if (s_running)
        {
            if (!m_cpu->Step())
            {
                s_running = false;
                s_breakpoint = true;
            }
        }

        ImGui::End();
    }

    void CControl_Window::Render_Control_Buttons(bool& running, bool& breakpoint)
    {
        if (ImGui::Button(ICON_FA_STEP_FORWARD " Step") && !running)
        {
            m_cpu->Step(true);
        }

        ImGui::SameLine();

        if (ImGui::Button(ICON_FA_PLAY_CIRCLE " Run"))
        {
            running = true;
            breakpoint = false;
            m_cpu->Step(true);
        }

        ImGui::SameLine();

        if (ImGui::Button(ICON_FA_STOP " Stop"))
        {
            running = false;
        }
    }

    void CControl_Window::Render_CPU_State(bool running, bool breakpoint)
    {
        ImGui::Text("State:");
        ImGui::SameLine();

        if (breakpoint)
        {
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 0.7f, 1.0f, 1.0f));
            ImGui::Text("breakpoint");
        }
        else
        {
            if (running)
            {
                ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f));
                ImGui::Text("running");
            }
            else
            {
                ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 1.0f));
                ImGui::Text("stopped");
            }
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