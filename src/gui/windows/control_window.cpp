#include <thread>

#include <imgui/imgui.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

#include "control_window.hpp"

#include "../../core/utils/singleton.hpp"

namespace zero_mate::gui
{
    CControl_Window::CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     bool& scroll_to_curr_line,
                                     const bool& elf_file_has_been_loaded,
                                     bool& cpu_running)
    : m_cpu{ cpu }
    , m_scroll_to_curr_line{ scroll_to_curr_line }
    , m_elf_file_has_been_loaded{ elf_file_has_been_loaded }
    , m_logging_system{ utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_cpu_running{ cpu_running }
    {
    }

    void CControl_Window::Render()
    {
        if (ImGui::Begin("Control"))
        {
            static std::atomic<bool> s_start_cpu_thread{ false };
            static std::atomic<bool> s_stop_cpu_thread{ false };

            static bool s_breakpoint{ false };

            Render_Control_Buttons(s_start_cpu_thread, s_stop_cpu_thread);
            Render_CPU_State(s_breakpoint);

            Render_ImGUI_Demo();

            if (s_start_cpu_thread)
            {
                s_start_cpu_thread = false;
                s_stop_cpu_thread = false;
                m_cpu_running = true;
                s_breakpoint = false;

                std::thread cpu_thread([this]() -> void {
                    m_logging_system.Info("CPU execution has started");

                    while (!s_stop_cpu_thread)
                    {
                        if (!m_cpu->Step())
                        {
                            s_breakpoint = true;
                            s_stop_cpu_thread = true;
                            m_logging_system.Info(fmt::format("CPU execution has hit a breakpoint at address 0x{:08X}", m_cpu->m_regs[arm1176jzf_s::CCPU_Core::PC_REG_IDX]).c_str());
                        }
                    }

                    m_cpu_running = false;
                    m_scroll_to_curr_line = true;

                    if (!s_breakpoint)
                    {
                        m_logging_system.Info("CPU execution has stopped");
                    }
                });
                cpu_thread.detach();
            }
        }

        ImGui::End();
    }

    void CControl_Window::Render_Control_Buttons(std::atomic<bool>& start_cpu_thread,
                                                 std::atomic<bool>& stop_cpu_thread)
    {
        if (ImGui::Button(ICON_FA_STEP_FORWARD " Step") && !m_cpu_running)
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

        if (ImGui::Button(ICON_FA_PLAY_CIRCLE " Run") && !m_cpu_running)
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

        if (ImGui::Button(ICON_FA_STOP " Stop") && m_cpu_running)
        {
            stop_cpu_thread = true;
        }
    }

    void CControl_Window::Render_CPU_State(bool breakpoint) const
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
            if (m_cpu_running)
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