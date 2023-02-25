#pragma once

#include <bit>
#include <array>
#include <vector>
#include <cassert>
#include <numeric>
#include <cstdint>
#include <concepts>
#include <algorithm>

namespace zero_mate::arm1176jzf_s::mocks
{
    class CRAM final
    {
    public:
        static constexpr std::size_t SIZE = 1024;

    private:
        using RAM_t = std::array<std::uint8_t, SIZE>;

    public:
        CRAM() = default;

        CRAM(std::uint32_t addr, const std::vector<std::uint32_t>& instructions)
        {
            assert((instructions.size() / sizeof(uint32_t)) < SIZE);

            for (const auto& instruction : instructions)
            {
                Write<std::uint32_t>(addr, instruction);
                addr += sizeof(std::uint32_t);
            }
        }

        template<std::unsigned_integral Type>
        Type Read(std::uint32_t addr)
        {
            Type value{};

            for (std::size_t byte_idx = 0; byte_idx < sizeof(Type); ++byte_idx)
            {
                value |= static_cast<Type>((static_cast<Type>(m_ram[addr]) << ((sizeof(Type) - byte_idx - 1) * std::numeric_limits<std::uint8_t>::digits)));
                ++addr;
            }

            return value;
        }

        template<std::unsigned_integral Type>
        void Write(std::uint32_t addr, Type value)
        {
            using byte_array_t = std::array<std::uint8_t, sizeof(Type)>;
            const auto bytes = std::bit_cast<byte_array_t, Type>(value);
            const auto last_addr = addr + sizeof(Type) - 1;
            std::uint32_t byte_idx{ 0 };

            for (const auto& byte : bytes)
            {
                m_ram[last_addr - byte_idx] = byte;
                ++addr;
                ++byte_idx;
            }
        }

    private:
        RAM_t m_ram{};
    };
}