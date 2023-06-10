// ---------------------------------------------------------------------------------------------------------------------
/// \file trng.cpp
/// \date 10. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the TRNG (random number generator) used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// http://home.zcu.cz/~ublm/files/os/bcm2835_trng_doc.html
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <algorithm>
/// \endcond

// Project file imports

#include "trng.hpp"

namespace zero_mate::peripheral
{
    CTRNG::CTRNG()
    : m_regs{}
    {
        Reset();
    }

    std::uint32_t CTRNG::Get_Size() const noexcept
    {
        return static_cast<std::uint32_t>(sizeof(m_regs));
    }

    void CTRNG::Reset() noexcept
    {
        // Clear out all registers.
        std::fill(m_regs.begin(), m_regs.end(), 0);
    }

    void CTRNG::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        // Write data to the peripheral's registers.
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);
    }

    void CTRNG::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        // If the user reads from the data register, insert there a random number
        // before the register is read from.
        if (reg_type == NRegister::Data && Is_Enabled())
        {
            m_regs[static_cast<std::uint32_t>(NRegister::Data)] = m_uniform_dist(m_rand_dev);
        }

        // Simplification - the random generator is always ready to be read from (one number at a time).
        // See status register over at http://home.zcu.cz/~ublm/files/os/bcm2835_trng_doc.html
        m_regs[static_cast<std::uint32_t>(NRegister::Status)] = (1U << 24U);

        // Read data from the peripheral's registers.
        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);
    }

    bool CTRNG::Is_Enabled() const
    {
        // The 0th bit of the control register indicates whether the generator is enabled or disabled.
        return static_cast<bool>(m_regs[static_cast<std::uint32_t>(NRegister::Control)] & 0b1U);
    }

} // namespace zero_mate::peripheral