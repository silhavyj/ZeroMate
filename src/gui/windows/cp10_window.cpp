// ---------------------------------------------------------------------------------------------------------------------
/// \file cp10_window.cpp
/// \date 07. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that displays data (information) related to coprocessor 10 (FPU).
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "cp10_window.hpp"

namespace zero_mate::gui
{
    CCP10_Window::CCP10_Window(std::shared_ptr<coprocessor::cp10::CCP10> cp10)
    : m_cp10{ cp10 }
    {
    }

    void CCP10_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("CP10"))
        {
            Render_FPSCR();
            Render_FPEXC();
            Render_Registers();
        }

        ImGui::End();
    }

    void CCP10_Window::Render_Registers()
    {
        // Collection of all S{X} registers of the FPU.
        const auto registers = m_cp10->Get_Registers();

        // Index of the current registers.
        std::uint32_t reg_idx{ 0 };

        // Render a table with FPU registers.
        if (ImGui::BeginTable("S_registers", 3, Table_Flags))
        {
            // Render the table headings.
            ImGui::TableSetupColumn("Register", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("HEX", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Float", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            // Render each register one by one.
            for (const auto& reg : registers)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();
                ImGui::Text("S%d", reg_idx);
                ImGui::TableNextColumn();
                ImGui::Text("%08X", reg.Get_Value_As<std::uint32_t>());
                ImGui::TableNextColumn();
                ImGui::Text("%.6f", static_cast<double>(reg.Get_Value_As<float>()));

                ++reg_idx;
            }

            ImGui::EndTable();
        }
    }

    void CCP10_Window::Render_FPSCR()
    {
        // Retrieve the FPSCR register.
        const coprocessor::cp10::CFPSCR& fpscr = m_cp10->Get_FPSCR();

        // Render a label (Flags in FPSCR)
        ImGui::Text("Flags in FPSCR");

        // Render a table with the current state of the flags of the FPSCR register.
        if (ImGui::BeginTable("FPSCR", 4, Table_Flags))
        {
            // Render table headings.
            ImGui::TableSetupColumn("N", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Z", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("C", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("V", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            // Render the flags themselves.
            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(fpscr.Is_Flag_Set(coprocessor::cp10::CFPSCR::NFlag::N)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(fpscr.Is_Flag_Set(coprocessor::cp10::CFPSCR::NFlag::Z)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(fpscr.Is_Flag_Set(coprocessor::cp10::CFPSCR::NFlag::C)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(fpscr.Is_Flag_Set(coprocessor::cp10::CFPSCR::NFlag::V)));

            ImGui::EndTable();
        }

        ImGui::Separator();
    }

    void CCP10_Window::Render_FPEXC()
    {
        // Retrieve the FPEXC register.
        const coprocessor::cp10::CFPEXC& fpexc = m_cp10->Get_FPEXC();

        // Render a label (Flags in FPEXC)
        ImGui::Text("Flags in FPEXC");

        // Render a table with the current state of the flags of the FPEXC register.
        if (ImGui::BeginTable("FPEXC", 2, Table_Flags))
        {
            // Render table headings.
            ImGui::TableSetupColumn("EX", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("EN", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            // Render the flags themselves.
            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(fpexc.Is_Flag_Set(coprocessor::cp10::CFPEXC::NFlag::EX)));
            ImGui::TableNextColumn();
            ImGui::Text("%d", static_cast<int>(fpexc.Is_Flag_Set(coprocessor::cp10::CFPEXC::NFlag::EN)));

            ImGui::EndTable();
        }

        ImGui::Separator();
    }

} // namespace zero_mate::gui