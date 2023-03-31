#include <fmt/include/fmt/core.h>

#include "registers_window.hpp"

namespace zero_mate::gui
{
    CRegisters_Window::CRegisters_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu)
    : m_cpu{ cpu }
    {
    }

    void CRegisters_Window::Render()
    {
        ImGui::Begin("CPU Registers");

        if (ImGui::BeginTabBar("##cpu_regs_tabs", ImGuiTabBarFlags_None))
        {
            if (ImGui::BeginTabItem("HEX"))
            {
                Render_Registers_Table("HEX", "Value", "%08X");
                ImGui::EndTabItem();
            }

            if (ImGui::BeginTabItem("U32"))
            {
                Render_Registers_Table("U32", "Value", "%u");
                ImGui::EndTabItem();
            }

            if (ImGui::BeginTabItem("S32"))
            {
                Render_Registers_Table("S32", "Value", "%d");
                ImGui::EndTabItem();
            }

            ImGui::EndTabBar();
        }

        Render_Flags();

        ImGui::End();
    }

    void CRegisters_Window::Render_Registers_Table(const char* const title, const char* const type, const char* const format)
    {
        if (ImGui::BeginTable(fmt::format("##{}", title).c_str(), 2, TABLE_FLAGS))
        {
            ImGui::TableSetupColumn("Register", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn(fmt::format("{}##{}", type, title).c_str(), ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (std::uint32_t i = 0; i < arm1176jzf_s::CCPU_Core::NUMBER_OF_GENERAL_REGS; ++i)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();
                ImGui::Text("%s", fmt::format("R{}", i).c_str());
                ImGui::TableNextColumn();
                ImGui::InputScalar(fmt::format("##{}{}", i, title).c_str(), ImGuiDataType_U32, &m_cpu->m_regs.at(i), nullptr, nullptr, format);
            }

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("R13 (LR)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##LR{}", title).c_str(), ImGuiDataType_U32, &m_cpu->m_regs.at(arm1176jzf_s::CCPU_Core::LR_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R14 (SP)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##SP{}", title).c_str(), ImGuiDataType_U32, &m_cpu->m_regs.at(arm1176jzf_s::CCPU_Core::SP_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R15 (PC)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##PC{}", title).c_str(), ImGuiDataType_U32, &m_cpu->m_regs.at(arm1176jzf_s::CCPU_Core::PC_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::EndTable();
        }
    }

    void CRegisters_Window::Render_Flags()
    {
        ImGui::Text("Flags in CSPR");

        if (ImGui::BeginTable("Flags", 4, TABLE_FLAGS))
        {
            ImGui::TableSetupColumn("N", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Z", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("C", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("V", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("%d", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::N));
            ImGui::TableNextColumn();
            ImGui::Text("%d", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::Z));
            ImGui::TableNextColumn();
            ImGui::Text("%d", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::C));
            ImGui::TableNextColumn();
            ImGui::Text("%d", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::V));

            ImGui::EndTable();
        }
    }
}