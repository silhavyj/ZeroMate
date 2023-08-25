// ---------------------------------------------------------------------------------------------------------------------
/// \file seven_seg_display.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an 7-segment display that can be connected to GPIO pins at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include <bitset>
#include <cassert>
#include <numeric>

#include "imgui.h"

#include "zero_mate/external_peripheral.hpp"

// ---------------------------------------------------------------------------------------------------------------------
/// \class CSeven_Segment_Display
/// \brief This class presents a 7-segment display (external peripheral).
/// \tparam Register Size of a shift register that is used to control the display.
// ---------------------------------------------------------------------------------------------------------------------
template<std::unsigned_integral Register = std::uint8_t>
class CSeven_Segment_Display final : public zero_mate::IExternal_Peripheral
{
public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param name Unique name of the peripheral (e.g. My_7_SEG_DISPLAY_1)
    /// \param read_pin Function provided by the emulator that is used to read the state of a GPIO pin
    /// \param latch_pin_idx Latch GPIO pin index (shift register)
    /// \param data_pin_idx Data GPIO pin index (shift register)
    /// \param clock_pin_idx Clock GPIO pin index (shift register)
    // -----------------------------------------------------------------------------------------------------------------
    explicit CSeven_Segment_Display(const std::string& name,
                                    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                                    std::uint32_t latch_pin_idx,
                                    std::uint32_t data_pin_idx,
                                    std::uint32_t clock_pin_idx)
    : m_name{ std::move(name) }
    , m_read_pin{ read_pin }
    , m_last_input_value{ 0 }
    , m_value{ 0 }
    , m_output_value{ 0 }
    , m_latch_pin_idx{ latch_pin_idx }
    , m_data_pin_idx{ data_pin_idx }
    , m_clock_pin_idx{ clock_pin_idx }
    , m_clock_state{ false }
    , m_clock_state_prev{ false }
    , m_context{ nullptr }
    {
        Init_GPIO_Subscription();
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets an ImGuiContext, so the display can render itself as a GUI window.
    /// \param context ImGuiContext the display uses to render itself
    // -----------------------------------------------------------------------------------------------------------------
    void Set_ImGui_Context(void* context) override
    {
        m_context = static_cast<ImGuiContext*>(context);
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Callback function that notifies the peripheral about a change of one of the pins it subscribes to.
    /// \param pin_idx  Index of the GPIO pin whose state has been changed
    // -----------------------------------------------------------------------------------------------------------------
    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override
    {
        Handle_Clock_Signal(pin_idx);
        Handle_Data_Signal(pin_idx);
        Handle_Latch_Signal(pin_idx);
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Returns a raw value that is stored in the shift register.
    /// \return Value stored in the shift register
    // -----------------------------------------------------------------------------------------------------------------
    [[nodiscard]] Register Get_Value() const noexcept
    {
        return m_output_value;
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the display (GUI).
    // -----------------------------------------------------------------------------------------------------------------
    void Render() override
    {
        // Make sure the ImGUIContext has been set.
        assert(m_context != nullptr);
        ImGui::SetCurrentContext(m_context);

        // Render the window.
        if (ImGui::Begin(m_name.c_str()))
        {
            Render_Shift_Register();
            Render_Pin_Indexes();
            Render_Seven_Segment_Display();
        }

        ImGui::End();
    }

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the indexes of GPIO pins the display (shift register) is connected to.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Pin_Indexes()
    {
        ImGui::Text("Latch pin: %d", m_latch_pin_idx);
        ImGui::Text("Data pin: %d", m_data_pin_idx);
        ImGui::Text("Clock pin: %d", m_clock_pin_idx);
        ImGui::Separator();
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the shift register (its current value in a binary representation).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Shift_Register()
    {
        const std::bitset<8> binaryBits(Get_Value());
        ImGui::Text("shift register: %s", binaryBits.to_string().c_str());
        ImGui::Separator();
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the seven segment display itself.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Seven_Segment_Display()
    {
        // List to draw the segments of the display.
        ImDrawList* draw_list = ImGui::GetWindowDrawList();

        // Get the region boundaries.
        ImVec2 v_min = ImGui::GetWindowContentRegionMin();

        // Offset from the top of the window.
        static constexpr int OFFSET_Y = 90;
        static constexpr int SIZE = 25;
        static constexpr int THICKNESS = 5;

        // Move it relatively to the window position.
        v_min.x += ImGui::GetWindowPos().x;
        v_min.y += ImGui::GetWindowPos().y + OFFSET_Y;

        // Draw all 7 segments of the display.
        draw_list->AddLine(v_min, { v_min.x + SIZE, v_min.y }, Get_Segment_Color(7), THICKNESS);

        draw_list->AddLine(v_min, { v_min.x, v_min.y + SIZE }, Get_Segment_Color(1), THICKNESS);

        draw_list->AddLine({ v_min.x + SIZE, v_min.y },
                           { v_min.x + SIZE, v_min.y + SIZE },
                           Get_Segment_Color(4),
                           THICKNESS);

        draw_list->AddLine({ v_min.x, v_min.y + SIZE },
                           { v_min.x + SIZE, v_min.y + SIZE },
                           Get_Segment_Color(0),
                           THICKNESS);

        draw_list->AddLine({ v_min.x, v_min.y + SIZE },
                           { v_min.x, v_min.y + 2 * SIZE },
                           Get_Segment_Color(6),
                           THICKNESS);
        draw_list->AddLine({ v_min.x + SIZE, v_min.y + SIZE },
                           { v_min.x + SIZE, v_min.y + 2 * SIZE },
                           Get_Segment_Color(2),
                           THICKNESS);

        draw_list->AddLine({ v_min.x, v_min.y + 2 * SIZE },
                           { v_min.x + SIZE, v_min.y + 2 * SIZE },
                           Get_Segment_Color(3),
                           THICKNESS);

        // Draw the dot of the display as well.
        draw_list->AddCircleFilled({ v_min.x + SIZE + 2 * THICKNESS, v_min.y + 2 * SIZE },
                                   THICKNESS,
                                   Get_Segment_Color(5));
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Returns the color of a requested segment of the display.
    /// \param segment_idx Index of the segment whose color will be returned
    /// \return Color of the given segment
    // -----------------------------------------------------------------------------------------------------------------
    inline ImU32 Get_Segment_Color(std::uint8_t segment_idx) const
    {
        static constexpr ImU32 ACTIVE_COLOR = IM_COL32(255, 0, 0, 255);  // Segment is on
        static constexpr ImU32 PASIVE_COLOR = IM_COL32(60, 60, 60, 255); // Segment is off

        // The value needs to be retrieved from the shift register (the bits are stored in a reverse order).
        const std::uint8_t index =
        static_cast<std::uint8_t>(std::numeric_limits<std::uint8_t>::digits - 1) - segment_idx;

        // Check if the segment is active.
        if (!static_cast<bool>((Get_Value() >> index) & 0b1U))
        {
            return ACTIVE_COLOR;
        }

        return PASIVE_COLOR;
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes the subscription (list of GPIO pins the peripheral wants to listen to).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Init_GPIO_Subscription()
    {
        m_gpio_subscription.clear();

        m_gpio_subscription.insert(m_data_pin_idx);
        m_gpio_subscription.insert(m_clock_pin_idx);
        m_gpio_subscription.insert(m_latch_pin_idx);
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Handles a change of the clock pin.
    /// \param pin_idx Index of the pin whose state has been changed
    // -----------------------------------------------------------------------------------------------------------------
    inline void Handle_Clock_Signal(std::uint32_t pin_idx)
    {
        // Was it the clock pin whose state was changed? If not, bail.
        if (pin_idx != m_clock_pin_idx)
        {
            return;
        }

        // Red the new state of the clock pin.
        m_clock_state = m_read_pin(m_clock_pin_idx);

        // Has the signal gone down?
        if (m_clock_state_prev && !m_clock_state)
        {
            // Shift the content of the register to the right
            m_value >>= 1;

            // Insert the last data bit to the very left side of the register.
            m_value |= static_cast<Register>((m_last_input_value << (std::numeric_limits<Register>::digits - 1)));

            // Clear the last input.
            m_last_input_value = 0;
        }

        // Update the current state of the clock signal.
        m_clock_state_prev = m_clock_state;
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Handles a change of the latch pin.
    /// \param pin_idx Index of the pin whose state has been changed
    // -----------------------------------------------------------------------------------------------------------------
    inline void Handle_Latch_Signal(std::uint32_t pin_idx)
    {
        // Was it the latch pin whose state was changed? If not, bail.
        if (pin_idx != m_latch_pin_idx)
        {
            return;
        }

        // Is the latch pin was set to high, propagate the value of the register to the output.
        if (m_read_pin(m_latch_pin_idx))
        {
            m_output_value = m_value;
        }
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Handles a change of the data pin.
    /// \param pin_idx Index of the pin whose state has been changed
    // -----------------------------------------------------------------------------------------------------------------
    inline void Handle_Data_Signal(std::uint32_t pin_idx)
    {
        // Was it the data pin whose state was changed? If not, bail.
        if (pin_idx != m_data_pin_idx)
        {
            return;
        }

        // Read the value off the data pin and store it as the last input.
        const auto data_pin_value = m_read_pin(m_data_pin_idx);
        m_last_input_value = static_cast<std::uint32_t>(data_pin_value);
    }

private:
    std::string m_name;                                          ///< Unique name of the peripheral
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin; ///< Function used to read the state of a GPIO pin
    std::uint32_t m_last_input_value;                            ///< Last input value to the shift register
    Register m_value;                                            ///< Private output value of the shift register
    Register m_output_value;                                     ///< Public output value of the shift register
    std::uint32_t m_latch_pin_idx;                               ///< Index of the latch pin
    std::uint32_t m_data_pin_idx;                                ///< Index of the dat pin
    std::uint32_t m_clock_pin_idx;                               ///< Index of the clock pin
    bool m_clock_state;                                          ///< Current state of the clock signal
    bool m_clock_state_prev;                                     ///< Previous state of the clock signal
    ImGuiContext* m_context;                                     ///< ImGUI context (rendering the GUI)
};