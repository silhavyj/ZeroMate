// ---------------------------------------------------------------------------------------------------------------------
/// \file button.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a button that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include "imgui.h"

#define ZM_EXTERNAL_PERIPHERAL_EXPORT
#include "zero_mate/external_peripheral.hpp"

// ---------------------------------------------------------------------------------------------------------------------
/// \class CButton
/// \brief This class presents a button (external peripheral).
// ---------------------------------------------------------------------------------------------------------------------
class CButton final : public zero_mate::IExternal_Peripheral
{
public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param name Unique name of the peripheral (e.g. My_Button_1)
    /// \param pin_idx GPIO pin the button is connected to
    /// \param set_pin Function provided by the emulator that is used to change the state of a GPIO pin
    /// \param logging_system Logging system provided by the emulator
    // -----------------------------------------------------------------------------------------------------------------
    explicit CButton(std::string name,
                     std::uint32_t pin_idx,
                     zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                     zero_mate::utils::CLogging_System* logging_system);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the button (GUI).
    // -----------------------------------------------------------------------------------------------------------------
    void Render() override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets an ImGuiContext, so the button can render itself as a GUI window.
    /// \param context ImGuiContext the button uses to render itself
    // -----------------------------------------------------------------------------------------------------------------
    void Set_ImGui_Context(void* context) override;

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the number of the GPIO pin the button is connected to.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Pin_Idx() const;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the button itself.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Button();

private:
    std::string m_name;                                        ///< Unique name of the peripheral
    std::uint32_t m_pin_idx;                                   ///< GPIO pin the button is hooked up to
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin; ///< Function used to set the state of a GPIO pin
    bool m_output;                                             ///< Current output from the button
    ImGuiContext* m_context;                                   ///< ImGUI context (rendering the GUI)
    zero_mate::utils::CLogging_System* m_logging_system;       ///< Logging system
};
