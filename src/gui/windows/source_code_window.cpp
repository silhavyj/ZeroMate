#include <functional>

#include <imgui/imgui.h>
#include <fmt/include/fmt/core.h>

#include "../../core/utils/elf_loader.hpp"

#include "source_code_window.hpp"

namespace zero_mate::gui
{
    CSource_Code_Window::CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                             std::vector<utils::elf::TText_Section_Record>& source_code,
                                             bool& scroll_to_curr_line,
                                             const bool& cpu_running)
    : m_cpu{ cpu }
    , m_source_code{ source_code }
    , m_scroll_to_curr_line{ scroll_to_curr_line }
    , m_cpu_running{ cpu_running }
    {
    }

    void CSource_Code_Window::Render()
    {
        if (ImGui::Begin("Source Code Disassembly"))
        {
            if (!m_source_code.empty())
            {
                std::size_t idx{ 0 };

                while (idx < m_source_code.size())
                {
                    Render_Code_Block(idx);
                }
            }
        }

        ImGui::End();
    }

    bool CSource_Code_Window::Highlight_Code_Block(std::size_t idx) const
    {
        for (std::size_t i = idx + 1; i < m_source_code.size(); ++i)
        {
            if (m_source_code[i].type == utils::elf::NText_Section_Record_Type::Label)
            {
                return false;
            }

            if (!m_cpu_running && m_source_code[i].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_REG_IDX])
            {
                return true;
            }
        }

        return false;
    }

    std::string CSource_Code_Window::Extract_Class_Name(std::string label)
    {
        const auto end_pos = label.find("::");

        if (end_pos == std::string::npos)
        {
            return {};
        }

        label = label.substr(0, end_pos);
        const auto start_pos = label.rfind(' ');

        if (start_pos != std::string::npos)
        {
            label = label.substr(start_pos + 1);
        }

        return label;
    }

    CSource_Code_Window::TRGB_Color CSource_Code_Window::Pick_Color(const std::string& str)
    {
        const std::size_t hash_value = std::hash<std::string>()(str) % 0xFFFFFFU;

        return {
            static_cast<float>((hash_value & 0xFF0000U) >> 16U) / 255.0f,
            static_cast<float>((hash_value & 0x00FF00U) >> 8U) / 255.0f,
            static_cast<float>(hash_value & 0x0000FFU) / 255.0f
        };
    }

    void CSource_Code_Window::Render_Code_Block(std::size_t& idx)
    {
        assert(m_source_code[idx].type == utils::elf::NText_Section_Record_Type::Label);

        const bool highlight_code_block = Highlight_Code_Block(idx);
        const auto class_name = Extract_Class_Name(m_source_code[idx].disassembly);
        const bool is_class_member = !class_name.empty();

        if (highlight_code_block)
        {
            ImGui::PushStyleColor(ImGuiCol_Header, ImVec4(1.0f, 1.0f, 0.0f, 0.3f));
            ImGui::PushStyleColor(ImGuiCol_HeaderHovered, ImVec4(1.0f, 1.0f, 0.0f, 0.5f));
        }
        else if (is_class_member)
        {
            const auto color = Pick_Color(class_name);

            ImGui::PushStyleColor(ImGuiCol_Header, ImVec4(color.r, color.g, color.b, 0.3f));
            ImGui::PushStyleColor(ImGuiCol_HeaderHovered, ImVec4(color.r, color.g, color.b, 0.5f));
        }

        if (ImGui::CollapsingHeader(m_source_code[idx].disassembly.c_str()))
        {
            if (highlight_code_block || is_class_member)
            {
                ImGui::PopStyleColor(2);
            }
            if (ImGui::BeginTable(fmt::format("##source_code_table{}", m_source_code[idx].disassembly).c_str(), 4, TABLE_FLAGS))
            {
                ImGui::TableSetupColumn(fmt::format("##breakpoint{}", m_source_code[idx].disassembly).c_str(), ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn(fmt::format("Address##{}", m_source_code[idx].disassembly).c_str(), ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn(fmt::format("Opcode##{}", m_source_code[idx].disassembly).c_str(), ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn(fmt::format("Disassembly##{}", m_source_code[idx].disassembly).c_str(), ImGuiTableColumnFlags_WidthStretch);

                ImGui::TableHeadersRow();

                ++idx;
                while (idx != m_source_code.size())
                {
                    ImGui::TableNextRow();
                    ImGui::TableNextColumn();

                    if (m_source_code[idx].type == utils::elf::NText_Section_Record_Type::Label)
                    {
                        break;
                    }

                    ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(1.f, 0.f, 0.f, 1.f));
                    if (ImGui::RadioButton(fmt::format("##{}", m_source_code[idx].addr).c_str(), m_breakpoints[m_source_code[idx].addr]) && !m_cpu_running)
                    {
                        m_breakpoints[m_source_code[idx].addr] = !m_breakpoints[m_source_code[idx].addr];
                        if (m_breakpoints[m_source_code[idx].addr])
                        {
                            m_cpu->Add_Breakpoint(m_source_code[idx].addr);
                        }
                        else
                        {
                            m_cpu->Remove_Breakpoint(m_source_code[idx].addr);
                        }
                    }
                    ImGui::PopStyleColor();

                    ImGui::TableNextColumn();

                    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.f, 1.f, 1.f, 0.65f));
                    ImGui::Text("0x%08X", m_source_code[idx].addr);
                    ImGui::PopStyleColor();

                    ImGui::TableNextColumn();
                    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 0.65f));
                    ImGui::Text("0x%08X", m_source_code[idx].opcode);
                    ImGui::PopStyleColor();

                    ImGui::TableNextColumn();

                    if (m_source_code[idx].disassembly == utils::elf::UNKNOWN_INSTRUCTION_STR)
                    {
                        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 0.85f));
                        ImGui::Text("%s", m_source_code[idx].disassembly.c_str());
                        ImGui::PopStyleColor();
                    }
                    else
                    {
                        ImGui::Text("%s", m_source_code[idx].disassembly.c_str());
                    }

                    if (!m_cpu_running && m_source_code[idx].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_REG_IDX])
                    {
                        const ImU32 cell_bg_color = ImGui::GetColorU32(ImVec4(1.0f, 1.0f, 0.0f, 0.3f));
                        ImGui::TableSetBgColor(ImGuiTableBgTarget_RowBg0, cell_bg_color);

                        if (m_scroll_to_curr_line && !ImGui::IsItemVisible())
                        {
                            ImGui::SetScrollHereY(0.2f);
                            m_scroll_to_curr_line = false;
                        }
                    }

                    ++idx;
                }

                ImGui::EndTable();
            }
        }
        else
        {
            if (highlight_code_block || is_class_member)
            {
                ImGui::PopStyleColor(2);
            }
            ++idx;

            while (idx < m_source_code.size())
            {
                if (m_source_code[idx].type == utils::elf::NText_Section_Record_Type::Label)
                {
                    break;
                }

                if (!m_cpu_running && m_source_code[idx].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_REG_IDX])
                {
                    if (m_scroll_to_curr_line && !ImGui::IsItemVisible())
                    {
                        ImGui::SetScrollHereY(0.2f);
                        m_scroll_to_curr_line = false;
                    }
                }

                ++idx;
            }
        }
    }
}