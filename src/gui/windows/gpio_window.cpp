#include <imgui.h>

#include "gpio_window.hpp"

namespace zero_mate::gui
{
    CGPIO_Window::CGPIO_Window(std::shared_ptr<peripheral::CGPIO_Manager> gpio)
    : m_gpio{ gpio }
    {
    }

    void CGPIO_Window::Render()
    {
        const std::size_t number_of_pins = peripheral::CGPIO_Manager::NUMBER_OF_GPIO_PINS;

        static std::array<bool, number_of_pins> LED_values{};

        for (std::size_t i = 0; i < LED_values.size(); ++i)
        {
            LED_values.at(i) = m_gpio->Get_Pins().at(i).Get_State() == peripheral::CGPIO_Manager::CPin::NState::High;
        }

        ImGui::Begin("GPIO");
        ImGui::Columns(10, 0, false);

        ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(0, 1, 0, 1));

        // TODO this could certainly be done in a much better way
        for (std::size_t i = 0; i < 10; i++)
        {
            ImGui::PushID(static_cast<int>(i));
            ImGui::Text("%d", static_cast<int>(i));
            ImGui::RadioButton("", LED_values.at(i));
            ImGui::NextColumn();
            ImGui::PopID();
        }

        ImGui::Columns(10, 0, false);

        for (std::size_t i = 10; i < 20; i++)
        {
            ImGui::PushID(static_cast<int>(i));
            ImGui::Text("%d", static_cast<int>(i));
            ImGui::RadioButton("", LED_values.at(i));
            ImGui::NextColumn();
            ImGui::PopID();
        }

        ImGui::Columns(10, 0, false);

        for (std::size_t i = 20; i < 30; i++)
        {
            ImGui::PushID(static_cast<int>(i));
            ImGui::Text("%d", static_cast<int>(i));
            ImGui::RadioButton("", LED_values.at(i));
            ImGui::NextColumn();
            ImGui::PopID();
        }

        ImGui::Columns(10, 0, false);

        for (std::size_t i = 30; i < 40; i++)
        {
            ImGui::PushID(static_cast<int>(i));
            ImGui::Text("%d", static_cast<int>(i));
            ImGui::RadioButton("", LED_values.at(i));
            ImGui::NextColumn();
            ImGui::PopID();
        }

        ImGui::Columns(10, 0, false);

        for (std::size_t i = 40; i < 50; i++)
        {
            ImGui::PushID(static_cast<int>(i));
            ImGui::Text("%d", static_cast<int>(i));
            ImGui::RadioButton("", LED_values.at(i));
            ImGui::NextColumn();
            ImGui::PopID();
        }

        ImGui::Columns(10, 0, false);

        for (std::size_t i = 50; i < LED_values.size(); i++)
        {
            ImGui::PushID(static_cast<int>(i));
            ImGui::Text("%d", static_cast<int>(i));
            ImGui::RadioButton("", LED_values.at(i));
            ImGui::NextColumn();
            ImGui::PopID();
        }

        ImGui::PopStyleColor();
        ImGui::End();
    }
}