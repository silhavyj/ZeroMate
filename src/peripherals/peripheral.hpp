#pragma once

#include <cstdint>

namespace zero_mate::peripheral
{
    class IPeripheral
    {
    public:
        IPeripheral() = default;
        virtual ~IPeripheral() = default;

        IPeripheral(const IPeripheral&) = delete;
        IPeripheral& operator=(const IPeripheral&) = delete;
        IPeripheral(IPeripheral&&) = delete;
        IPeripheral& operator=(IPeripheral&&) = delete;

        [[nodiscard]] virtual std::uint32_t Get_Size() const noexcept = 0;
        virtual void Write(std::uint32_t addr, const char* data, std::uint32_t size) = 0;
        virtual void Read(std::uint32_t addr, char* data, std::uint32_t size) = 0;
        virtual void Write_Callback(std::uint32_t addr) = 0;
    };

}