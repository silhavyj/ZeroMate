#include <memory>

#include <fmt/core.h>
#include <imgui/imgui.h>
#include <imgui_memory_editor/imgui_memory_editor.h>

#include "gui.hpp"

#include "../bus/bus.hpp"
#include "../peripherals/ram.hpp"
#include "../arm1176jzf_s/core.hpp"
#include "../utils/elf_loader.hpp"
#include "../utils/list_parser.hpp"

namespace zero_mate::gui
{
    static constexpr std::uint32_t RAM_SIZE = 256 * 1024 * 1024;

    static auto s_ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
    static auto s_bus = std::make_shared<CBus>();
    static auto s_cpu = std::make_unique<arm1176jzf_s::CCPU_Core>(0, s_bus);
    static std::vector<utils::TText_Section_Record> s_source_code{};

    static bool initialized_s{ false };

    static const ImGuiTableFlags table_flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                               ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                               ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

    static void Initialize()
    {
        if (s_bus->Attach_Peripheral(0x0, s_ram) != 0)
        {
            // TODO
        }

        [[maybe_unused]] const auto result = zero_mate::utils::elf::Load_Kernel(*s_bus, "/home/silhavyj/School/ZeroMate/test/utils/elf/source_files/test_02/kernel.elf");
        s_cpu->Set_PC(result.pc);
        s_source_code = utils::Extract_Text_Section_From_List_File("/home/silhavyj/School/ZeroMate/test/utils/elf/source_files/test_02/kernel.list");
    }

    static void Render_RAM_Window()
    {
        static MemoryEditor ram_editor;
        ram_editor.DrawWindow("RAM", s_ram->Get_Raw_Data(), s_ram->Get_Size());
    }

    static void Render_Registers_Table(const char* const title, const char* const type, const char* const format)
    {
        if (ImGui::BeginTable(fmt::format("##{}", title).c_str(), 2, table_flags))
        {
            ImGui::TableSetupColumn("Register", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn(fmt::format("{}##{}", type, title).c_str(), ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (std::uint32_t i = 0; i < s_cpu->NUMBER_OF_GENERAL_REGS; ++i)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();
                ImGui::Text("%s", fmt::format("R{}", i).c_str());
                ImGui::TableNextColumn();
                ImGui::InputScalar(fmt::format("##{}{}", i, title).c_str(), ImGuiDataType_U32, &s_cpu->m_regs.at(i), nullptr, nullptr, format);
            }

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("R13 (LR)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##LR{}", title).c_str(), ImGuiDataType_U32, &s_cpu->m_regs.at(s_cpu->LR_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R14 (SP)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##SP{}", title).c_str(), ImGuiDataType_U32, &s_cpu->m_regs.at(s_cpu->SP_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("R15 (PC)");
            ImGui::TableNextColumn();
            ImGui::InputScalar(fmt::format("##PC{}", title).c_str(), ImGuiDataType_U32, &s_cpu->m_regs.at(s_cpu->PC_REG_IDX), nullptr, nullptr, format);
            ImGui::TableNextRow();

            ImGui::EndTable();
        }
    }

    static void Render_CPU_Registers_Window()
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

        ImGui::Text("%s", fmt::format("N = {}", s_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::N)).c_str());
        ImGui::Text("%s", fmt::format("Z = {}", s_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::Z)).c_str());
        ImGui::Text("%s", fmt::format("C = {}", s_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::C)).c_str());
        ImGui::Text("%s", fmt::format("V = {}", s_cpu->m_cspr.Is_Flag_Set(arm1176jzf_s::CCSPR::NFlag::V)).c_str());

        ImGui::End();
    }

    static void Render_Control_Buttons_Window()
    {
        ImGui::Begin("Control");

        if (ImGui::Button("Next"))
        {
            s_cpu->Step();
        }

        ImGui::End();
    }

    static void Render_Source_Code_Window()
    {
        ImGui::Begin("Source Code Disassembly");

        if (ImGui::BeginTable("##source_code_table", 3, table_flags))
        {
            ImGui::TableSetupColumn("Address", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Opcode", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Disassembly", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (const auto& [addr, opcode, disassembly] : s_source_code)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();
                ImGui::Text("0x%08X", addr);
                ImGui::TableNextColumn();
                ImGui::Text("0x%08X", opcode);
                ImGui::TableNextColumn();
                ImGui::Text("%s", disassembly.c_str());

                if (addr == s_cpu->m_regs.at(s_cpu->PC_REG_IDX))
                {
                    const ImU32 cell_bg_color = ImGui::GetColorU32(ImVec4(1.0f, 1.0f, 0.0f, 0.35f));
                    ImGui::TableSetBgColor(ImGuiTableBgTarget_RowBg0, cell_bg_color);
                }
            }

            ImGui::EndTable();
        }

        ImGui::End();
    }

    void Render_GUI()
    {
        if (!initialized_s)
        {
            Initialize();
            initialized_s = true;
        }

        Render_RAM_Window();
        Render_CPU_Registers_Window();
        Render_Control_Buttons_Window();
        Render_Source_Code_Window();

        // ImGui::ShowDemoWindow();
    }
}