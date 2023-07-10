// ---------------------------------------------------------------------------------------------------------------------
/// \file control_window.cpp
/// \date 10. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that allows the user to control CPU execution.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <thread>
/// \endcond

// 3rd party libraries

#include "imgui/imgui.h"
#include "IconFontCppHeaders/IconsFontAwesome5.h"

// Project file imports

#include "control_window.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::gui
{
    // Anonymous namespace to make its content visible only to this translation unit.
    namespace
    {
        [[maybe_unused]] void Render_ImGUI_Demo()
        {
            static bool s_show_demo_window{ false };

            // Check box to close the demo window.
            ImGui::Checkbox("Show demo window", &s_show_demo_window);

            // Show the window.
            if (s_show_demo_window)
            {
                ImGui::ShowDemoWindow();
            }
        }
    }

    CControl_Window::CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     bool& scroll_to_curr_line,
                                     const bool& elf_file_has_been_loaded,
                                     bool& cpu_running,
                                     const std::string& kernel_filename)
    : m_cpu{ cpu }
    , m_scroll_to_curr_line{ scroll_to_curr_line }
    , m_elf_file_has_been_loaded{ elf_file_has_been_loaded }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_cpu_running{ cpu_running }
    , m_breakpoint_hit{ false }
    , m_start_cpu_thread{ false }
    , m_stop_cpu_thread{ false }
    , m_kernel_filename{ kernel_filename }
    {
    }

    void CControl_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("Control"))
        {
            Render_Control_Buttons();
            Render_CPU_State();
            Render_Currently_Loaded_Kernel();

            // Just for debugging purposes.
            // Render_ImGUI_Demo();

            // Should we start CPU execution?
            if (m_start_cpu_thread)
            {
                Start_CPU_Thread();
            }
        }

        ImGui::End();
    }

    void CControl_Window::Render_Currently_Loaded_Kernel()
    {
        ImGui::Text("Loaded kernel: %s", m_kernel_filename.c_str());
    }

    void CControl_Window::Start_CPU_Thread()
    {
        // Clear the flags.
        m_start_cpu_thread = false;
        m_stop_cpu_thread = false;
        m_breakpoint_hit = false;

        // The CPU is now running.
        m_cpu_running = true;

        // Start CPU execution in a separate thread.
        std::thread cpu_thread(&CControl_Window::Run, this);
        cpu_thread.detach();
    }

    void CControl_Window::Render_Step_Button()
    {
        if (ImGui::Button(ICON_FA_STEP_FORWARD " Step") && !m_cpu_running)
        {
            // Make sure a kernel has been loaded.
            if (!m_elf_file_has_been_loaded)
            {
                Print_No_ELF_File_Loaded_Error_Msg();
            }
            else
            {
                // Perform a single step regardless of any set breakpoints.
                m_cpu->Step(true);

                // Trigger the GUI to scroll to the current line of execution.
                m_scroll_to_curr_line = true;
            }
        }
    }

    void CControl_Window::Render_Stop_Button()
    {
        if (ImGui::Button(ICON_FA_STOP " Stop") && m_cpu_running)
        {
            // Set the flag to stop CPU execution (running thread).
            m_stop_cpu_thread = true;
        }
    }

    void CControl_Window::Render_Run_Button()
    {
        if (ImGui::Button(ICON_FA_PLAY_CIRCLE " Run") && !m_cpu_running)
        {
            // Make sure a kernel has been loaded.
            if (!m_elf_file_has_been_loaded)
            {
                Print_No_ELF_File_Loaded_Error_Msg();
            }
            else
            {
                // Set the flag to start CPU execution.
                m_start_cpu_thread = true;

                // Perform a single step regardless of any set breakpoints.
                m_cpu->Step(true);
            }
        }
    }

    void CControl_Window::Render_Control_Buttons()
    {
        // Step button
        Render_Step_Button();
        ImGui::SameLine();

        // Run button
        Render_Run_Button();
        ImGui::SameLine();

        // Stop button
        Render_Stop_Button();
        ImGui::Separator();
    }

    void CControl_Window::Render_CPU_State() const
    {
        // Render a "state" label.
        ImGui::Text("State:");
        ImGui::SameLine();

        if (m_breakpoint_hit)
        {
            // Breakpoint
            ImGui::PushStyleColor(ImGuiCol_Text, color::Light_Blue);
            ImGui::Text("Breakpoint");
        }
        else
        {
            if (m_cpu_running)
            {
                // Running
                ImGui::PushStyleColor(ImGuiCol_Text, color::Green);
                ImGui::Text("Running");
            }
            else
            {
                // Stopped
                ImGui::PushStyleColor(ImGuiCol_Text, color::Red);
                ImGui::Text("Stopped");
            }
        }

        // Do not forget to pop the pushed style (color).
        ImGui::PopStyleColor();
    }

    inline void CControl_Window::Print_No_ELF_File_Loaded_Error_Msg() const
    {
        m_logging_system.Error("No .ELF file has been loaded");
    }

    void CControl_Window::Run()
    {
        m_logging_system.Info("CPU execution has started");

        // Keep stepping the CPU
        while (!m_stop_cpu_thread)
        {
            // Perform a single step and check if the execution has hit a breakpoint.
            if (!m_cpu->Step())
            {
                // Breakpoint hit -> CPU has execution stopped.
                m_breakpoint_hit = true;
                m_stop_cpu_thread = true;

                // clang-format off
                m_logging_system.Info(fmt::format("CPU execution has hit a breakpoint at address 0x{:08X}",
                                      m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx]).c_str());
                // clang-format on
            }
        }

        // CPU is no longer in a running mode.
        m_cpu_running = false;

        // The GUI should scroll to the current line of execution.
        m_scroll_to_curr_line = true;

        // If the CPU was not due to a breakpoint.
        if (!m_breakpoint_hit)
        {
            m_logging_system.Info("CPU execution has stopped");
        }
    }

} // namespace zero_mate::gui