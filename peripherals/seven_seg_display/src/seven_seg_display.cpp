#include "seven_seg_display.hpp"

extern "C"
{
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const char* const name,
                          const std::uint32_t* const connection,
                          std::size_t pin_count,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                          [[maybe_unused]] zero_mate::utils::CLogging_System* logging_system)
    {
        // Exactly 3 pins shall be passed to the peripheral - latch, data, and clock.
        if (pin_count != 3)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        // Create an instance of 7-segment display.
        // clang-format off
        *peripheral = new (std::nothrow) CSeven_Segment_Display<>(name,
                                                                  read_pin,
                                                                  connection[0],
                                                                  connection[1],
                                                                  connection[2]);
        // clang-format on

        // Make sure the creation was successful.
        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        // All went well.
        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}