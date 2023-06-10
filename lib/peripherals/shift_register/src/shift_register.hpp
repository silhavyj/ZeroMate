#pragma once

#include <numeric>

#include <zero_mate/external_peripheral.hpp>

template<std::unsigned_integral Register = std::uint8_t>
class CShift_Register final : public zero_mate::IExternal_Peripheral
{
public:
    explicit CShift_Register(const std::string& name,
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
    , m_clock_state{ 0 }
    , m_clock_state_prev{ 0 }
    {
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

private:
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