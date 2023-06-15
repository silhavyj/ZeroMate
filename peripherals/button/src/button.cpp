#include <cassert>

#include <imgui.h>

#include "button.hpp"

CButton::CButton(const std::string& name,
                 std::uint32_t pin_idx,
                 zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin)
: m_name{ name }
, m_pin_idx{ pin_idx }
, m_set_pin{ set_pin }
, m_output{ false }
, m_context{ nullptr }
{
}

void CButton::Set_ImGUI_Context(void *context) 
{
    m_context = static_cast<ImGuiContext*>(context);
}

void CButton::Render()
{
    assert(m_context != nullptr);
    ImGui::SetCurrentContext(m_context);
    
    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Pin_Idx();
        Render_Button();
    }

    ImGui::End();
}

void CButton::Render_Pin_Idx()
{
    ImGui::Text("GPIO pin: %d", m_pin_idx);
}

void CButton::Render_Button()
{
    if (ImGui::Button("Press"))
    {
        Toggle();
    }
}

void CButton::Toggle()
{
    m_set_pin(m_pin_idx, !m_output);
    m_output = !m_output;
}

extern "C"
{
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const std::string& name,
                          const std::vector<std::uint32_t>& gpio_pins,
                          zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
    {
        *peripheral = new (std::nothrow) CButton(name, gpio_pins[0], set_pin);

        if (*peripheral == nullptr)
        {
            return 1;
        }

        return 0;
    }
}