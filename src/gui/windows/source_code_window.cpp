#include <functional>

#include <imgui/imgui.h>
#include <fmt/include/fmt/core.h>

#include "../../utils/elf_loader.hpp"

#include "source_code_window.hpp"

namespace zero_mate::gui
{
    CSource_Code_Window::CSource_Code_Window(
    std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
    std::unordered_map<std::string, std::vector<utils::elf::TText_Section_Record>>& source_codes,
    bool& scroll_to_curr_line,
    const bool& cpu_running)
    : m_cpu{ cpu }
    , m_source_codes{ source_codes }
    , m_scroll_to_curr_line{ scroll_to_curr_line }
    , m_cpu_running{ cpu_running }
    {
    }

    void CSource_Code_Window::Render()
    {
        if (ImGui::Begin("Source Code Disassembly"))
        {
            if (ImGui::BeginTabBar("##source_codes"))
            {
                for (const auto& [filename, source_code] : m_source_codes)
                {
                    if (!m_open_tabs.contains(filename))
                    {
                        m_open_tabs[filename] = true;
                    }

                    if (ImGui::BeginTabItem(filename.c_str(), &m_open_tabs[filename]))
                    {
                        if (!source_code.empty())
                        {
                            std::size_t idx{ 0 };

                            while (idx < source_code.size())
                            {
                                Render_Code_Block(source_code, idx);
                            }
                        }

                        ImGui::EndTabItem();
                    }
                }

                ImGui::EndTabBar();
            }
        }

        ImGui::End();

        std::vector<std::string> tabs_to_delete;

        for (const auto& [filename, source_code] : m_source_codes)
        {
            if (!m_open_tabs.at(filename))
            {
                tabs_to_delete.push_back(filename);
            }
        }

        for (const auto& filename : tabs_to_delete)
        {
            m_source_codes.erase(filename);
            m_open_tabs.erase(filename);
        }
    }

    bool CSource_Code_Window::Highlight_Code_Block(const std::vector<utils::elf::TText_Section_Record>& source_code,
                                                   std::size_t idx) const
    {
        for (std::size_t i = idx + 1; i < source_code.size(); ++i)
        {
            if (source_code[i].type == utils::elf::NText_Section_Record_Type::Label)
            {
                return false;
            }

            if (!m_cpu_running &&
                source_code[i].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx])
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

        return { static_cast<float>((hash_value & 0xFF0000U) >> 16U) / 255.0f,
                 static_cast<float>((hash_value & 0x00FF00U) >> 8U) / 255.0f,
                 static_cast<float>(hash_value & 0x0000FFU) / 255.0f };
    }

    void CSource_Code_Window::Render_Code_Block(const std::vector<utils::elf::TText_Section_Record>& source_code,
                                                std::size_t& idx)
    {
        assert(source_code[idx].type == utils::elf::NText_Section_Record_Type::Label);

        const bool highlight_code_block = Highlight_Code_Block(source_code, idx);
        const auto class_name = Extract_Class_Name(source_code[idx].disassembly);
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

        if (ImGui::CollapsingHeader(
            fmt::format("{}##{}", source_code[idx].disassembly, source_code[idx].index).c_str()))
        {
            if (highlight_code_block || is_class_member)
            {
                ImGui::PopStyleColor(2);
            }
            if (ImGui::BeginTable(fmt::format("##source_code_table{}", source_code[idx].disassembly).c_str(),
                                  4,
                                  Table_Flags))
            {
                ImGui::TableSetupColumn(fmt::format("##breakpoint{}", source_code[idx].disassembly).c_str(),
                                        ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn(fmt::format("Address##{}", source_code[idx].disassembly).c_str(),
                                        ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn(fmt::format("Opcode##{}", source_code[idx].disassembly).c_str(),
                                        ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn(fmt::format("Disassembly##{}", source_code[idx].disassembly).c_str(),
                                        ImGuiTableColumnFlags_WidthStretch);

                ImGui::TableHeadersRow();

                ++idx;
                while (idx != source_code.size())
                {
                    ImGui::TableNextRow();
                    ImGui::TableNextColumn();

                    if (source_code[idx].type == utils::elf::NText_Section_Record_Type::Label)
                    {
                        break;
                    }

                    ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(1.f, 0.f, 0.f, 1.f));
                    if (ImGui::RadioButton(fmt::format("##{}", source_code[idx].addr).c_str(),
                                           m_breakpoints[source_code[idx].addr]) &&
                        !m_cpu_running)
                    {
                        m_breakpoints[source_code[idx].addr] = !m_breakpoints[source_code[idx].addr];
                        if (m_breakpoints[source_code[idx].addr])
                        {
                            m_cpu->Add_Breakpoint(source_code[idx].addr);
                        }
                        else
                        {
                            m_cpu->Remove_Breakpoint(source_code[idx].addr);
                        }
                    }
                    ImGui::PopStyleColor();

                    ImGui::TableNextColumn();

                    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.f, 1.f, 1.f, 0.65f));
                    ImGui::Text("0x%08X", source_code[idx].addr);
                    ImGui::PopStyleColor();

                    ImGui::TableNextColumn();
                    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 0.65f));
                    ImGui::Text("0x%08X", source_code[idx].opcode);
                    ImGui::PopStyleColor();

                    ImGui::TableNextColumn();

                    if (source_code[idx].disassembly == utils::elf::Unknown_Instruction_Str)
                    {
                        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 0.85f));
                        ImGui::Text("%s", source_code[idx].disassembly.c_str());
                        ImGui::PopStyleColor();
                    }
                    else
                    {
                        ImGui::Text("%s", source_code[idx].disassembly.c_str());
                    }

                    if (!m_cpu_running &&
                        source_code[idx].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx])
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

            while (idx < source_code.size())
            {
                if (source_code[idx].type == utils::elf::NText_Section_Record_Type::Label)
                {
                    break;
                }

                if (!m_cpu_running &&
                    source_code[idx].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx])
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