#include <bit>

#include <fmt/format.h>
#include <magic_enum.hpp>

#include "arm_timer.hpp"
#include "../utils/singleton.hpp"

namespace zero_mate::peripheral
{
    const std::unordered_set<CARM_Timer::NRegister> CARM_Timer::s_read_only_registers = {
        CARM_Timer::NRegister::Value,
        CARM_Timer::NRegister::IRQ_Raw,
        CARM_Timer::NRegister::IRQ_Masked
    };

    const std::unordered_set<CARM_Timer::NRegister> CARM_Timer::s_write_only_registers = {
        NRegister::IRQ_Clear
    };

    CARM_Timer::CPrescaler::CPrescaler()
    : m_limit{ NPrescal_Bits::Prescale_None }
    , m_counter{ 0 }
    {
    }

    void CARM_Timer::CPrescaler::Set_Limit(zero_mate::peripheral::CARM_Timer::NPrescal_Bits limit)
    {
        m_limit = limit;
    }

    std::uint32_t CARM_Timer::CPrescaler::Update_Counter(std::uint32_t limit_value)
    {
        std::uint32_t prescaled_cycles_passed{};

        if (m_counter >= limit_value)
        {
            prescaled_cycles_passed = m_counter / limit_value;
            m_counter = m_counter % limit_value;
        }

        return prescaled_cycles_passed;
    }

    uint32_t CARM_Timer::CPrescaler::Prescale_Cycle_Passed(std::uint32_t cycles_passed) noexcept
    {
        m_counter += cycles_passed;

        switch (m_limit)
        {
            case NPrescal_Bits::Prescale_None:
                [[fallthrough]];
            case NPrescal_Bits::Prescale_1:
                m_counter = 0;
                break;

            case NPrescal_Bits::Prescale_16:
                cycles_passed = Update_Counter(static_cast<std::uint32_t>(NPrescal_Values::Prescale_16));
                break;

            case NPrescal_Bits::Prescale_256:
                cycles_passed = Update_Counter(static_cast<std::uint32_t>(NPrescal_Values::Prescale_256));
                break;
        }

        return cycles_passed;
    }

    CARM_Timer::CARM_Timer(std::shared_ptr<CInterrupt_Controller> interrupt_controller)
    : m_interrupt_controller{ interrupt_controller }
    , m_regs{}
    , m_prescaler{}
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
        // clang-format off
        Get_Reg(NRegister::Control) = std::bit_cast<std::uint32_t>(TControl_Register{
            .Unused_0               = 0b0U,
            .Counter_32b            = 0b1U,
            .Prescaler              = 0b00,
            .Unused_1               = 0b0U,
            .Interrupt_Enabled      = 0b0U,
            .Unused_2               = 0b0U,
            .Timer_Enabled          = 0b0U,
            .Halt_In_Debug_Break    = 0b0U,
            .Free_Running           = 0b0U,
            .Unused_3               = 0b000000U,
            .Free_Running_Prescaler = 0b0000'0000U,
            .Unused_4               = 0b0000'0000U
        });
        // clang-format on
    }

    void CARM_Timer::Timer_Has_Reached_Zero(const TControl_Register& control_reg)
    {
        Get_Reg(NRegister::Value) = 0;
        Get_Reg(NRegister::IRQ_Raw) = 1;

        if (control_reg.Interrupt_Enabled)
        {
            Get_Reg(NRegister::IRQ_Masked) = 1;
            m_interrupt_controller->Signalize_Basic_IRQ(CInterrupt_Controller::NIRQ_Basic_Source::ARM_Timer);
        }

        if (control_reg.Free_Running)
        {
            Get_Reg(NRegister::Free_Running) += 1;
        }

        Get_Reg(NRegister::Value) = Get_Reg(NRegister::Reload);
    }

    void CARM_Timer::Increment_Passed_Cycles(std::uint32_t count)
    {
        const auto control_reg = Get_Control_Reg();

        if (!control_reg.Timer_Enabled)
        {
            return;
        }

        m_prescaler.Set_Limit(static_cast<NPrescal_Bits>(control_reg.Prescaler));

        count = m_prescaler.Prescale_Cycle_Passed(count);

        // 32b vs 16b mode
        const auto value = control_reg.Counter_32b ? Get_Reg(NRegister::Value) : (Get_Reg(NRegister::Value) & 0xFFFFU);

        if (count > 0)
        {
            if (count >= value)
            {
                Timer_Has_Reached_Zero(control_reg);
            }
            else
            {
                Get_Reg(NRegister::Value) = value - count;
            }
        }
    }

    std::uint32_t CARM_Timer::Get_Reg(NRegister reg) const
    {
        return m_regs[static_cast<std::uint32_t>(reg)];
    }

    CARM_Timer::TControl_Register CARM_Timer::Get_Control_Reg() const
    {
        return std::bit_cast<TControl_Register>(Get_Reg(NRegister::Control));
    }

    std::uint32_t& CARM_Timer::Get_Reg(NRegister reg)
    {
        return m_regs[static_cast<std::uint32_t>(reg)];
    }

    std::uint32_t CARM_Timer::Get_Size() const noexcept
    {
        return static_cast<std::uint32_t>(sizeof(m_regs));
    }

    void CARM_Timer::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        if (s_read_only_registers.contains(reg_type))
        {
            m_logging_system.Warning(fmt::format("The ARM timer {} register is read-only", magic_enum::enum_name(reg_type)).c_str());
            return;
        }

        switch (reg_type)
        {
            case NRegister::Load:
                Get_Reg(NRegister::Value) = Get_Reg(NRegister::Load);
                Get_Reg(NRegister::Reload) = Get_Reg(NRegister::Load);
                break;

            case NRegister::IRQ_Clear:
                Clear_Basic_IRQ();
                break;

            case NRegister::Value:
                [[fallthrough]];
            case NRegister::IRQ_Raw:
            case NRegister::IRQ_Masked:
            case NRegister::Control:
            case NRegister::Reload:
            case NRegister::Pre_Divider:
            case NRegister::Free_Running:
            default:
                break;
        }
    }

    void CARM_Timer::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        if (s_write_only_registers.contains(reg_type))
        {
            m_logging_system.Warning(fmt::format("The ARM timer {} register is write-only", magic_enum::enum_name(reg_type)).c_str());
            return;
        }

        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);
    }

    inline void CARM_Timer::Clear_Basic_IRQ()
    {
        if (Get_Reg(NRegister::IRQ_Clear) == 1U)
        {
            m_interrupt_controller->Clear_Pending_Basic_IRQ(CInterrupt_Controller::NIRQ_Basic_Source::ARM_Timer);

            Get_Reg(NRegister::IRQ_Clear) = 0;
            Get_Reg(NRegister::IRQ_Raw) = 0;
            Get_Reg(NRegister::IRQ_Masked) = 0;
        }
    }
}