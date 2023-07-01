#include <cassert>
#include <utility>

#include "button.hpp"

CButton::CButton(std::string name,
                 std::uint32_t pin_idx,
                 zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                 zero_mate::utils::CLogging_System* logging_system)
: m_name{ std::move(name) }
, m_pin_idx{ pin_idx }
, m_set_pin{ set_pin }
, m_output{ true }
, m_context{ nullptr }
, m_logging_system{ logging_system }
{
}

void CButton::Set_ImGui_Context(void* context)
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

void CButton::Render_Pin_Idx() const
{
    ImGui::Text("GPIO pin: %d", m_pin_idx);
}

void CButton::Render_Button()
{
    if (ImGui::Button("Press"))
    {
        if (!m_output && !ImGui::IsItemActive())
        {
            m_output = true;
            m_logging_system->Info("Button has been released");
            m_set_pin(m_pin_idx, !m_output);
        }
    }
    else if (m_output && ImGui::IsItemActive())
    {
        m_output = false;
        m_logging_system->Info("Button has been pressed");
        m_set_pin(m_pin_idx, !m_output);
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

        *peripheral = new (std::nothrow) CButton(name, gpio_pins[0], set_pin, logging_system);

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}