// ---------------------------------------------------------------------------------------------------------------------
/// \file interrupt_controller_window.cpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that visualizes the interrupt controller IC.
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party libraries

#include "magic_enum.hpp"

// Project file imports

#include "interrupt_controller_window.hpp"

namespace zero_mate::gui
{
    CInterrupt_Controller_Window::CInterrupt_Controller_Window(
    const std::shared_ptr<peripheral::CInterrupt_Controller> interrupt_controller)
    : m_interrupt_controller{ interrupt_controller }
    {
    }

    void CInterrupt_Controller_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("IC"))
        {
            // Render pending IRQ.
            Render_Pending_IRQ();
            ImGui::Separator();

            // Render basic IRQ sources.
            Render_IRQ("Basic IRQ sources", m_interrupt_controller->Get_Basic_IRQs());
            ImGui::Separator();

            // Render IRQ sources.
            Render_IRQ("IRQ sources", m_interrupt_controller->Get_IRQs());
        }

        ImGui::End();
    }

    void CInterrupt_Controller_Window::Render_Pending_IRQ()
    {
        // Render information about a pending interrupt.
        ImGui::Text("Has a pending interrupt: %d", static_cast<int>(m_interrupt_controller->Has_Pending_Interrupt()));
    }

    template<typename IRQ_Sources>
    void CInterrupt_Controller_Window::Render_IRQ(const char* name, const IRQ_Sources& irq_sources)
    {
        ImGui::Text("%s", name);

        if (ImGui::BeginTable(name, 3, Table_Flags))
        {
            // Table headings
            ImGui::TableSetupColumn("Source", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Enabled", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Pending", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            // Go over all IRQ sources.
            for (const auto& [source, info] : irq_sources)
            {
                // Move on to the next row.
                ImGui::TableNextRow();
                ImGui::TableNextColumn();

                // Render the name of the source.
                ImGui::Text("%s", magic_enum::enum_name(source).data());
                ImGui::TableNextColumn();

                // If the IRQ source is enabled, render "1". Otherwise, do not render anything.
                if (info.enabled)
                {
                    ImGui::Text("1");
                }
                ImGui::TableNextColumn();

                // If there is a pending IRQ, render "1". Otherwise, do not render anything.
                if (info.pending)
                {
                    ImGui::Text("1");
                }
            }

            ImGui::EndTable();
        }
    }

} // namespace zero_mate::gui