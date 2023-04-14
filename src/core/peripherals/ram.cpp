#include <cassert>
#include <algorithm>

#include "ram.hpp"

namespace zero_mate::peripheral
{
    CRAM::CRAM(std::uint32_t size)
    : m_size{ size }
    {
        Init();
    }

    CRAM::CRAM(std::uint32_t size, std::uint32_t addr, const std::vector<std::uint32_t>& instructions)
    : m_size{ size }
    {
        assert((instructions.size() / sizeof(std::uint32_t)) < (size - addr));

        Init();

        for (const auto& instruction : instructions)
        {
            Write(addr, std::bit_cast<const char*>(&instruction), sizeof(std::uint32_t));
            addr += sizeof(std::uint32_t);
        }
    }

    std::uint32_t CRAM::Get_Size() const noexcept
    {
        return m_size;
    }

    void CRAM::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        std::copy_n(data, size, &m_data[addr]);
    }

    void CRAM::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        std::copy_n(&m_data[addr], size, data);
    }

    char* CRAM::Get_Raw_Data() const
    {
        return m_data.get();
    }

    void CRAM::Init()
    {
        m_data = std::unique_ptr<char[]>(new (std::nothrow) char[m_size]);
        assert(m_data != nullptr);
        std::fill_n(m_data.get(), m_size, 0);
    }
}