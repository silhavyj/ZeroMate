#pragma once

#include <bit>
#include <array>
#include <vector>
#include <cstdint>
#include <cassert>
#include <concepts>
#include <algorithm>

#include "peripheral.hpp"

namespace zero_mate::peripheral
{
    static constexpr std::uint32_t RAM_SIZE = 256 * 1024 * 1024;

    template<std::uint32_t Size = RAM_SIZE>
    class CRAM final : public IPeripheral
    {
    public:
        CRAM()
        {
            Init_Data();
        }

        CRAM(std::uint32_t addr, const std::vector<std::uint32_t>& instructions)
        {
            assert((instructions.size() / sizeof(std::uint32_t)) < (Size - addr));

            Init_Data();

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
            std::copy_n(data, size, &m_data[addr]);
        }

        void Read(std::uint32_t addr, char* data, std::uint32_t size) override
        {
            std::copy_n(&m_data[addr], size, data);
        }

        void Write_Callback([[maybe_unused]] std::uint32_t addr) override
        {
        }

        char* Get_Raw_Data() const
        {
            return m_data.get();
        }

    private:
        void Init_Data()
        {
            m_data = std::unique_ptr<char[]>(new (std::nothrow) char[Size]);
            assert(m_data != nullptr);
            std::fill_n(m_data.get(), Size, 0);
        }

        std::unique_ptr<char[]> m_data{ nullptr };
    };
}