// ---------------------------------------------------------------------------------------------------------------------
/// \file registers_window.cpp
/// \date 05. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that displays the contents of all CPU registers.
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party library includes

#include "magic_enum.hpp"
#include "fmt/format.h"

// Project file imports

#include "registers_window.hpp"

namespace zero_mate::gui
{
    CRegisters_Window::CRegisters_Window(const std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu)
    : m_cpu{ cpu }
    , m_tab_states{ .USR_SYS_tab_open = ImGuiTabItemFlags_None,
                    .FIQ_tab_open = ImGuiTabItemFlags_None,
                    .SVC_tab_open = ImGuiTabItemFlags_None,
                    .ABT_tab_open = ImGuiTabItemFlags_None,
                    .IRQ_tab_open = ImGuiTabItemFlags_None,
                    .UND_tab_open = ImGuiTabItemFlags_None }
    , m_cpu_mode_prev{ cpu->Get_CPU_Context().Get_CPU_Mode() }
    {
    }

    void CRegisters_Window::Check_If_CPU_Mode_Changes(const arm1176jzf_s::CCPU_Context& cpu_context)
    {
        // Get the current CPU mode.
        const auto cpu_mode = cpu_context.Get_CPU_Mode();

        // Check if the CPU mode has changed -> select the corresponding tab.
        if (cpu_mode != m_cpu_mode_prev)
        {
            // Check the current state of the CPU mode and select the tab.
            switch (cpu_mode)
            {
                // FIQ
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::FIQ:
                    m_tab_states.FIQ_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                // IRQ
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::IRQ:
                    m_tab_states.IRQ_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                // SVC
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::Supervisor:
                    m_tab_states.SVC_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                // ABT
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::Abort:
                    m_tab_states.ABT_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                // UDN
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::Undefined:
                    m_tab_states.UND_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                // USR/SYS
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::User:
                    [[fallthrough]];
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::System:
                    m_tab_states.USR_SYS_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;
            }

            // Update the previous cpu mode.
            m_cpu_mode_prev = cpu_mode;
        }
    }

    void CRegisters_Window::Render_CPU_Mode(const arm1176jzf_s::CCPU_Context& cpu_context)
    {
        // Render the current CPU mode.
        ImGui::Text("CPU Mode: %s", fmt::format("{}", magic_enum::enum_name(cpu_context.Get_CPU_Mode())).c_str());
        ImGui::Separator();
    }

    void CRegisters_Window::Render_Register_Modes_Tabs(const arm1176jzf_s::CCPU_Context& cpu_context)
    {
        // Render the tabs (registers in different CPU modes).
        if (ImGui::BeginTabBar("##cpu_regs_tabs"))
        {
            // USR tab
            if (ImGui::BeginTabItem("USR/SYS", nullptr, m_tab_states.USR_SYS_tab_open))
            {
                // If the tab gets clicked on, select it as the current tab.
                m_tab_states.USR_SYS_tab_open = ImGuiTabItemFlags_None;

                Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::User, cpu_context);
                ImGui::EndTabItem();
            }

            // FIQ  tab
            if (ImGui::BeginTabItem("FIQ", nullptr, m_tab_states.FIQ_tab_open))
            {
                // If the tab gets clicked on, select it as the current tab.
                m_tab_states.FIQ_tab_open = ImGuiTabItemFlags_None;

                Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::FIQ, cpu_context);
                ImGui::EndTabItem();
            }

            // SVC  tab
            if (ImGui::BeginTabItem("SVC", nullptr, m_tab_states.SVC_tab_open))
            {
                // If the tab gets clicked on, select it as the current tab.
                m_tab_states.SVC_tab_open = ImGuiTabItemFlags_None;

                Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::Supervisor, cpu_context);
                ImGui::EndTabItem();
            }

            // ABT  tab
            if (ImGui::BeginTabItem("ABT", nullptr, m_tab_states.ABT_tab_open))
            {
                // If the tab gets clicked on, select it as the current tab.
                m_tab_states.ABT_tab_open = ImGuiTabItemFlags_None;

                Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::Abort, cpu_context);
                ImGui::EndTabItem();
            }

            // IRQ  tab
            if (ImGui::BeginTabItem("IRQ", nullptr, m_tab_states.IRQ_tab_open))
            {
                // If the tab gets clicked on, select it as the current tab.
                m_tab_states.IRQ_tab_open = ImGuiTabItemFlags_None;

                Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::IRQ, cpu_context);
                ImGui::EndTabItem();
            }

            // UDN  tab
            if (ImGui::BeginTabItem("UDN", nullptr, m_tab_states.UND_tab_open))
            {
                // If the tab gets clicked on, select it as the current tab.
                m_tab_states.UND_tab_open = ImGuiTabItemFlags_None;

                Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::Undefined, cpu_context);
                ImGui::EndTabItem();
            }

            ImGui::EndTabBar();
        }
    }

    void CRegisters_Window::Render()
    {
        // Retrieve the context of the CPU.
        static const arm1176jzf_s::CCPU_Context& cpu_context = m_cpu->Get_CPU_Context();

        // Select the appropriate tab to be displayed based on the current mode of the CPU.
        Check_If_CPU_Mode_Changes(cpu_context);

        // Render the window.
        if (ImGui::Begin("CPU Registers"))
        {
            Render_CPU_Mode(cpu_context);
            Render_Register_Modes_Tabs(cpu_context);
        }

        ImGui::End();
    }

    void CRegisters_Window::Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode mode,
                                                 const arm1176jzf_s::CCPU_Context& context)
    {
        // Render a tab bar for different value representations (HEX, DEC, ...)
        if (ImGui::BeginTabBar(fmt::format("##cpu_regs_tabs_{}_mode", static_cast<std::uint32_t>(mode)).c_str(),
                               ImGuiTabBarFlags_None))
        {
            // Hexadecimal
            if (ImGui::BeginTabItem(fmt::format("HEX##{}", static_cast<std::uint32_t>(mode)).c_str()))
            {
                /// Render all CPU registers.
                Render_Registers_Table(fmt::format("HEX##table_{}", static_cast<std::uint32_t>(mode)).c_str(),
                                       NFormat::HEX, // Format
                                       mode,         // Mode of the CPU that is being rendered (NOT the current mode)
                                       context);     // CPU context
                ImGui::EndTabItem();
            }

            // Unsigned 32 bits
            if (ImGui::BeginTabItem(fmt::format("U32##{}", static_cast<std::uint32_t>(mode)).c_str()))
            {
                // Render all CPU registers.
                Render_Registers_Table(fmt::format("U32##table_{}", static_cast<std::uint32_t>(mode)).c_str(),
                                       NFormat::U32, // Format
                                       mode,         // Mode of the CPU that is being rendered (NOT the current mode)
                                       context);     // CPU context
                ImGui::EndTabItem();
            }

            // Signed 32 bits
            if (ImGui::BeginTabItem(fmt::format("S32##{}", static_cast<std::uint32_t>(mode)).c_str()))
            {
                // Render all CPU registers.
                Render_Registers_Table(fmt::format("S32##table_{}", static_cast<std::uint32_t>(mode)).c_str(),
                                       NFormat::S32, // Format
                                       mode,         // Mode of the CPU that is being rendered (NOT the current mode)
                                       context);     // CPU context
                ImGui::EndTabItem();
            }

            ImGui::EndTabBar();
        }

        Render_CPSR_Flags(context);
    }

    void CRegisters_Window::Render_Registers_Table(const char* const title,
                                                   NFormat format,
                                                   arm1176jzf_s::CCPU_Context::NCPU_Mode mode,
                                                   const arm1176jzf_s::CCPU_Context& cpu_context)
    {
        // Render a table with all CPU registers.
        if (ImGui::BeginTable(fmt::format("##{}", title).c_str(), 2, Table_Flags))
        {
            // Table headings [Register, Value].
            ImGui::TableSetupColumn("Register", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn(fmt::format("Value##{}", title).c_str(), ImGuiTableColumnFlags_WidthStretch);
            ImGui::TableHeadersRow();

            // Render general purpose registers (0-12)
            for (std::uint32_t i = 0; i < arm1176jzf_s::CCPU_Context::Number_Of_General_Regs; ++i)
            {
                // Move on to the new row.
                ImGui::TableNextRow();
                ImGui::TableNextColumn();

                // Render the name of the register.
                ImGui::Text("%s", fmt::format("R{}", i).c_str());

                // Move on to the second column.
                ImGui::TableNextColumn();

                // Render the value of the register.
                Render_Raw_Value(cpu_context.Get_Register(i, mode), format);
            }

            // Render register R13 (LR).
            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("R13 (LR)");
            ImGui::TableNextColumn();
            Render_Raw_Value(cpu_context.Get_Register(arm1176jzf_s::CCPU_Context::LR_Reg_Idx, mode), format);
            ImGui::TableNextRow();

            // Render register R14 (SP).
            ImGui::TableNextColumn();
            ImGui::Text("R14 (SP)");
            ImGui::TableNextColumn();
            Render_Raw_Value(cpu_context.Get_Register(arm1176jzf_s::CCPU_Context::SP_Reg_Idx, mode), format);
            ImGui::TableNextRow();

            // Render register R15 (PC).
            ImGui::TableNextColumn();
            ImGui::Text("R15 (PC)");
            ImGui::TableNextColumn();
            Render_Raw_Value(cpu_context.Get_Register(arm1176jzf_s::CCPU_Context::PC_Reg_Idx, mode), format);
            ImGui::TableNextRow();

            // Render CPSR (current program status register).
            ImGui::TableNextColumn();
            ImGui::Text("CPSR");
            ImGui::TableNextColumn();
            Render_Raw_Value(cpu_context.Get_CPSR(), format);
            ImGui::TableNextRow();

            // Render SPSR (saved program status register) if the mode supports it.
            if (!cpu_context.Is_Mode_With_No_SPSR(mode))
            {
                ImGui::TableNextColumn();
                ImGui::Text("SPSR");
                ImGui::TableNextColumn();
                Render_Raw_Value(cpu_context.Get_SPSR(mode), format);
                ImGui::TableNextRow();
            }

            ImGui::EndTable();
        }
    }

    void CRegisters_Window::Render_Raw_Value(std::uint32_t value, NFormat format)
    {
        // Display the given value in the desired format.
        switch (format)
        {
            // Hexadecimal
            case NFormat::HEX:
                ImGui::Text("%08X", value);
                break;

            // Unsigned 32 bits
            case NFormat::U32:
                ImGui::Text("%u", value);
                break;

            // Signed 32 bits
            case NFormat::S32:
                ImGui::Text("%d", value);
                break;
        }
    }

    void CRegisters_Window::Render_CPSR_Flags(const arm1176jzf_s::CCPU_Context& cpu_context)
    {
        ImGui::Text("Flags in CSPR");

        // Render a table containing different flags of the CPSR register.
        if (ImGui::BeginTable("Flags", 7, Table_Flags))
        {
            // First row (table headings).
            ImGui::TableSetupColumn("N", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Z", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("C", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("V", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("A", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("I", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("F", ImGuiTableColumnFlags_WidthStretch);

            // Move on to the second row.
            ImGui::TableHeadersRow();

            // Render the flag values
            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::N)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::Z)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::C)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::V)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::A)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::I)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::F)));

            ImGui::EndTable();
        }
    }

} // namespace zero_mate::gui