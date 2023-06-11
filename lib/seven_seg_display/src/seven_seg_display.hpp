#pragma once

#include <numeric>

#include <imgui.h>
#include <zero_mate/external_peripheral.hpp>

template<std::unsigned_integral Register = std::uint8_t>
class CSeven_Segment_Display final : public zero_mate::IExternal_Peripheral
{
public:
    explicit CSeven_Segment_Display(const std::string& name,
                                    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                                    std::uint32_t latch_pin_idx,
                                    std::uint32_t data_pin_idx,
                                    std::uint32_t clock_pin_idx)
    : m_name{ name }
    , m_read_pin{ read_pin }
    , m_last_input_value{ 0 }
    , m_value{ 0 }
    , m_output_value{ 0 }
    , m_latch_pin_idx{ latch_pin_idx }
    , m_data_pin_idx{ data_pin_idx }
    , m_clock_pin_idx{ clock_pin_idx }
    , m_clock_state{ false }
    , m_clock_state_prev{ false }
    {
        Init_GPIO_Subscription();
    }

    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override
    {
        Handle_Clock_Signal(pin_idx);
        Handle_Data_Signal(pin_idx);
        Handle_Latch_Signal(pin_idx);
    }

    [[nodiscard]] Register Get_Value() const noexcept
    {
        return m_output_value;
    }

    void Render() override
    {
        if (ImGui::Begin(m_name.c_str()))
        {
            Render_Shift_Register();
            Render_Seven_Segment_Display();
        }

        ImGui::End();
    }

private:
    inline void Render_Shift_Register()
    {
        ImGui::Text("shift register: %d", Get_Value());
        ImGui::Separator();
    }

    inline void Render_Seven_Segment_Display()
    {
        ImDrawList* draw_list = ImGui::GetWindowDrawList();

        ImVec2 v_min = ImGui::GetWindowContentRegionMin();

        static constexpr int OFFSET_Y = 30;
        static constexpr int SIZE = 25;
        static constexpr int THICKNESS = 5;

        // Move it relatively to the window position.
        v_min.x += ImGui::GetWindowPos().x;
        v_min.y += ImGui::GetWindowPos().y + OFFSET_Y;

        draw_list->AddLine(v_min, { v_min.x + SIZE, v_min.y }, Get_Segment_Color(7), THICKNESS);
        draw_list->AddLine(v_min, { v_min.x, v_min.y + SIZE }, Get_Segment_Color(1), THICKNESS);
        draw_list->AddLine({ v_min.x + SIZE, v_min.y }, { v_min.x + SIZE, v_min.y + SIZE }, Get_Segment_Color(4), THICKNESS);

        draw_list->AddLine({ v_min.x, v_min.y + SIZE }, { v_min.x + SIZE, v_min.y + SIZE }, Get_Segment_Color(0), THICKNESS);

        draw_list->AddLine({ v_min.x, v_min.y + SIZE }, { v_min.x, v_min.y + 2 * SIZE }, Get_Segment_Color(6), THICKNESS);
        draw_list->AddLine({ v_min.x + SIZE, v_min.y + SIZE }, { v_min.x + SIZE, v_min.y + 2 * SIZE }, Get_Segment_Color(2), THICKNESS);
        draw_list->AddLine({ v_min.x, v_min.y + 2 * SIZE }, { v_min.x + SIZE, v_min.y + 2 * SIZE }, Get_Segment_Color(3), THICKNESS);

        draw_list->AddCircleFilled({ v_min.x + SIZE + 2 * THICKNESS, v_min.y + 2 * SIZE }, THICKNESS, Get_Segment_Color(5));
    }

    inline ImU32 Get_Segment_Color(std::uint8_t segment_idx) const
    {
        static constexpr ImU32 ACTIVE_COLOR = IM_COL32(255, 0, 0, 255);
        static constexpr ImU32 PASIVE_COLOR = IM_COL32(60, 60, 60, 255);

        const std::uint8_t index = static_cast<std::uint8_t>(std::numeric_limits<std::uint8_t>::digits - 1) - segment_idx;

        if (!static_cast<bool>((Get_Value() >> index) & 0b1U))
        {
            return ACTIVE_COLOR;
        }

        return PASIVE_COLOR;
    }

    inline void Init_GPIO_Subscription()
    {
        m_gpio_subscription.clear();

        m_gpio_subscription.insert(m_data_pin_idx);
        m_gpio_subscription.insert(m_clock_pin_idx);
        m_gpio_subscription.insert(m_latch_pin_idx);
    }

    inline void Handle_Clock_Signal(std::uint32_t pin_idx)
    {
        if (pin_idx != m_clock_pin_idx)
        {
            return;
        }

        m_clock_state = m_read_pin(m_clock_pin_idx);

        if (m_clock_state_prev && !m_clock_state)
        {
            m_value >>= 1;
            m_value |= static_cast<Register>((m_last_input_value << (std::numeric_limits<Register>::digits - 1)));
            m_last_input_value = 0;
        }

        m_clock_state_prev = m_clock_state;
    }

    inline void Handle_Latch_Signal(std::uint32_t pin_idx)
    {
        if (pin_idx != m_latch_pin_idx)
        {
            return;
        }

        if (m_read_pin(m_latch_pin_idx))
        {
            m_output_value = m_value;
        }
    }

    inline void Handle_Data_Signal(std::uint32_t pin_idx)
    {
        if (pin_idx != m_data_pin_idx)
        {
            return;
        }

        const auto data_pin_value = m_read_pin(m_data_pin_idx);
        m_last_input_value = static_cast<std::uint32_t>(data_pin_value);
    }

private:
    std::string m_name;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    std::uint32_t m_last_input_value;
    Register m_value;
    Register m_output_value;
    std::uint32_t m_latch_pin_idx;
    std::uint32_t m_data_pin_idx;
    std::uint32_t m_clock_pin_idx;
    bool m_clock_state;
    bool m_clock_state_prev;
};