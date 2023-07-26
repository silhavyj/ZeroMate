// ---------------------------------------------------------------------------------------------------------------------
/// \file aux_window.cpp
/// \date 26. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that visualizes the auxiliaries (UART1 & SPI1, and SPI2) used in BCM2835.
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party libraries

#include "fmt/format.h"
#include "magic_enum.hpp"

// Project file imports

#include "aux_window.hpp"

namespace zero_mate::gui
{
    CAUX_Window::CAUX_Window(const std::shared_ptr<peripheral::CAUX>& aux)
    : m_aux{ aux }
    {
    }

    void CAUX_Window::Render()
    {
        // Renders the window.
        if (ImGui::Begin("AUX"))
        {
            Render_AUX();
            Render_Mini_UART();
        }

        ImGui::End();
    }

    void CAUX_Window::Render_AUX()
    {
        // Render the name of the section.
        ImGui::Text("Auxiliary peripherals");

        // Render the AUX table.
        if (ImGui::BeginTable("##AUX", 3, Table_Flags))
        {
            // Table headings.
            ImGui::TableSetupColumn("Name", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Enabled", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Pending IRQ", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            // For each of the peripheral, render information whether it is enabled or disabled
            // and whether it has a pending interrupt.
            for (std::uint32_t i = 0; i < static_cast<std::uint32_t>(peripheral::CAUX::NAUX_Peripheral::Count); ++i)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();

                // Retrieve the peripheral based on the current index.
                const auto peripheral = static_cast<peripheral::CAUX::NAUX_Peripheral>(i);

                // Render the name of the peripheral.
                ImGui::Text("%s", magic_enum::enum_name(peripheral).data());
                ImGui::TableNextColumn();

                // Render information whether the peripheral is enabled or not.
                ImGui::Text("%s", fmt::format("{}", m_aux->Is_Enabled(peripheral)).c_str());
                ImGui::TableNextColumn();

                // Render information whether the peripheral has a pending interrupt or not.
                ImGui::Text("%s", fmt::format("{}", m_aux->Has_Pending_IRQ(peripheral)).c_str());
                ImGui::TableNextColumn();
            }

            ImGui::EndTable();
        }

        ImGui::Separator();
    }

    void CAUX_Window::Render_Mini_UART()
    {
        // Render the name of the section.
        ImGui::Text("Mini UART");

        // Retrieve the mini UART peripheral.
        const peripheral::CMini_UART* const uart = m_aux->Get_Mini_UART();

        // Render the mini UART table.
        if (ImGui::BeginTable("##Mini_UART", 2, Table_Flags))
        {
            ImGui::TableNextRow();
            ImGui::TableNextColumn();

            // Is the receiver enabled?
            ImGui::Text("Receiver enabled");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", uart->Is_Receiver_Enabled()).c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();

            // Is the transmitter enabled?
            ImGui::Text("Transmitter enabled");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", uart->Is_Transmitter_Enabled()).c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();

            // Character length (7/8 bits)
            ImGui::Text("Char length");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", magic_enum::enum_name(uart->Get_Char_Length())).c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();

            // Bourd rate counter
            ImGui::Text("Baudrate counter");
            ImGui::TableNextColumn();
            ImGui::Text("%d", uart->Get_Baud_Rate_Counter());

            ImGui::EndTable();
        }

        ImGui::Separator();
    }

} // namespace zero_mate::gui