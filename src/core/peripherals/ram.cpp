// ---------------------------------------------------------------------------------------------------------------------
/// \file ram.cpp
/// \date 28. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the RAM (random access memory) used in BCM2835.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <cassert>
#include <algorithm>
#include <execution>
/// \endcond

// Project file imports

#include "ram.hpp"

namespace zero_mate::peripheral
{
    CRAM::CRAM(std::uint32_t size)
    : m_size{ size }
    {
        // Init the RAM.
        Init();
    }

    CRAM::CRAM(std::uint32_t size, std::uint32_t addr, const std::vector<std::uint32_t>& instructions)
    : m_size{ size }
    {
        // Make sure the content fits into the RAM.
        assert((instructions.size() / sizeof(std::uint32_t)) < (size - addr));

        // Init the RAM.
        Init();

        // Write the content to the RAM (word by word).
        for (const auto& instruction : instructions)
        {
            Write(addr, std::bit_cast<const char*>(&instruction), sizeof(std::uint32_t));
            addr += sizeof(std::uint32_t);
        }
    }

    void CRAM::Reset() noexcept
    {
        // Clear out the content of the RAM.
        std::fill_n(std::execution::par, m_data.get(), m_size, 0);
    }

    std::uint32_t CRAM::Get_Size() const noexcept
    {
        return m_size;
    }

    void CRAM::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        // Write data to the RAM.
        std::copy_n(data, size, &m_data[addr]);
    }

    void CRAM::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        // Read data from the RAM.
        std::copy_n(&m_data[addr], size, data);
    }

    char* CRAM::Get_Raw_Data() const
    {
        return m_data.get();
    }

    void CRAM::Init()
    {
        // Allocate space on the heap (RAII fashion)
        m_data = std::unique_ptr<char[]>(new (std::nothrow) char[m_size]);

        // Make sure the allocation did not fail.
        assert(m_data != nullptr);

        Reset();
    }

} // namespace zero_mate::peripheral