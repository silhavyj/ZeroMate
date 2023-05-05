#include <bit>
#include <algorithm>

#include "monitor.hpp"

namespace zero_mate::peripheral
{
    CMonitor::CMonitor()
    : m_data(SIZE, '0')
    {
    }

    std::uint32_t CMonitor::Get_Size() const noexcept
    {
        return SIZE;
    }

    void CMonitor::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        std::copy_n(data, size, &std::bit_cast<char*>(m_data.data())[addr]);
    }

    void CMonitor::Read([[maybe_unused]] std::uint32_t addr,
                        [[maybe_unused]] char* data,
                        [[maybe_unused]] std::uint32_t size)
    {
    }

    const std::string& CMonitor::Get_Data() const
    {
        return m_data;
    }
}