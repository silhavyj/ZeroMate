#include "cpsr.hpp"

namespace zero_mate::arm1176jzf_s
{
    CCPSR::CCPSR(uint32_t value) noexcept
    : m_value{ value }
    {
    }

    void CCPSR::Set_Flag(NFlag flag, bool set) noexcept
    {
        if (set)
        {
            m_value |= static_cast<std::uint32_t>(flag);
        }
        else
        {
            m_value &= ~static_cast<std::uint32_t>(flag);
        }
    }

    bool CCPSR::Is_Flag_Set(NFlag flag) const noexcept
    {
        return static_cast<bool>(m_value & static_cast<std::uint32_t>(flag));
    }

    void CCPSR::Set_CPU_Mode(NCPU_Mode mode) noexcept
    {
        m_value &= ~(CPU_MODE_MASK);
        m_value |= static_cast<std::uint32_t>(mode);
    }

    CCPSR::NCPU_Mode CCPSR::Get_CPU_Mode() const noexcept
    {
        return static_cast<NCPU_Mode>(m_value & CPU_MODE_MASK);
    }
}