#include "fpscr.hpp"

namespace zero_mate::coprocessor::cp10
{
    CFPSCR::CFPSCR()
    : m_value{ 0 }
    {
    }

    CFPSCR& CFPSCR::operator=(std::uint32_t value)
    {
        m_value = value;
        return *this;
    }

    bool CFPSCR::Is_Flag_Set(NFlag flag) const noexcept
    {
        return static_cast<bool>(m_value & static_cast<std::uint32_t>(flag));
    }

    std::uint32_t CFPSCR::Get_Value() const noexcept
    {
        return m_value;
    }

    void CFPSCR::Set_Flag(NFlag flag, bool set)
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
}