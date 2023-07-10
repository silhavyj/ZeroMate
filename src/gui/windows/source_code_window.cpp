// ---------------------------------------------------------------------------------------------------------------------
/// \file source_code_window.cpp
/// \date 09. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that displays loaded ELF files (disassembled instructions of the source code).
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party library includes

#include "fmt/format.h"

// Project file imports

#include "../../utils/elf_loader.hpp"
#include "source_code_window.hpp"

namespace zero_mate::gui
{
    CSource_Code_Window::CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                             utils::elf::Source_Codes_t& source_codes,
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
        // Render the window.
        if (ImGui::Begin("Source Code Disassembly"))
        {
            Render_Source_Codes();
        }

        ImGui::End();

        // Remove any tabs the user may have closed (user processes).
        Remove_Closed_Tabs();
    }

    void CSource_Code_Window::Remove_Closed_Tabs()
    {
        // Temporary collection (map keys to be deleted).
        std::vector<std::string> tabs_to_delete;

        // Go over all loaded ELF files (tabs).
        for (const auto& [filename, source_code] : m_source_codes)
        {
            // Check if the tab has been closed.
            if (!m_open_tabs.at(filename))
            {
                tabs_to_delete.push_back(filename);
            }
        }

        // Remove the source code from the collection of all loaded ELF files.
        for (const auto& filename : tabs_to_delete)
        {
            m_source_codes.erase(filename);
            m_open_tabs.erase(filename);
        }
    }

    void CSource_Code_Window::Render_Source_Codes()
    {
        // Render a tab bar.
        if (ImGui::BeginTabBar("##source_codes"))
        {
            // Every ELF file represents a single tab.
            for (const auto& [filename, source_code] : m_source_codes)
            {
                // Render the tab (source ELF file).
                Render_Tab(filename, m_source_codes.at(filename));
            }

            ImGui::EndTabBar();
        }
    }

    void CSource_Code_Window::Render_Tab(const std::string& filename, const utils::elf::TSource_Code& source_code)
    {
        // Each tab is initially open until the user decides to close it. After that,
        // it gets irreversibly erased from the collection of all tabs.
        if (!m_open_tabs.contains(filename))
        {
            m_open_tabs[filename] = true; // The tab is open
        }

        // Color the kernel tab a special color, so it is easy to spot.
        if (source_code.is_kernel)
        {
            ImGui::PushStyleColor(ImGuiCol_TabHovered, color::Dark_Gray_1);
            ImGui::PushStyleColor(ImGuiCol_TabActive, color::Dark_Gray_1);
            ImGui::PushStyleColor(ImGuiCol_Tab, color::Dark_Gray_2);
        }

        // Render the tab
        if (ImGui::BeginTabItem(filename.c_str(), source_code.is_kernel ? nullptr : &m_open_tabs[filename]))
        {
            // Render the whole source code block by block.
            if (!source_code.code.empty())
            {
                // Index of the current instruction (current line).
                std::size_t idx{ 0 };

                // Render another block of instructions (function/method).
                while (idx < source_code.code.size())
                {
                    Render_Code_Block(source_code, idx);
                }
            }

            ImGui::EndTabItem();
        }

        // Do not forget to pop out the colors of the kernel tab.
        if (source_code.is_kernel)
        {
            ImGui::PopStyleColor(3);
        }
    }

    bool CSource_Code_Window::Should_Code_Block_Be_Highlighted(const utils::elf::TSource_Code& source_code,
                                                               std::size_t idx) const
    {
        // Iterate over all instruction of a block of code (e.g. a function).
        for (std::size_t i = idx + 1; i < source_code.code.size(); ++i)
        {
            // We reached the end of the function (another label starts here).
            if (source_code.code[i].type == utils::elf::NText_Section_Record_Type::Label)
            {
                return false;
            }

            // Is the PC register - current instruction somewhere in the body of the function?
            if (!m_cpu_running &&
                source_code.code[i].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx])
            {
                return true; // This block of code should be highlighted
            }
        }

        return false;
    }

    std::string CSource_Code_Window::Extract_Class_Name(std::string label)
    {
        // The class name (namespace) ends with "::"
        const auto end_pos = label.find("::");

        // The function is not part of any class (e.g. a global function)
        // They will all have the same color.
        if (end_pos == std::string::npos)
        {
            return {};
        }

        // Find the beginning of the class name (space character)
        label = label.substr(0, end_pos);
        const auto start_pos = label.rfind(' ');

        // Extract the class name.
        if (start_pos != std::string::npos)
        {
            label = label.substr(start_pos + 1);
        }

        return label;
    }

    void CSource_Code_Window::Render_Table_Body(const utils::elf::TSource_Code& source_code, std::size_t& idx)
    {
        // Keep over the instruction
        while (idx != source_code.code.size())
        {
            // Move on to the next row (next instruction).
            ImGui::TableNextRow();
            ImGui::TableNextColumn();

            // Have we reached the beginning of the next function?
            if (source_code.code[idx].type == utils::elf::NText_Section_Record_Type::Label)
            {
                break; // Bail here (the instruction falls under the next block).
            }

            // Render a breakpoint and move on to the next column.
            Render_Breakpoint(source_code, idx);
            ImGui::TableNextColumn();

            // Render an instruction address and move on to the next column.
            ImGui::PushStyleColor(ImGuiCol_Text, color::Gray);
            ImGui::Text("0x%08X", source_code.code[idx].addr);
            ImGui::PopStyleColor();
            ImGui::TableNextColumn();

            // Render an instruction opcode and move on to the next column.
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(color::Gray));
            ImGui::Text("0x%08X", source_code.code[idx].opcode);
            ImGui::PopStyleColor();
            ImGui::TableNextColumn();

            // Render the instruction disassembly.
            if (source_code.code[idx].disassembly == utils::elf::Unknown_Instruction_Str)
            {
                // Unknown instruction (failed to disassemble).
                ImGui::PushStyleColor(ImGuiCol_Text, color::Dark_Red);
                ImGui::Text("%s", source_code.code[idx].disassembly.c_str());
                ImGui::PopStyleColor();
            }
            else
            {
                ImGui::Text("%s", source_code.code[idx].disassembly.c_str());
            }

            // Has the CPU stopped?
            if (!m_cpu_running &&
                source_code.code[idx].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx])
            {
                // Color the current line.
                const ImU32 cell_bg_color = ImGui::GetColorU32(color::Transparent_Yellow_1);
                ImGui::TableSetBgColor(ImGuiTableBgTarget_RowBg0, cell_bg_color);

                // Is the line visible to the user? If not scroll down/up to it.
                if (m_scroll_to_curr_line && !ImGui::IsItemVisible())
                {
                    ImGui::SetScrollHereY(0.2F);

                    // The issue of not seeing the line has been solved.
                    m_scroll_to_curr_line = false;
                }
            }

            // Move on to the next row (next instruction).
            ++idx;
        }
    }

    void CSource_Code_Window::Render_Breakpoint(const utils::elf::TSource_Code& source_code, std::size_t& idx)
    {
        // Breakpoint color.
        ImGui::PushStyleColor(ImGuiCol_CheckMark, color::Red);

        // clang-format off
        if (ImGui::RadioButton(fmt::format("##{}", source_code.code[idx].addr).c_str(),
                               m_breakpoints[source_code.code[idx].addr]) && !m_cpu_running)
        {
            // Switch the state of the breakpoint.
            m_breakpoints[source_code.code[idx].addr] = !m_breakpoints[source_code.code[idx].addr];

            // If the breakpoint is active.
            if (m_breakpoints[source_code.code[idx].addr])
            {
                // Add the breakpoint to the CPU.
                m_cpu->Add_Breakpoint(source_code.code[idx].addr);
            }
            else
            {
                // Remove the breakpoint from the CPU.
                m_cpu->Remove_Breakpoint(source_code.code[idx].addr);
            }
        }
        // clang-format on

        // Do not forget to pop out the color.
        ImGui::PopStyleColor();
    }

    void CSource_Code_Window::Render_Table_Headings(const utils::elf::TSource_Code& source_code, std::size_t& idx)
    {
        // Breakpoint column
        ImGui::TableSetupColumn(fmt::format("##breakpoint{}", source_code.code[idx].disassembly).c_str(),
                                ImGuiTableColumnFlags_WidthFixed);

        // Address column
        ImGui::TableSetupColumn(fmt::format("Address##{}", source_code.code[idx].disassembly).c_str(),
                                ImGuiTableColumnFlags_WidthFixed);

        // Opcode column
        ImGui::TableSetupColumn(fmt::format("Opcode##{}", source_code.code[idx].disassembly).c_str(),
                                ImGuiTableColumnFlags_WidthFixed);

        // Disassembly column
        ImGui::TableSetupColumn(fmt::format("Disassembly##{}", source_code.code[idx].disassembly).c_str(),
                                ImGuiTableColumnFlags_WidthStretch);

        ImGui::TableHeadersRow();
    }

    void CSource_Code_Window::Render_Code_Table(const utils::elf::TSource_Code& source_code, std::size_t& idx)
    {
        // Render a table.
        if (ImGui::BeginTable(fmt::format("##source_code_table{}", source_code.code[idx].disassembly).c_str(),
                              4,
                              Table_Flags))
        {
            // Render the headings.
            Render_Table_Headings(source_code, idx);

            // Skip the label (the name of the function).
            ++idx;

            // Render the body of the table.
            Render_Table_Body(source_code, idx);

            ImGui::EndTable();
        }
    }

    void CSource_Code_Window::Skip_Collapsed_Block(const utils::elf::TSource_Code& source_code, std::size_t& idx)
    {
        // Keep iterating over the instructions until you reach another function (another label).
        while (idx < source_code.code.size())
        {
            // Have we reached the beginning of another function?
            if (source_code.code[idx].type == utils::elf::NText_Section_Record_Type::Label)
            {
                break;
            }

            // Has the execution stop?.
            if (!m_cpu_running &&
                source_code.code[idx].addr == m_cpu->Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx])
            {
                // Is the block visible to the user?
                if (m_scroll_to_curr_line && !ImGui::IsItemVisible())
                {
                    // If not, scroll to it, so they can see it.
                    ImGui::SetScrollHereY(0.2F);

                    // The issue of not seeing the line has been solved.
                    m_scroll_to_curr_line = false;
                }
            }

            // Move on to the next instruction.
            ++idx;
        }
    }

    void CSource_Code_Window::Render_Code_Block(const utils::elf::TSource_Code& source_code, std::size_t& idx)
    {
        // Make sure the block starts with a label (name of the function).
        assert(source_code.code[idx].type == utils::elf::NText_Section_Record_Type::Label);

        // Should the block be highlighted?
        const bool highlight_code_block = Should_Code_Block_Be_Highlighted(source_code, idx);

        // Get the name of the class the function is associated with
        const auto class_name = Extract_Class_Name(source_code.code[idx].disassembly);

        // Is the function a class member?
        const bool is_class_member = !class_name.empty();

        // Highlight the block it contains the currently executed instruction.
        if (highlight_code_block)
        {
            ImGui::PushStyleColor(ImGuiCol_Header, color::Transparent_Yellow_1);
            ImGui::PushStyleColor(ImGuiCol_HeaderHovered, color::Transparent_Yellow_2);
        }
        else if (is_class_member)
        {
            // Get the color based on the hash of the class name.
            const auto color = color::Assign_Color_From_Hash(class_name);

            ImGui::PushStyleColor(ImGuiCol_Header, ImVec4(color.r, color.g, color.b, 0.3F));
            ImGui::PushStyleColor(ImGuiCol_HeaderHovered, ImVec4(color.r, color.g, color.b, 0.5F));
        }

        // clang-format off
        if (ImGui::CollapsingHeader(fmt::format("{}##{}",
                                                source_code.code[idx].disassembly,
                                                source_code.code[idx].index).c_str()))
        {
            // Have we pushed any custom colors?
            if (highlight_code_block || is_class_member)
            {
                ImGui::PopStyleColor(2);
            }

            // Render the table (source code).
            Render_Code_Table(source_code, idx);
        }
        else
        {
            // Have we pushed any custom colors?
            if (highlight_code_block || is_class_member)
            {
                ImGui::PopStyleColor(2);
            }

            // Skip the label (name of the function).
            ++idx;

            // Skip the block of code as well since it is collapsed.
            Skip_Collapsed_Block(source_code, idx);
        }
        // clang-format on
    }

} // namespace zero_mate::gui