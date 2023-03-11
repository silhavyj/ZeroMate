#include <imgui/imgui.h>
#include <fmt/core.h>

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

        ImGui::Text("%s", fmt::format("N = {}", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::N)).c_str());
        ImGui::Text("%s", fmt::format("Z = {}", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::Z)).c_str());
        ImGui::Text("%s", fmt::format("C = {}", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::C)).c_str());
        ImGui::Text("%s", fmt::format("V = {}", m_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::V)).c_str());

        ImGui::End();
    }

    void CRegisters_Window::Render_Registers_Table(const char* const title, const char* const type, const char* const format)
    {
        static const ImGuiTableFlags table_flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                   ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                   ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        if (ImGui::BeginTable(fmt::format("##{}", title).c_str(), 2, table_flags))
        {
            ImGui::TableSetupColumn("Register", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn(fmt::format("{}##{}", type, title).c_str(), ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (std::uint32_t i = 0; i < m_cpu->NUMBER_OF_GENERAL_REGS; ++i)
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
            ImGui::InputScalar(fmt::format("##LR{}", title).c_str(), ImGuiDataType_U32, &m_cpu->m_regs.at(m_cpu->LR_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R14 (SP)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##SP{}", title).c_str(), ImGuiDataType_U32, &m_cpu->m_regs.at(m_cpu->SP_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R15 (PC)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##PC{}", title).c_str(), ImGuiDataType_U32, &m_cpu->m_regs.at(m_cpu->PC_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::EndTable();
        }
    }
}