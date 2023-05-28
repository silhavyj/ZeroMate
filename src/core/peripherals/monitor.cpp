// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <algorithm>
/// \endcond
/// \endcond

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

    void CMonitor::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        std::copy_n(&std::bit_cast<char*>(m_data.data())[addr], size, data);
    }

    const std::string& CMonitor::Get_Data() const
    {
        return m_data;
    }
}