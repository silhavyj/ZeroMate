#include <thread>

#include <imgui/imgui.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

#include "control_window.hpp"

#include "../../core/utils/singleton.hpp"

namespace zero_mate::gui
{
    CControl_Window::CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     bool& scroll_to_curr_line,
                                     const bool& elf_file_has_been_loaded)
    : m_cpu{ cpu }
    , m_scroll_to_curr_line{ scroll_to_curr_line }
    , m_elf_file_has_been_loaded{ elf_file_has_been_loaded }
    , m_logging_system{ utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
    }

    void CControl_Window::Render()
    {
        m_scroll_to_curr_line = false;

        if (ImGui::Begin("Control"))
        {
            static bool s_running{ false };
            static std::atomic<bool> s_start_cpu_thread{ false };
            static std::atomic<bool> s_stop_cpu_thread{ false };

            static bool s_breakpoint{ false };

            Render_Control_Buttons(s_start_cpu_thread, s_stop_cpu_thread, s_running);
            Render_CPU_State(s_running, s_breakpoint);
            Render_ImGUI_Demo();

            if (s_start_cpu_thread)
            {
                s_start_cpu_thread = false;
                s_stop_cpu_thread = false;
                s_running = true;
                s_breakpoint = false;

                std::thread cpu_thread([this]() -> void {
                    while (!s_stop_cpu_thread)
                    {
                        if (!m_cpu->Step())
                        {
                            s_start_cpu_thread = true;
                            s_breakpoint = true;
                        }
                    }

                    s_running = false;
                    m_scroll_to_curr_line = true;
                });
                cpu_thread.detach();
            }
        }

        ImGui::End();
    }

    void CControl_Window::Render_Control_Buttons(std::atomic<bool>& start_cpu_thread,
                                                 std::atomic<bool>& stop_cpu_thread,
                                                 const bool& running)
    {
        if (ImGui::Button(ICON_FA_STEP_FORWARD " Step") && !running)
        {
            if (!m_elf_file_has_been_loaded)
            {
                Print_No_ELF_File_Loaded_Error_Msg();
            }
            else
            {
                m_cpu->Step(true);
                m_scroll_to_curr_line = true;
            }
        }

        ImGui::SameLine();

        if (ImGui::Button(ICON_FA_PLAY_CIRCLE " Run") && !running)
        {
            if (!m_elf_file_has_been_loaded)
            {
                Print_No_ELF_File_Loaded_Error_Msg();
            }
            else
            {
                start_cpu_thread = true;
                m_cpu->Step(true);
            }
        }

        ImGui::SameLine();

        if (ImGui::Button(ICON_FA_STOP " Stop") && running)
        {
            stop_cpu_thread = true;
        }
    }

    void CControl_Window::Render_CPU_State(const bool& running, bool breakpoint)
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

    inline void CControl_Window::Print_No_ELF_File_Loaded_Error_Msg() const
    {
        m_logging_system.Error("No .ELF file has been loaded");
    }
}