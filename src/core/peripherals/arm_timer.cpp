#include <bit>

#include "arm_timer.hpp"

namespace zero_mate::peripheral
{
    CARM_Timer::CPrescaler::CPrescaler()
    : m_limit{ NPrescal_Bits::Prescale_None }
    , m_counter{ 0 }
    {
    }

    void CARM_Timer::CPrescaler::Set_Limit(zero_mate::peripheral::CARM_Timer::NPrescal_Bits limit)
    {
        m_limit = limit;
    }

    uint32_t CARM_Timer::CPrescaler::Prescale_Cycle_Passed(std::uint32_t cycles_passed) noexcept
    {
        m_counter += cycles_passed;

        const auto Update = [this](std::uint32_t limit_value) -> std::uint32_t {
            std::uint32_t prescaled_cycles_passed{};

            if (m_counter >= limit_value)
            {
                prescaled_cycles_passed = m_counter / limit_value;
                m_counter = m_counter % limit_value;
            }

            return prescaled_cycles_passed;
        };

        switch (m_limit)
        {
            case NPrescal_Bits::Prescale_None:
                [[fallthrough]];
            case NPrescal_Bits::Prescale_1:
                m_counter = 0;
                break;

            case NPrescal_Bits::Prescale_16:
                cycles_passed = Update(static_cast<std::uint32_t>(NPrescal_Values::Prescale_16));
                break;

            case NPrescal_Bits::Prescale_256:
                cycles_passed = Update(static_cast<std::uint32_t>(NPrescal_Values::Prescale_256));
                break;
        }

        return cycles_passed;
    }

    CARM_Timer::CARM_Timer(std::shared_ptr<CInterrupt_Controller> interrupt_controller)
    : m_interrupt_controller{ interrupt_controller }
    , m_prescaler{}
    {
    }

    void CARM_Timer::Update(std::uint32_t cycles_passed)
    {
        const auto control_reg = std::bit_cast<TControl_Register>(Get_Reg(NRegister::Control));

        if (!control_reg.Timer_Enabled)
        {
            return;
        }

        cycles_passed = m_prescaler.Prescale_Cycle_Passed(cycles_passed);

        if (cycles_passed > 0)
        {
            const auto value = Get_Reg(NRegister::Value);

            if (cycles_passed >= value)
            {
                Get_Reg(NRegister::Value) = 0;

                if (control_reg.Interrupt_Enabled)
                {
                    m_interrupt_controller->Signalize_Basic_IRQ(CInterrupt_Controller::NIRQ_Basic_Source::ARM_Timer);
                }

                if (control_reg.Free_Running)
                {
                    Init_Value_Register();
                }
            }
            else
            {
                Get_Reg(NRegister::Value) = value - cycles_passed;
            }
        }
    }

    const std::uint32_t& CARM_Timer::Get_Reg(NRegister reg) const
    {
        return m_regs[static_cast<std::uint32_t>(reg)];
    }

    std::uint32_t& CARM_Timer::Get_Reg(NRegister reg)
    {
        return m_regs[static_cast<std::uint32_t>(reg)];
    }

    std::uint32_t CARM_Timer::Get_Size() const noexcept
    {
        return static_cast<std::uint32_t>(sizeof(m_regs));
    }

    void CARM_Timer::Init_Value_Register()
    {
        Get_Reg(NRegister::Value) = Get_Reg(NRegister::Load);
    }

    void CARM_Timer::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        switch (reg_type)
        {
            case NRegister::Load:
                Init_Value_Register();
                break;

            case NRegister::Value:
                break;

            case NRegister::Control:
                break;

            case NRegister::IRQ_Clear:
                Clear_Basic_IRQ();
                break;

            case NRegister::IRQ_Raw:
                break;

            case NRegister::IRQ_Masked:
                break;

            case NRegister::Reload:
                break;

            case NRegister::Pre_Divider:
                break;

            case NRegister::Free_Running:
                break;

            default:
                break;
        }
    }

    void CARM_Timer::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / REG_SIZE;
        std::copy_n(&m_regs[reg_idx], size, data);
    }

    inline void CARM_Timer::Clear_Basic_IRQ()
    {
        if (Get_Reg(NRegister::IRQ_Clear) == 1U)
        {
            m_interrupt_controller->Clear_Pending_Basic_IRQ(CInterrupt_Controller::NIRQ_Basic_Source::ARM_Timer);
            Get_Reg(NRegister::IRQ_Clear) = 0;
        }
    }
}