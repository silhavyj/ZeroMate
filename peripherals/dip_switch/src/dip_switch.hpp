// ---------------------------------------------------------------------------------------------------------------------
/// \file dip_switch.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a DIP switch that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include <imgui.h>
#include <zero_mate/external_peripheral.hpp>

// ---------------------------------------------------------------------------------------------------------------------
/// \class CDIP_Switch
/// \brief This class presents a DIP switch (external peripheral).
// ---------------------------------------------------------------------------------------------------------------------
class CDIP_Switch : public zero_mate::IExternal_Peripheral
{
public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param name Unique name of the peripheral (e.g. My_DIP_Switch_1)
    /// \param pin_idx GPIO pin the DIP switch is connected to
    /// \param set_pin Function provided by the emulator that is used to change the state of a GPIO pin
    // -----------------------------------------------------------------------------------------------------------------
    explicit CDIP_Switch(std::string name,
                         std::uint32_t pin_idx,
                         zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the DIP switch (GUI).
    // -----------------------------------------------------------------------------------------------------------------
    void Render() override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets an ImGuiContext, so the DIP switch can render itself as a GUI window.
    /// \param context ImGuiContext the DIP switch uses to render itself
    // -----------------------------------------------------------------------------------------------------------------
    void Set_ImGui_Context(void* context) override;

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the number of the GPIO pin the DIP switch is connected to.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Pin_Idx() const;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the DIP switch itself.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_DIP_Switch();

private:
    std::string m_name;                                        ///< Unique name of the peripheral
    std::uint32_t m_pin_idx;                                   ///< GPIO pin the DIP switch is hooked up to
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin; ///< Function used to set the state of a GPIO pin
    ImGuiContext* m_context;                                   ///< ImGUI context (rendering the GUI)
    bool m_output;                                             ///< Current output from the DIP switch
};