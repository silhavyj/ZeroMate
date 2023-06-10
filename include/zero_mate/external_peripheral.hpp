#pragma once

// Define the macro to handle symbol visibility
#ifdef _WIN32
    #ifdef EXTERNAL_PERIPHERAL_EXPORTS
        // If building the library on Windows
        #define EXTERNAL_PERIPHERAL_API __declspec(dllexport)
    #else
        // If consuming the library on Windows
        #define EXTERNAL_PERIPHERAL_API __declspec(dllimport)
    #endif
#else
    // If building or consuming the library on Linux or other platforms
    #define EXTERNAL_PERIPHERAL_API
#endif


#include <cstdint>
#include <memory>
#include <functional>
#include <unordered_set>

namespace zero_mate
{
    class EXTERNAL_PERIPHERAL_API IExternal_Peripheral
    {
    public:
        using Set_GPIO_Pin_t = std::function<void(int, bool)>;
        using Read_GPIO_Pin_t = std::function<bool(int)>;

    public:
        IExternal_Peripheral() = default;

        virtual ~IExternal_Peripheral() = default;
        IExternal_Peripheral(const IExternal_Peripheral&) = delete;
        IExternal_Peripheral& operator=(const IExternal_Peripheral&) = delete;
        IExternal_Peripheral(IExternal_Peripheral&&) = delete;
        IExternal_Peripheral& operator=(IExternal_Peripheral&&) = delete;

        [[nodiscard]] const std::unordered_set<std::uint32_t>& Get_GPIO_Subscription() const
        {
            return m_gpio_subscription;
        }

        [[maybe_unused]] virtual void GPIO_Subscription_Callback([[maybe_unused]] std::uint32_t pin_idx)
        {
        }

        [[nodiscard]] virtual bool Implements_GUI() const noexcept
        {
            return false;
        }

    protected:
        std::unordered_set<std::uint32_t> m_gpio_subscription{};
    };
}

extern "C"
{
    EXTERNAL_PERIPHERAL_API
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const std::string& name,
                          const std::vector<std::uint32_t>& gpio_pins,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          [[maybe_unused]] [[maybe_unused]] zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);
}