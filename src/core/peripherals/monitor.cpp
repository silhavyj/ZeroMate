// ---------------------------------------------------------------------------------------------------------------------
/// \file monitor.cpp
/// \date 28. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements an 80x25 8-bit memory-mapped monitor which is used as a debug output.
/// \note This peripheral is not included in BCM2835
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <algorithm>
/// \endcond

// Project file imports

#include "monitor.hpp"

namespace zero_mate::peripheral
{
    CMonitor::CMonitor()
    {
        Reset();
    }

    std::uint32_t CMonitor::Get_Size() const noexcept
    {
        return SIZE;
    }

    void CMonitor::Reset() noexcept
    {
        m_data = std::string(SIZE, DEFAULT_CHARACTER);
    }

    void CMonitor::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        // Write data to the monitor.
        std::copy_n(data, size, &std::bit_cast<char*>(m_data.data())[addr]);
    }

    void CMonitor::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        // Read data from the monitor.
        std::copy_n(&std::bit_cast<char*>(m_data.data())[addr], size, data);
    }

    const std::string& CMonitor::Get_Data() const
    {
        return m_data;
    }

} // namespace zero_mate::peripheral