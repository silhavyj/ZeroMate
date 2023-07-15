// ---------------------------------------------------------------------------------------------------------------------
/// \file gpio_window.cpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that visualizes the states and information about GPIO pins.
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party libraries

#include "magic_enum.hpp"

// Project file imports

#include "gpio_window.hpp"

namespace zero_mate::gui
{
    CGPIO_Window::CGPIO_Window(const std::shared_ptr<peripheral::CGPIO_Manager> gpio)
    : m_gpio{ gpio }
    {
    }

    void CGPIO_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("GPIO"))
        {
            Render_GPIO_Pins_Table();
        }

        ImGui::End();
    }

    void CGPIO_Window::Render_GPIO_Pins_Table()
    {
        // Push a custom radio button color.
        ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(color::Green));

        // Render the table.
        if (ImGui::BeginTable("##GPIO", 5, Table_Flags))
        {
            // Table headings.
            ImGui::TableSetupColumn("ID", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Function", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Enabled IRQ", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("State", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Pending IRQ", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            // Iterate over all GPIO pins.
            for (std::size_t idx = 0; idx < peripheral::CGPIO_Manager::Number_of_GPIO_Pins; ++idx)
            {
                // Begin a new row.
                ImGui::TableNextRow();
                ImGui::TableNextColumn();

                // Render the pin (a single row).
                Render_GPIO_Pin(idx);
            }

            ImGui::EndTable();
        }

        // Do not forget to pop out the custom radio button color.
        ImGui::PopStyleColor();
    }

    CGPIO_Window::TInterrupt_Type CGPIO_Window::Get_Interrupt_Type_From_Idx(std::size_t idx)
    {
        // Optional because the index may exceed the number of listed enumerations.
        const auto interrupt_type_optional =
        magic_enum::enum_cast<peripheral::CGPIO_Manager::CPin::NInterrupt_Type>(static_cast<std::uint8_t>(idx));

        // Retrieve the actual type (if the index exceeds the maximum value, Undefined is used).
        const auto interrupt_type =
        interrupt_type_optional.value_or(peripheral::CGPIO_Manager::CPin::NInterrupt_Type::Undefined);

        return { .type = interrupt_type, .name = magic_enum::enum_name(interrupt_type) };
    }

    void CGPIO_Window::Render_GPIO_Pin(std::size_t idx)
    {
        // Retrieve the GPIO pin.
        const peripheral::CGPIO_Manager::CPin& pin = m_gpio->Get_Pin(idx);

        // Render the pin index.
        ImGui::Text("%d", static_cast<int>(idx));
        ImGui::TableNextColumn();

        // Render the pin function (input, output, ...).
        ImGui::Text("%s", magic_enum::enum_name(pin.Get_Function()).data());
        ImGui::TableNextColumn();

        // Go over all possible interrupt types.
        for (std::size_t j = 0; j < peripheral::CGPIO_Manager::CPin::Number_Of_Interrupt_Types; ++j)
        {
            // Get the interrupt type along with its string representation by the current index.
            const auto [int_type, int_name] = Get_Interrupt_Type_From_Idx(j);

            // Is the interrupt enabled on the GPIO pin?
            if (pin.Is_Interrupt_Enabled(int_type))
            {
                // Render the name of the interrupt.
                ImGui::Text("%s", int_name.data());
            }
        }

        // Radio button (High state = radio button is active).
        ImGui::TableNextColumn();
        ImGui::RadioButton("", pin.Get_State() == peripheral::CGPIO_Manager::CPin::NState::High);

        // Is there a pending interrupt on the GPIO pin?
        ImGui::TableNextColumn();
        if (pin.Has_Pending_IRQ())
        {
            ImGui::Text("1");
        }
    }

} // namespace zero_mate::gui