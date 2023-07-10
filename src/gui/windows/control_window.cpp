#include <thread>
#include <algorithm>

#include <imgui/imgui.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

#include "control_window.hpp"

#include "zero_mate/utils/singleton.hpp"
#include "../../utils/elf_loader.hpp"

namespace zero_mate::gui
{
    CControl_Window::CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     bool& scroll_to_curr_line,
                                     const bool& elf_file_has_been_loaded,
                                     bool& cpu_running,
                                     std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals,
                                     std::shared_ptr<CBus> bus,
                                     const std::string& kernel_filename)
    : m_cpu{ cpu }
    , m_scroll_to_curr_line{ scroll_to_curr_line }
    , m_elf_file_has_been_loaded{ elf_file_has_been_loaded }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_cpu_running{ cpu_running }
    , m_breakpoint_hit{ false }
    , m_start_cpu_thread{ false }
    , m_stop_cpu_thread{ false }
    , m_peripherals{ peripherals }
    , m_bus{ bus }
    , m_kernel_filename{ kernel_filename }
    {
    }

    void CControl_Window::Render()
    {
        if (ImGui::Begin("Control"))
        {

            Render_Control_Buttons();
            Render_CPU_State();

            Render_ImGUI_Demo();

            if (m_start_cpu_thread)
            {
                m_start_cpu_thread = false;
                m_stop_cpu_thread = false;
                m_cpu_running = true;
                m_breakpoint_hit = false;

                std::thread cpu_thread(&CControl_Window::Run, this);
                cpu_thread.detach();
            }
        }

        ImGui::End();
    }

    void CControl_Window::Render_Control_Buttons()
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
                m_start_cpu_thread = true;
                m_cpu->Step(true);
            }
        }

        ImGui::SameLine();

        if (ImGui::Button(ICON_FA_STOP " Stop") && m_cpu_running)
        {
            m_stop_cpu_thread = true;
        }

//        if (ImGui::Button(ICON_FA_POWER_OFF " Reset") && !m_cpu_running)
//        {
//            Reset_Emulator();
//        }

        ImGui::Text("Loaded kernel: %s", m_kernel_filename.c_str());
    }

    void CControl_Window::Reset_Emulator()
    {
//        m_cpu->Reset_Context();
//        std::for_each(m_peripherals.begin(), m_peripherals.end(), [](auto& peripheral) -> void {
//            peripheral->Reset();
//        });
//
//        const auto [error_code, pc, disassembly] = utils::elf::Reload_Kernel(*m_bus);
//
//        switch (error_code)
//        {
//            case utils::elf::NError_Code::OK:
//                m_logging_system.Info(
//                fmt::format("The .ELF file has been loaded successfully. The program starts at 0x{:08X}", pc).c_str());
//                break;
//
//            case utils::elf::NError_Code::ELF_64_Not_Supported:
//                m_logging_system.Error("64 bit ELF format is not supported by the emulator");
//                break;
//
//            case utils::elf::NError_Code::ELF_Loader_Error:
//                m_logging_system.Error(
//                "Failed to load the ELF file. Make sure you entered a valid path to a valid ELF file");
//                break;
//
//            case utils::elf::NError_Code::Disassembly_Engine_Error:
//                m_logging_system.Error("Failed to initialize a disassembly engine");
//                break;
//        }
    }

    void CControl_Window::Render_CPU_State() const
    {
        ImGui::Text("State:");
        ImGui::SameLine();

        if (m_breakpoint_hit)
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
//         static bool s_show_demo_window{ false };
//
//         ImGui::Checkbox("Show demo window", &s_show_demo_window);
//         if (s_show_demo_window)
//         {
//             ImGui::ShowDemoWindow();
//         }
    }

    inline void CControl_Window::Print_No_ELF_File_Loaded_Error_Msg() const
    {
        m_logging_system.Error("No .ELF file has been loaded");
    }

    void CControl_Window::Run()
    {
        m_logging_system.Info("CPU execution has started");
        std::uint32_t prev_pc{ 0 };

        while (!m_stop_cpu_thread)
        {
            if (!m_cpu->Step())
            {
                m_breakpoint_hit = true;
                m_stop_cpu_thread = true;
                m_logging_system.Info(fmt::format("CPU execution has hit a breakpoint at address 0x{:08X}",
                                                  m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx])
                                      .c_str());
            }

            const auto curr_pc = m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx];
            if (prev_pc == curr_pc)
            {
                std::this_thread::sleep_for(std::chrono::milliseconds(1));
            }
            prev_pc = curr_pc;
        }

        m_cpu_running = false;
        m_scroll_to_curr_line = true;

        if (!m_breakpoint_hit)
        {
            m_logging_system.Info("CPU execution has stopped");
        }
    }
}