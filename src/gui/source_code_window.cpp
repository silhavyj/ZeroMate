#include <imgui/imgui.h>
#include <fmt/core.h>

#include "source_code_window.hpp"

namespace zero_mate::gui
{
    CSource_Code_Window::CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                             std::vector<utils::TText_Section_Record>& source_code)
    : m_cpu{ cpu }
    , m_source_code{ source_code }
    {
    }

    void CSource_Code_Window::Render()
    {
        static const ImGuiTableFlags table_flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                   ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                   ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;
        ImGui::Begin("Source Code Disassembly");

        if (ImGui::BeginTable("##source_code_table", 4, table_flags))
        {
            ImGui::TableSetupColumn("##breakpoint", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Address", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Opcode", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Disassembly", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (const auto& [addr, opcode, disassembly] : m_source_code)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();

                 // TODO breakpoint

                ImGui::TableNextColumn();
                ImGui::Text("0x%08X", addr);
                ImGui::TableNextColumn();
                ImGui::Text("0x%08X", opcode);
                ImGui::TableNextColumn();
                ImGui::Text("%s", disassembly.c_str());

                if (addr == m_cpu->m_regs.at(m_cpu->PC_REG_IDX))
                {
                    const ImU32 cell_bg_color = ImGui::GetColorU32(ImVec4(1.0f, 1.0f, 0.0f, 0.35f));
                    ImGui::TableSetBgColor(ImGuiTableBgTarget_RowBg0, cell_bg_color);
                }
            }

            ImGui::EndTable();
        }

        ImGui::End();
    }
}