#include "seven_seg_display.hpp"

extern "C"
{
    EXPORTED int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                                   const std::string& name,
                                   const std::vector<std::uint32_t>& gpio_pins,
                                   [[maybe_unused]] zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                                   zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
    {
        *peripheral = new (std::nothrow) CSeven_Segment_Display<>(name, read_pin, gpio_pins[0], gpio_pins[1], gpio_pins[2]);

        if (*peripheral == nullptr)
        {
            return 1;
        }

        return 0;
    }
}