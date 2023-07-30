// ---------------------------------------------------------------------------------------------------------------------
/// \file led.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an LED that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include <imgui.h>
#include <zero_mate/external_peripheral.hpp>

// ---------------------------------------------------------------------------------------------------------------------
/// \class CLED
/// \brief This class presents an LED (external peripheral).
// ---------------------------------------------------------------------------------------------------------------------
class CLED final : public zero_mate::IExternal_Peripheral
{
public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param name Unique name of the peripheral (e.g. My_LED_1)
    /// \param pin_idx GPIO pin the LED is connected to
    /// \param read_pin Function provided by the emulator that is used to read the state of a GPIO pin
    // -----------------------------------------------------------------------------------------------------------------
    explicit CLED(const std::string& name,
                  std::uint32_t pin_idx,
                  zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the LED (GUI).
    // -----------------------------------------------------------------------------------------------------------------
    void Render() override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets an ImGuiContext, so the LED can render itself as a GUI window.
    /// \param context ImGuiContext the LED uses to render itself
    // -----------------------------------------------------------------------------------------------------------------
    void Set_ImGui_Context(void* context) override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Callback function that notifies the peripheral about a change of one of the pins it subscribes to.
    /// \param pin_idx Index of the GPIO pin whose state has been changed
    // -----------------------------------------------------------------------------------------------------------------
    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override;

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes the subscription (list of GPIO pins the peripheral wants to listen to).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Init_GPIO_Subscription();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the index of the pin the LED is connected to.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Pin_Idx() const;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders a color picker that is used to choose the color of the LED.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Color_Picker();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the LED itself.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_LED();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Returns the current color of the LED based on its current state (on/off).
    /// \return Current color of the LED
    // -----------------------------------------------------------------------------------------------------------------
    [[nodiscard]] inline ImU32 Get_Current_Color() const;

private:
    std::string m_name;                                          ///< Unique name of the peripheral
    std::uint32_t m_pin_idx;                                     ///< GPIO pin the LED is hooked up to
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin; ///< Function used to read the state of a GPIO pin
    ImGuiContext* m_context;                                     ///< ImGUI context (rendering the GUI)
    bool m_pin_high;                                             ///< Current state of the LED
    ImVec4 m_color;                                              ///< Color of choice of the LED
};