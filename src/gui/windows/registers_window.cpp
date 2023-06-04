#include <magic_enum.hpp>
#include <fmt/include/fmt/core.h>

#include "registers_window.hpp"

namespace zero_mate::gui
{
    CRegisters_Window::CRegisters_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu, const bool& cpu_running)
    : m_cpu{ cpu }
    , m_cpu_context{ cpu->Get_CPU_Context() }
    , m_cpu_running{ cpu_running }
    {
    }

    void CRegisters_Window::Render()
    {
        if (!m_cpu_running && m_cpu_context[arm1176jzf_s::CCPU_Context::PC_REG_IDX] != m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_REG_IDX])
        {
            m_cpu_context = m_cpu->Get_CPU_Context();
        }

        static bool first_time{ true };
        static auto cpu_state_prev = m_cpu_context.Get_CPU_Mode();
        const auto cpu_state = m_cpu_context.Get_CPU_Mode();

        static ImGuiTableFlags usr_sys_tab_open = ImGuiTabItemFlags_None;
        static ImGuiTableFlags fiq_tab_open = ImGuiTabItemFlags_None;
        static ImGuiTableFlags svc_tab_open = ImGuiTabItemFlags_None;
        static ImGuiTableFlags abt_tab_open = ImGuiTabItemFlags_None;
        static ImGuiTableFlags irq_tab_open = ImGuiTabItemFlags_None;
        static ImGuiTableFlags und_tab_open = ImGuiTabItemFlags_None;

        if (cpu_state != cpu_state_prev || first_time)
        {
            switch (cpu_state)
            {
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::FIQ:
                    fiq_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                case arm1176jzf_s::CCPU_Context::NCPU_Mode::IRQ:
                    irq_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                case arm1176jzf_s::CCPU_Context::NCPU_Mode::Supervisor:
                    svc_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                case arm1176jzf_s::CCPU_Context::NCPU_Mode::Abort:
                    abt_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                case arm1176jzf_s::CCPU_Context::NCPU_Mode::Undefined:
                    und_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;

                case arm1176jzf_s::CCPU_Context::NCPU_Mode::User:
                    [[fallthrough]];
                case arm1176jzf_s::CCPU_Context::NCPU_Mode::System:
                    usr_sys_tab_open = ImGuiTabItemFlags_SetSelected;
                    break;
            }

            first_time = false;
            cpu_state_prev = cpu_state;
        }

        if (ImGui::Begin("CPU Registers"))
        {
            ImGui::Text("CPU Mode: %s", fmt::format("{}", magic_enum::enum_name(cpu_state)).c_str());
            ImGui::Separator();

            if (ImGui::BeginTabBar("##cpu_regs_tabs"))
            {
                if (ImGui::BeginTabItem("USR/SYS", nullptr, usr_sys_tab_open))
                {
                    usr_sys_tab_open = ImGuiTabItemFlags_None;
                    Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::User);
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("FIQ", nullptr, fiq_tab_open))
                {
                    fiq_tab_open = ImGuiTabItemFlags_None;
                    Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::FIQ);
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("SVC", nullptr, svc_tab_open))
                {
                    svc_tab_open = ImGuiTabItemFlags_None;
                    Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::Supervisor);
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("ABT", nullptr, abt_tab_open))
                {
                    abt_tab_open = ImGuiTabItemFlags_None;
                    Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::Abort);
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("IRQ", nullptr, irq_tab_open))
                {
                    irq_tab_open = ImGuiTabItemFlags_None;
                    Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::IRQ);
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("UDN", nullptr, und_tab_open))
                {
                    und_tab_open = ImGuiTabItemFlags_None;
                    Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode::Undefined);
                    ImGui::EndTabItem();
                }

                ImGui::EndTabBar();
            }
        }

        ImGui::End();
    }

    void CRegisters_Window::Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode mode)
    {
        if (ImGui::BeginTabBar(fmt::format("##cpu_regs_tabs_{}_mode", static_cast<std::uint32_t>(mode)).c_str(), ImGuiTabBarFlags_None))
        {
            if (ImGui::BeginTabItem(fmt::format("HEX##{}", static_cast<std::uint32_t>(mode)).c_str()))
            {
                Render_Registers_Table(fmt::format("HEX##table_{}", static_cast<std::uint32_t>(mode)).c_str(), "Value", NFormat::HEX, mode);
                ImGui::EndTabItem();
            }

            if (ImGui::BeginTabItem(fmt::format("U32##{}", static_cast<std::uint32_t>(mode)).c_str()))
            {
                Render_Registers_Table(fmt::format("U32##table_{}", static_cast<std::uint32_t>(mode)).c_str(), "Value", NFormat::U32, mode);
                ImGui::EndTabItem();
            }

            if (ImGui::BeginTabItem(fmt::format("S32##{}", static_cast<std::uint32_t>(mode)).c_str()))
            {
                Render_Registers_Table(fmt::format("S32##table_{}", static_cast<std::uint32_t>(mode)).c_str(), "Value", NFormat::S32, mode);
                ImGui::EndTabItem();
            }

            ImGui::EndTabBar();
        }

        Render_Flags();
    }

    void CRegisters_Window::Render_Registers_Table(const char* const title, const char* const type, NFormat format, arm1176jzf_s::CCPU_Context::NCPU_Mode mode)
    {
        if (ImGui::BeginTable(fmt::format("##{}", title).c_str(), 2, TABLE_FLAGS))
        {
            ImGui::TableSetupColumn("Register", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn(fmt::format("{}##{}", type, title).c_str(), ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (std::uint32_t i = 0; i < arm1176jzf_s::CCPU_Context::NUMBER_OF_GENERAL_REGS; ++i)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();
                ImGui::Text("%s", fmt::format("R{}", i).c_str());
                ImGui::TableNextColumn();
                Render_Value(m_cpu_context.Get_Register(i, mode), format);
            }

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("R13 (LR)");
            ImGui::TableNextColumn();
            Render_Value(m_cpu_context.Get_Register(arm1176jzf_s::CCPU_Context::LR_REG_IDX, mode), format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R14 (SP)");
            ImGui::TableNextColumn();
            Render_Value(m_cpu_context.Get_Register(arm1176jzf_s::CCPU_Context::SP_REG_IDX, mode), format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R15 (PC)");
            ImGui::TableNextColumn();
            Render_Value(m_cpu_context.Get_Register(arm1176jzf_s::CCPU_Context::PC_REG_IDX, mode), format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("CPSR");
            ImGui::TableNextColumn();
            Render_Value(m_cpu_context.Get_CPSR(), format);
            ImGui::TableNextRow();

            if (!m_cpu_context.Is_Mode_With_No_SPSR(mode))
            {
                ImGui::TableNextColumn();
                ImGui::Text("SPSR");
                ImGui::TableNextColumn();
                Render_Value(m_cpu_context.Get_SPSR(mode), format);
                ImGui::TableNextRow();
            }

            ImGui::EndTable();
        }
    }

    void CRegisters_Window::Render_Value(std::uint32_t value, NFormat format)
    {
        switch (format)
        {
            case NFormat::HEX:
                ImGui::Text("%08X", value);
                break;

            case NFormat::U32:
                ImGui::Text("%u", value);
                break;

            case NFormat::S32:
                ImGui::Text("%d", value);
                break;
        }
    }

    void CRegisters_Window::Render_Flags()
    {
        ImGui::Text("Flags in CSPR");

        if (ImGui::BeginTable("Flags", 7, TABLE_FLAGS))
        {
            ImGui::TableSetupColumn("N", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Z", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("C", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("V", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("A", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("I", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("F", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::N)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::Z)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::C)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::V)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::A)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::I)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::F)));

            ImGui::EndTable();
        }
    }
}