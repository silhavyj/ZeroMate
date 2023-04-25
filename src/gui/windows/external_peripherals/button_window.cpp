#include <imgui.h>
#include <fmt/format.h>

#include "button_window.hpp"

#include "../../../core/utils/singleton.hpp"

namespace zero_mate::gui::external_peripheral
{
    CButton::CButton(std::shared_ptr<peripheral::CGPIO_Manager> gpio)
    : m_gpio{ gpio }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_state{ peripheral::CGPIO_Manager::CPin::NState::High }
    , m_pin_idx{ 0 }
    {
    }

    void CButton::Render()
    {
        if (ImGui::Begin("Button"))
        {
            Render_Combobox();
            Render_Button();
        }

        ImGui::End();
    }

    void CButton::Render_Combobox()
    {
        if (ImGui::BeginCombo("Pin index", fmt::format("{}", m_pin_idx).c_str()))
        {
            for (std::size_t i = 0; i < peripheral::CGPIO_Manager::NUMBER_OF_GPIO_PINS; ++i)
            {
                if (ImGui::Selectable(fmt::format("ping {}", i).c_str()) && m_pin_idx != i)
                {
                    m_pin_idx = i;
                    m_state = peripheral::CGPIO_Manager::CPin::NState::High;
                }
            }
            ImGui::EndCombo();
        }
    }

    void CButton::Render_Button()
    {
        if (ImGui::Button("Press"))
        {
            const auto status = m_gpio->Set_Pin_State(m_pin_idx, m_state);

            switch (status)
            {
                case peripheral::CGPIO_Manager::NPin_Set_Status::OK:
                    break;

                case peripheral::CGPIO_Manager::NPin_Set_Status::Not_Input_Pin:
                    m_logging_system.Debug("The pin has not been set as INPUT");
                    break;

                case peripheral::CGPIO_Manager::NPin_Set_Status::Invalid_Pin_Number:
                    m_logging_system.Debug("Invalid pin number");
                    break;

                case peripheral::CGPIO_Manager::NPin_Set_Status::State_Already_Set:
                    m_logging_system.Debug("Pin state is already set the desired value");
                    break;
            }

            Swap_State();
        }
    }

    void CButton::Swap_State()
    {
        if (m_state == peripheral::CGPIO_Manager::CPin::NState::High)
        {
            m_state = peripheral::CGPIO_Manager::CPin::NState::Low;
        }
        else
        {
            m_state = peripheral::CGPIO_Manager::CPin::NState::High;
        }
    }
}