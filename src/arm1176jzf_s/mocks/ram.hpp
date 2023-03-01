#pragma once

#include <bit>
#include <array>
#include <vector>
#include <cassert>
#include <numeric>
#include <cstdint>
#include <concepts>

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
            assert((instructions.size() / sizeof(std::uint32_t)) < SIZE);

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

            const std::size_t size = sizeof(Type);

            for (std::size_t idx = 0; idx < size; ++idx)
            {
                const auto byte = static_cast<Type>(m_ram.at(addr + idx)) << (idx * std::numeric_limits<std::uint8_t>::digits);
                value |= static_cast<Type>(byte);
            }

            return value;
        }

        template<std::unsigned_integral Type>
        void Write(std::uint32_t addr, Type value)
        {
            using byte_array_t = std::array<std::uint8_t, sizeof(Type)>;

            auto bytes = std::bit_cast<byte_array_t, Type>(value);

            for (const auto& byte : bytes)
            {
                m_ram[addr] = byte;
                ++addr;
            }
        }

    private:
        RAM_t m_ram{};
    };
}