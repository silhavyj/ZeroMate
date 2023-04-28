#include <magic_enum.hpp>

#include "interrupt_controller_window.hpp"

namespace zero_mate::gui
{
    CInterrupt_Controller_Window::CInterrupt_Controller_Window(const std::shared_ptr<peripheral::CInterrupt_Controller> interrupt_controller)
    : m_interrupt_controller{ interrupt_controller }
    {
    }

    void CInterrupt_Controller_Window::Render()
    {
        if (ImGui::Begin("Interrupt controller"))
        {
            ImGui::Text("Has a pending interrupt: %d", static_cast<int>(m_interrupt_controller->Has_Pending_Interrupt()));

            Render_Basic_IRQ();
            Render_IRQ();
        }

        ImGui::End();
    }

    void CInterrupt_Controller_Window::Render_Basic_IRQ()
    {
        if (ImGui::BeginTable("##Basic_IRQ", 3, TABLE_FLAGS))
        {
            ImGui::TableSetupColumn("Source", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Enabled", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Pending", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (const auto& [source, info] : m_interrupt_controller->Get_Basic_IRQs())
            {
                ImGui::TableNextRow();

                ImGui::TableNextColumn();
                ImGui::Text("%s", magic_enum::enum_name(source).data());

                ImGui::TableNextColumn();
                if (info.enabled)
                {
                    ImGui::Text("1");
                }

                ImGui::TableNextColumn();
                if (info.pending)
                {
                    ImGui::Text("1");
                }
            }

            ImGui::EndTable();
        }
    }

    void CInterrupt_Controller_Window::Render_IRQ()
    {
        if (ImGui::BeginTable("##IRQ", 3, TABLE_FLAGS))
        {
            ImGui::TableSetupColumn("Source", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Enabled", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Pending", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            for (const auto& [source, info] : m_interrupt_controller->Get_IRQs())
            {
                ImGui::TableNextRow();

                ImGui::TableNextColumn();
                ImGui::Text("%s", magic_enum::enum_name(source).data());

                ImGui::TableNextColumn();
                if (info.enabled)
                {
                    ImGui::Text("1");
                }

                ImGui::TableNextColumn();
                if (info.pending)
                {
                    ImGui::Text("1");
                }
            }

            ImGui::EndTable();
        }
    }
}