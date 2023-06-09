// ---------------------------------------------------------------------------------------------------------------------
/// \file button.cpp
/// \date 09. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements an external button that can be hooked up to the system as define in button.hpp.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "button.hpp"
#include "../../utils/singleton.hpp"

namespace zero_mate::peripheral::external
{
    CButton::CButton(std::shared_ptr<CGPIO_Manager> gpio_manager, std::uint32_t pin_idx)
    : m_gpio_manager{ gpio_manager }
    , m_pin_idx{ pin_idx }
    , m_state{ CGPIO_Manager::CPin::NState::Low }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
    }

    std::uint32_t CButton::Get_Pin_Idx() const
    {
        return m_pin_idx;
    }

    void CButton::Set_Pin_Idx(std::uint32_t pin_idx)
    {
        m_pin_idx = pin_idx;
    }

    void CButton::Toggle()
    {
        // If the current value is Low -> set it to High and vice versa.
        if (m_state == CGPIO_Manager::CPin::NState::High)
        {
            Set_Output(CGPIO_Manager::CPin::NState::Low);
        }
        else
        {
            Set_Output(CGPIO_Manager::CPin::NState::High);
        }
    }

    void CButton::Set_Output(CGPIO_Manager::CPin::NState state)
    {
        // Set the output.
        const auto status = m_gpio_manager->Set_Pin_State(m_pin_idx, state);

        // Check the result of setting the state of the GPIO pin.
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

        // Keep track of the current state of the pin.
        m_state = state;
    }

} // namespace zero_mate::peripheral::external