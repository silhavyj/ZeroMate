#pragma once

#include <bit>
#include <array>
#include <vector>
#include <memory>
#include <cstdint>

#include "peripheral.hpp"

namespace zero_mate::peripheral
{
    class CRAM final : public IPeripheral
    {
    public:
        explicit CRAM(std::uint32_t size);
        explicit CRAM(std::uint32_t size, std::uint32_t addr, const std::vector<std::uint32_t>& instructions);

        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;
        [[nodiscard]] char* Get_Raw_Data() const;

    private:
        void Init();

        std::uint32_t m_size;
        std::unique_ptr<char[]> m_data{ nullptr };
    };
}