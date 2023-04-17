#include "context.hpp"

namespace zero_mate::arm1176jzf_s
{
    CCPU_Context::CCPU_Context()
    : m_mode{ NCPU_Mode::Supervisor }
    , m_regs{}
    {
        Init_Registers();

        Enable_IRQ(false);
        Enable_FIQ(false);
    }

    inline void CCPU_Context::Init_Registers()
    {
        Init_FIQ_Banked_Regs();
        Init_IRQ_Banked_Regs();
        Init_Supervisor_Banked_Regs();
        Init_Undefined_Banked_Regs();
        Init_Abort_Banked_Regs();

        Init_CPSR();
        Init_SPSR();
    }

    void CCPU_Context::Enable_IRQ(bool set)
    {
        Set_Flag(m_cpsr[m_mode], NFlag::I, !set);
    }

    void CCPU_Context::Enable_FIQ(bool set)
    {
        Set_Flag(m_cpsr[m_mode], NFlag::F, !set);
    }

    void CCPU_Context::Init_FIQ_Banked_Regs()
    {
        for (std::uint32_t idx = 8; idx <= 14; ++idx)
        {
            m_banked_regs[NCPU_Mode::FIQ][idx] = { 0 };
        }
    }

    void CCPU_Context::Init_IRQ_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::IRQ][13] = { 0 };
        m_banked_regs[NCPU_Mode::IRQ][14] = { 0 };
    }

    void CCPU_Context::Init_Supervisor_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::Supervisor][13] = { 0 };
        m_banked_regs[NCPU_Mode::Supervisor][14] = { 0 };
    }

    void CCPU_Context::Init_Undefined_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::Undefined][13] = { 0 };
        m_banked_regs[NCPU_Mode::Undefined][14] = { 0 };
    }

    void CCPU_Context::Init_Abort_Banked_Regs()
    {
        m_banked_regs[NCPU_Mode::Abort][13] = { 0 };
        m_banked_regs[NCPU_Mode::Abort][14] = { 0 };
    }

    inline void CCPU_Context::Init_CPSR()
    {
        m_cpsr[NCPU_Mode::User] = { static_cast<std::uint32_t>(NCPU_Mode::User) };
        m_cpsr[NCPU_Mode::FIQ] = { static_cast<std::uint32_t>(NCPU_Mode::FIQ) };
        m_cpsr[NCPU_Mode::IRQ] = { static_cast<std::uint32_t>(NCPU_Mode::IRQ) };
        m_cpsr[NCPU_Mode::Supervisor] = { static_cast<std::uint32_t>(NCPU_Mode::Supervisor) };
        m_cpsr[NCPU_Mode::Abort] = { static_cast<std::uint32_t>(NCPU_Mode::Abort) };
        m_cpsr[NCPU_Mode::Undefined] = { static_cast<std::uint32_t>(NCPU_Mode::Undefined) };
        m_cpsr[NCPU_Mode::System] = { static_cast<std::uint32_t>(NCPU_Mode::System) };
    }

    inline void CCPU_Context::Init_SPSR()
    {
        m_spsr[NCPU_Mode::User] = { 0 };
        m_spsr[NCPU_Mode::FIQ] = { 0 };
        m_spsr[NCPU_Mode::IRQ] = { 0 };
        m_spsr[NCPU_Mode::Supervisor] = { 0 };
        m_spsr[NCPU_Mode::Abort] = { 0 };
        m_spsr[NCPU_Mode::Undefined] = { 0 };
        m_spsr[NCPU_Mode::System] = { 0 };
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

    std::uint32_t CCPU_Context::Get_CPSR() const
    {
        return m_cpsr.at(m_mode);
    }

    void CCPU_Context::Set_CPSR(std::uint32_t value)
    {
        Set_CPU_Mode(Get_CPU_Mode(value));

        value &= ~CPU_MODE_MASK;
        value |= static_cast<std::uint32_t>(Get_CPU_Mode());

        m_cpsr[m_mode] = value;
    }

    std::uint32_t CCPU_Context::Get_SPSR() const
    {
        return m_spsr.at(m_mode);
    }

    void CCPU_Context::Set_SPSR(std::uint32_t value)
    {
        m_spsr[m_mode] = value;
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
        if (m_mode == mode)
        {
            return;
        }

        m_spsr[m_mode] = m_cpsr[m_mode];
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

    CCPU_Context::NCPU_Mode CCPU_Context::Get_CPU_Mode(std::uint32_t cpsr) noexcept
    {
        return static_cast<NCPU_Mode>(cpsr & 0b11111U);
    }
}