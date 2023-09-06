#include "fpexc.hpp"

namespace zero_mate::coprocessor::cp10
{
    CFPEXC::CFPEXC()
    : m_value{ 0 }
    {
    }

    CFPEXC& CFPEXC::operator=(std::uint32_t value)
    {
        m_value = value;
        return *this;
    }

    bool CFPEXC::Is_Enabled() const noexcept
    {
        return static_cast<bool>((m_value >> static_cast<std::uint32_t>(NFlags::EN)) & 0b1U);
    }
}