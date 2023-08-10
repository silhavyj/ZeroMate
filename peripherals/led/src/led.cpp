// ---------------------------------------------------------------------------------------------------------------------
/// \file led.cpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements an LED that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#include <cassert>

#include "led.hpp"

CLED::CLED(const std::string& name, std::uint32_t pin_idx, zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
: m_name{ std::move(name) }
, m_pin_idx{ pin_idx }
, m_read_pin{ read_pin }
, m_context{ nullptr }
, m_pin_high{ false }
, m_color{ 1, 1, 0, 0 }
{
    Init_GPIO_Subscription();
}

void CLED::Init_GPIO_Subscription()
{
    // The LED listens to the pin is has been assigned (it is connected to).
    m_gpio_subscription.insert(m_pin_idx);
}

void CLED::Set_ImGui_Context(void* context)
{
    // Store the ImGUI Context.
    m_context = static_cast<ImGuiContext*>(context);
}

void CLED::GPIO_Subscription_Callback(std::uint32_t pin_idx)
{
    // The state of the GPIO pin has changed (read the current state).
    m_pin_high = m_read_pin(pin_idx);
}

void CLED::Render()
{
    // Make sure the ImGUIContext has been set.
    assert(m_context != nullptr);
    ImGui::SetCurrentContext(m_context);

    // Render the window.
    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Pin_Idx();
        Render_Color_Picker();
        Render_LED();
    }

    ImGui::End();
}

void CLED::Render_Pin_Idx() const
{
    ImGui::Text("GPIO pin: %d", m_pin_idx);
}

void CLED::Render_Color_Picker()
{
    static const std::string color_picker_id = "Color##" + m_name;
    ImGui::ColorEdit3(color_picker_id.c_str(), reinterpret_cast<float*>(&m_color));
    ImGui::Separator();
}

void CLED::Render_LED()
{
    // List to draw a circle.
    ImDrawList* draw_list = ImGui::GetWindowDrawList();

    // Get the region boundaries.
    ImVec2 v_min = ImGui::GetWindowContentRegionMin();

    // Offset from the top of the window.
    static constexpr int OFFSET_Y = 60;

    // Move it relatively to the window position.
    v_min.x += ImGui::GetWindowPos().x;
    v_min.y += ImGui::GetWindowPos().y + OFFSET_Y;

    static constexpr int Radius = 20;
    static constexpr int Center_Offset_X = 20;
    static constexpr int Center_Offset_Y = 15;

    // Render the LED (circle).
    draw_list->AddCircleFilled({ v_min.x + Center_Offset_X, v_min.y + Center_Offset_Y }, Radius, Get_Current_Color());
}

inline ImU32 CLED::Get_Current_Color() const
{
    // Gray-ish color = passive color.
    static constexpr ImU32 Passive_Color = IM_COL32(60, 60, 60, 255);

    if (!m_pin_high)
    {
        return Passive_Color;
    }

    return IM_COL32(m_color.x * 255, m_color.y * 255, m_color.z * 255, 255);
}

extern "C"
{
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const char* const name,
                          const std::uint32_t* const gpio_pins,
                          std::size_t pin_count,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                          [[maybe_unused]] zero_mate::utils::CLogging_System* logging_system)
    {
        // Only one pin shall be passed to the peripheral.
        if (pin_count != 1)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        // Create an instance of an LED.
        *peripheral = new (std::nothrow) CLED(name, gpio_pins[0], read_pin);

        // Make sure the creation was successful.
        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        // All went well.
        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}