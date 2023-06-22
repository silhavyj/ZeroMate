#include "seven_seg_display.hpp"

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
        if (pin_count != 3)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        *peripheral = new (std::nothrow) CSeven_Segment_Display<>(name, read_pin, gpio_pins[0], gpio_pins[1], gpio_pins[2]);

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}