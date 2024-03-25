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
    , m_seed{ m_uniform_dist(m_rand_dev) }
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
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        // If the user reads from the data register, insert there a random number
        // before the register is read from.
        if (reg_type == NRegister::Data && Is_Enabled())
        {
            m_regs[static_cast<std::uint32_t>(NRegister::Data)] = Get_Rnd_Number();
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

    std::uint32_t CTRNG::Get_Rnd_Number()
    {
#if (USE_REAL_RND_NUMBER_GENERATOR == 1)
        return m_uniform_dist(m_rand_dev);
#else
        // More info about the algorithm: https://youtu.be/5_RAHZQCPjE?t=613

        static std::uint32_t seed = m_seed;

        const std::uint32_t state = seed * 747796405U + 2891336453U;
        const std::uint32_t word = ((state >> ((state >> 28U) + 4U)) ^ state) * 277803737U;
        seed = (word >> 22U) ^ word;

        return seed;
#endif
    }

} // namespace zero_mate::peripheral