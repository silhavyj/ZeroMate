#include "button.hpp"

CButton::CButton(const std::string& name,
                 std::uint32_t pin_idx,
                 zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin)
: m_name{ name }
, m_pin_idx{ pin_idx }
, m_set_pin{ set_pin }
, m_output{ false }
{
}

extern "C"
{
    EXTERNAL_PERIPHERAL_API
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const std::string& name,
                          const std::vector<std::uint32_t>& gpio_pins,
                          zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
    {
        *peripheral = new (std::nothrow) CButton(name, gpio_pins[0], set_pin);

        if (*peripheral == nullptr)
        {
            return 1;
        }

        return 0;
    }
}