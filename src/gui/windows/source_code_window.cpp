#include <imgui/imgui.h>
#include <fmt/include/fmt/core.h>

#include "../../core/utils/elf_loader.hpp"

#include "source_code_window.hpp"

namespace zero_mate::gui
{
    CSource_Code_Window::CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                             std::vector<utils::elf::TText_Section_Record>& source_code)
    : m_cpu{ cpu }
    , m_source_code{ source_code }
    {
    }

    void CSource_Code_Window::Render()
    {
        if (ImGui::Begin("Source Code Disassembly"))
        {
            if (ImGui::BeginTable("##source_code_table", 4, TABLE_FLAGS))
            {
                ImGui::TableSetupColumn("##breakpoint", ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn("Address", ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn("Opcode", ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn("Disassembly", ImGuiTableColumnFlags_WidthStretch);

                ImGui::TableHeadersRow();

                for (const auto& [type, addr, opcode, disassembly] : m_source_code)
                {
                    ImGui::TableNextRow();
                    ImGui::TableNextColumn();

                    switch (type)
                    {
                        case utils::elf::NText_Section_Record_Type::Instruction:
                            ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(1.f, 0.f, 0.f, 1.f));
                            if (ImGui::RadioButton(fmt::format("##{}", addr).c_str(), m_breakpoints[addr]))
                            {
                                m_breakpoints[addr] = !m_breakpoints[addr];
                                if (m_breakpoints[addr])
                                {
                                    m_cpu->Add_Breakpoint(addr);
                                }
                                else
                                {
                                    m_cpu->Remove_Breakpoint(addr);
                                }
                            }
                            ImGui::PopStyleColor();

                            ImGui::TableNextColumn();

                            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.f, 1.f, 1.f, 0.65f));
                            ImGui::Text("0x%08X", addr);
                            ImGui::PopStyleColor();

                            ImGui::TableNextColumn();
                            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 0.65f));
                            ImGui::Text("0x%08X", opcode);
                            ImGui::PopStyleColor();

                            ImGui::TableNextColumn();

                            if (disassembly == utils::elf::UNKNOWN_INSTRUCTION_STR)
                            {
                                ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 0.85f));
                                ImGui::Text("%s", disassembly.c_str());
                                ImGui::PopStyleColor();

                            }
                            else
                            {
                                ImGui::Text("%s", disassembly.c_str());
                            }

                            if (addr == m_cpu->m_regs[arm1176jzf_s::CCPU_Core::PC_REG_IDX])
                            {
                                const ImU32 cell_bg_color = ImGui::GetColorU32(ImVec4(1.0f, 1.0f, 0.0f, 0.3f));
                                ImGui::TableSetBgColor(ImGuiTableBgTarget_RowBg0, cell_bg_color);
                            }
                            break;

                        case utils::elf::NText_Section_Record_Type::Label:
                            ImGui::TableNextRow();
                            ImGui::TableNextColumn();
                            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 0.0f));
                            ImGui::Text("|");
                            ImGui::PopStyleColor();

                            ImGui::TableNextRow();
                            ImGui::TableSetColumnIndex(2);
                            ImGui::Text("%s", disassembly.c_str());
                            const ImU32 cell_bg_color = ImGui::GetColorU32(ImVec4(0.11f, 0.18f, 0.29f, 1.0f));
                            ImGui::TableSetBgColor(ImGuiTableBgTarget_RowBg0, cell_bg_color);
                            break;
                    }
                }

                ImGui::EndTable();
            }
        }

        ImGui::End();
    }
}