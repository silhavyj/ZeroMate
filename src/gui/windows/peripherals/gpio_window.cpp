#include <imgui.h>
#include <magic_enum.hpp>

#include "gpio_window.hpp"

namespace zero_mate::gui
{
    CGPIO_Window::CGPIO_Window(std::shared_ptr<peripheral::CGPIO_Manager> gpio)
    : m_gpio{ gpio }
    {
    }

    void CGPIO_Window::Render()
    {
        if (ImGui::Begin("GPIO"))
        {
            ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(0, 1, 0, 1));

            if (ImGui::BeginTable("##GPIO", 5, TABLE_FLAGS))
            {
                ImGui::TableSetupColumn("ID", ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn("Function", ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn("Enabled IRQ", ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn("State", ImGuiTableColumnFlags_WidthFixed);
                ImGui::TableSetupColumn("Pending IRQ", ImGuiTableColumnFlags_WidthStretch);

                ImGui::TableHeadersRow();

                for (std::size_t i = 0; i < peripheral::CGPIO_Manager::NUMBER_OF_GPIO_PINS; ++i)
                {
                    ImGui::TableNextRow();
                    ImGui::TableNextColumn();
                    ImGui::Text("%d", static_cast<int>(i));
                    ImGui::TableNextColumn();
                    ImGui::Text("%s", magic_enum::enum_name(m_gpio->Get_Pin(i).Get_Function()).data());
                    ImGui::TableNextColumn();

                    for (std::size_t j = 0; j < peripheral::CGPIO_Manager::CPin::NUMBER_OF_INTERRUPT_TYPES; ++j)
                    {
                        const auto interrupt_type = magic_enum::enum_cast<peripheral::CGPIO_Manager::CPin::NInterrupt_Type>(static_cast<std::uint8_t>(j));

                        if (m_gpio->Get_Pin(i).Is_Interrupt_Enabled(interrupt_type.value_or(peripheral::CGPIO_Manager::CPin::NInterrupt_Type::Undefined)))
                        {
                            const std::string_view interrupt_name = magic_enum::enum_name(interrupt_type.value_or(peripheral::CGPIO_Manager::CPin::NInterrupt_Type::Undefined));
                            ImGui::Text("%s", interrupt_name.data());
                        }
                    }
                    ImGui::TableNextColumn();
                    ImGui::RadioButton("", m_gpio->Get_Pin(i).Get_State() == peripheral::CGPIO_Manager::CPin::NState::High);
                    ImGui::TableNextColumn();
                    if (m_gpio->Get_Pin(i).Has_Pending_IRQ())
                    {
                        ImGui::Text("1");
                    }
                }

                ImGui::EndTable();
            }

            ImGui::PopStyleColor();
        }

        ImGui::End();
    }
}