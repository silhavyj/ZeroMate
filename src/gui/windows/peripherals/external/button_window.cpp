#include <imgui.h>
#include <fmt/include/fmt/format.h>

#include "button_window.hpp"

#include "../../../../core/utils/singleton.hpp"

namespace zero_mate::gui::external_peripheral
{
    CButton_Window::CButton_Window(std::shared_ptr<peripheral::external::CButton> button)
    : m_button{ button }
    {
    }

    void CButton_Window::Render()
    {
        if (ImGui::Begin("Button"))
        {
            Render_Combobox();
            Render_Button();
        }

        ImGui::End();
    }

    void CButton_Window::Render_Combobox()
    {
        const auto pin_idx = m_button->Get_Pin_Idx();

        if (ImGui::BeginCombo("Pin index", fmt::format("{}", pin_idx).c_str()))
        {
            for (std::size_t i = 0; i < peripheral::CGPIO_Manager::NUMBER_OF_GPIO_PINS; ++i)
            {
                if (ImGui::Selectable(fmt::format("pin {}", i).c_str()) && pin_idx != i)
                {
                    m_button->Set_Pin_Idx(static_cast<std::uint32_t>(i));
                    m_button->Set_Output(peripheral::CGPIO_Manager::CPin::NState::Low);
                }
            }

            ImGui::EndCombo();
        }
    }

    void CButton_Window::Render_Button()
    {
        if (ImGui::Button("Press"))
        {
            m_button->Toggle();
        }
    }
}