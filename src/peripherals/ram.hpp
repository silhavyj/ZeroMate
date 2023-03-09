#pragma once

#include <bit>
#include <array>
#include <vector>
#include <cstdint>
#include <cassert>
#include <concepts>

#include "peripheral.hpp"

namespace zero_mate::peripheral
{
    template<std::uint32_t Size>
    class CRAM final : public IPeripheral
    {
    public:
        CRAM() = default;

        CRAM(std::uint32_t addr, const std::vector<std::uint32_t>& instructions)
        {
            assert((instructions.size() / sizeof(std::uint32_t)) < Size);

            for (const auto& instruction : instructions)
            {
                Write(addr, std::bit_cast<const char*>(&instruction), sizeof(std::uint32_t));
                addr += sizeof(std::uint32_t);
            }
        }

        [[nodiscard]] std::uint32_t Get_Size() const noexcept override
        {
            return Size;
        }

        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override
        {
            for (std::size_t i = 0; i < size; ++i)
            {
                m_data[addr] = data[i];
                ++addr;
            }
        }

        void Read(std::uint32_t addr, char* data, std::uint32_t size) override
        {
            for (std::size_t i = 0; i < size; ++i)
            {
                data[i] = m_data[addr];
                ++addr;
            }
        }

        void Write_Callback([[maybe_unused]] std::uint32_t addr) override
        {
        }

    private:
        std::array<char, Size> m_data{};
    };
}