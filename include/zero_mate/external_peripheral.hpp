#pragma once

#include <string>
#include <cstdint>
#include <memory>
#include <functional>
#include <unordered_set>

#ifdef _WIN32
    #ifdef WIN_EXPORT
        #define EXPORTED  __declspec( dllexport )
    #else
        #define EXPORTED  __declspec( dllimport )
    #endif
#else
    #define EXPORTED
#endif

namespace zero_mate
{
    class EXPORTED IExternal_Peripheral
    {
    public:
        using Set_GPIO_Pin_t = std::function<int(std::uint32_t , bool)>;
        using Read_GPIO_Pin_t = std::function<bool(std::uint32_t)>;

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

        virtual void Render()
        {
        }

    protected:
        std::unordered_set<std::uint32_t> m_gpio_subscription{};
    };
}

extern "C"
{
    EXPORTED int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                                   const std::string& name,
                                   const std::vector<std::uint32_t>& gpio_pins,
                                   [[maybe_unused]] zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                                   [[maybe_unused]] zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);
}