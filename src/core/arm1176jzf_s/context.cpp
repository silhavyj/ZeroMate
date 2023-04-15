#include "context.hpp"

namespace zero_mate::arm1176jzf_s
{
    CCPU_Context::CCPU_Context()
    : m_mode{ DEFAULT_CPU_MODE }
    , m_regs{}
    {
        m_cpsr[NCPU_Mode::User] = { 0 };
        m_cpsr[NCPU_Mode::System] = { 0 };

        Init_FIQ_Banked_Regs();
        Init_IRQ_Banked_Regs();
        Init_Supervisor_Banked_Regs();
        Init_Undefined_Banked_Regs();
        Init_Abort_Banked_Regs();
    }

    inline void CCPU_Context::Init_FIQ_Banked_Regs()
    {
        for (std::uint32_t idx = 8; idx <= 14; ++idx)
        {
            m_banked_regs[NCPU_Mode::FIQ][idx] = { 0 };
        }

        m_cpsr[NCPU_Mode::FIQ] = { 0 };
    }

    inline void CCPU_Context::Init_IRQ_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::IRQ][13] = { 0 };
        m_banked_regs[NCPU_Mode::IRQ][14] = { 0 };

        m_cpsr[NCPU_Mode::IRQ] = { 0 };
    }

    inline void CCPU_Context::Init_Supervisor_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::Supervisor][13] = { 0 };
        m_banked_regs[NCPU_Mode::Supervisor][14] = { 0 };

        m_cpsr[NCPU_Mode::Supervisor] = { 0 };
    }

    inline void CCPU_Context::Init_Undefined_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::Undefined][13] = { 0 };
        m_banked_regs[NCPU_Mode::Undefined][14] = { 0 };

        m_cpsr[NCPU_Mode::Undefined] = { 0 };
    }

    inline void CCPU_Context::Init_Abort_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::Abort][13] = { 0 };
        m_banked_regs[NCPU_Mode::Abort][14] = { 0 };

        m_cpsr[NCPU_Mode::Abort] = { 0 };
    }

    const std::uint32_t& CCPU_Context::operator[](std::uint32_t idx) const
    {
        if (m_banked_regs.contains(m_mode) && m_banked_regs.at(m_mode).contains(idx))
        {
            return m_banked_regs.at(m_mode).at(idx);
        }

        return m_regs.at(idx);
    }

    std::uint32_t& CCPU_Context::operator[](std::uint32_t idx)
    {
        if (m_banked_regs.contains(m_mode) && m_banked_regs.at(m_mode).contains(idx))
        {
            return m_banked_regs[m_mode][idx];
        }

        return m_regs[idx];
    }

    void CCPU_Context::Set_Flag(NFlag flag, bool set) noexcept
    {
        Set_Flag(m_cpsr[m_mode], flag, set);
    }

    bool CCPU_Context::Is_Flag_Set(NFlag flag) const noexcept
    {
        return Is_Flag_Set(m_cpsr.at(m_mode), flag);
    }

    void CCPU_Context::Set_CPU_Mode(NCPU_Mode mode) noexcept
    {
        m_mode = mode;
    }

    CCPU_Context::NCPU_Mode CCPU_Context::Get_CPU_Mode() const noexcept
    {
        return m_mode;
    }

    void CCPU_Context::Set_Flag(std::uint32_t& cpsr, NFlag flag, bool set) noexcept
    {
        if (set)
        {
            cpsr |= static_cast<std::uint32_t>(flag);
        }
        else
        {
            cpsr &= ~static_cast<std::uint32_t>(flag);
        }
    }

    bool CCPU_Context::Is_Flag_Set(std::uint32_t cpsr, NFlag flag) noexcept
    {
        return static_cast<bool>(cpsr & static_cast<std::uint32_t>(flag));
    }
}