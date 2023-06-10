#include "button.hpp"

CButton::CButton(const std::vector<std::uint32_t>& gpio_pins, zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin)
: m_pin_idx{ gpio_pins[0] }
, m_set_pin{ set_pin }
, m_output{ false }
{
}

extern "C"
{
    EXTERNAL_PERIPHERAL_API
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const std::vector<std::uint32_t>& gpio_pins,
                          zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin)
    {
        *peripheral = new (std::nothrow) CButton(gpio_pins, set_pin);

        if (*peripheral == nullptr)
        {
            return 1;
        }

        return 0;
    }
}