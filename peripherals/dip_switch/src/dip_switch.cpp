#include "dip_switch.hpp"

CDIP_Switch::CDIP_Switch(std::string name,
                         std::uint32_t pin_idx,
                         zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin)
: m_name{ std::move(name) }
, m_pin_idx{ pin_idx }
, m_set_pin{ set_pin }
, m_output{ false }
{
}

void CDIP_Switch::Set_ImGui_Context(void* context)
{
    m_context = static_cast<ImGuiContext*>(context);
}

void CDIP_Switch::Render()
{
    assert(m_context != nullptr);
    ImGui::SetCurrentContext(m_context);

    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Pin_Idx();
        Render_DIP_Switch();
    }

    ImGui::End();
}

void CDIP_Switch::Render_Pin_Idx() const
{
    ImGui::Text("GPIO pin: %d", m_pin_idx);
}

void CDIP_Switch::Render_DIP_Switch()
{
    if (ImGui::Checkbox("Toggle", &m_output))
    {
        m_set_pin(m_pin_idx, m_output);
    }
}

extern "C"
{
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const char* const name,
                          const std::uint32_t* const gpio_pins,
                          std::size_t pin_count,
                          zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                          [[maybe_unused]] zero_mate::utils::CLogging_System* logging_system)
    {
        if (pin_count != 1)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        *peripheral = new (std::nothrow) CDIP_Switch(name, gpio_pins[0], set_pin);

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}