#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <string>
/// \endcond

#include "peripheral.hpp"

namespace zero_mate::peripheral
{
    class CMonitor final : public IPeripheral
    {
    public:
        static constexpr std::uint32_t WIDTH = 80;
        static constexpr std::uint32_t HEIGHT = 25;
        static constexpr std::uint32_t SIZE = WIDTH * HEIGHT;

        CMonitor();

        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

        const std::string& Get_Data() const;

    private:
        std::string m_data;
    };
}