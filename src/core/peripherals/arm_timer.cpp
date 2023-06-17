// ---------------------------------------------------------------------------------------------------------------------
/// \file arm_timer.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the ARM timer used in BCM2835 as defined in arm_timer.hpp.
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 14)
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <algorithm>
/// \endcond

// 3rd party library includes

#include <fmt/format.h>
#include <magic_enum.hpp>

// Project file imports

#include "arm_timer.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::peripheral
{
    // clang-format off
    const std::unordered_set<CARM_Timer::NRegister> CARM_Timer::s_read_only_registers = {
        CARM_Timer::NRegister::Value,
        CARM_Timer::NRegister::IRQ_Raw,
        CARM_Timer::NRegister::IRQ_Masked
    };

    const std::unordered_set<CARM_Timer::NRegister> CARM_Timer::s_write_only_registers = {
        NRegister::IRQ_Clear
    };
    // clang-format on

    CARM_Timer::CPrescaler::CPrescaler()
    {
        Reset();
    }

    void CARM_Timer::CPrescaler::Reset() noexcept
    {
        m_counter = 0;
        m_limit = NPrescal_Bits::Prescale_None;
    }

    void CARM_Timer::CPrescaler::Set_Limit(zero_mate::peripheral::CARM_Timer::NPrescal_Bits limit)
    {
        m_limit = limit;
    }

    std::uint32_t CARM_Timer::CPrescaler::operator()(std::uint32_t cycles_passed) noexcept
    {
        // Increment the internal counter.
        m_counter += cycles_passed;

        switch (m_limit)
        {
            // No prescaling is taking place.
            case NPrescal_Bits::Prescale_None:
                [[fallthrough]];
            case NPrescal_Bits::Prescale_1:
                m_counter = 0;
                break;

            // Prescale the frequency by 16.
            case NPrescal_Bits::Prescale_16:
                cycles_passed = Update_Counter(static_cast<std::uint32_t>(NPrescal_Values::Prescale_16));
                break;

            // Prescale the frequency by 256.
            case NPrescal_Bits::Prescale_256:
                cycles_passed = Update_Counter(static_cast<std::uint32_t>(NPrescal_Values::Prescale_256));
                break;
        }

        // Return the number of prescaled cycles.
        return cycles_passed;
    }

    std::uint32_t CARM_Timer::CPrescaler::Update_Counter(std::uint32_t limit_value)
    {
        std::uint32_t prescaled_cycles_passed{};

        // The threshold has been reached.
        if (m_counter >= limit_value)
        {
            // Check how many times the threshold has been reached.
            prescaled_cycles_passed = m_counter / limit_value;

            // Update the internal counter.
            m_counter = m_counter % limit_value;
        }

        // Return the number of prescaled cycles.
        return prescaled_cycles_passed;
    }

    CARM_Timer::CARM_Timer(std::shared_ptr<CInterrupt_Controller> interrupt_controller)
    : m_interrupt_controller{ interrupt_controller }
    , m_prescaler{}
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
        Reset();
    }

    void CARM_Timer::Timer_Has_Reached_Zero(const TControl_Register& control_reg)
    {
        // Set the IRQ_Raw to a 1 regardless of interrupts being enabled or disabled.
        // It gets cleared when a 1 is written to IRQ_Clear.
        Get_Reg(NRegister::IRQ_Raw) = 1;

        // Check if the interrupts are enabled.
        if (control_reg.Interrupt_Enabled)
        {
            // Notify the interrupt controller about a pending IRQ.
            // It gets cleared when a 1 is written to IRQ_Clear.
            Get_Reg(NRegister::IRQ_Masked) = 1;
            m_interrupt_controller->Signalize_Basic_IRQ(CInterrupt_Controller::NIRQ_Basic_Source::ARM_Timer);
        }

        // If free-running is enabled, increment the Free_Running register.
        if (control_reg.Free_Running)
        {
            Get_Reg(NRegister::Free_Running) += 1;
        }

        // Restart the counter (reload the default value).
        Get_Reg(NRegister::Value) = Get_Reg(NRegister::Reload);
    }

    void CARM_Timer::Increment_Passed_Cycles(std::uint32_t count)
    {
        const auto control_reg = Get_Control_Reg();

        // Make sure the ARM timer has been enabled.
        if (!control_reg.Timer_Enabled)
        {
            return;
        }

        // Prescale the number of passed CPU cycles.
        count = m_prescaler(count);

        // Set the threshold of the prescaler.
        m_prescaler.Set_Limit(static_cast<NPrescal_Bits>(control_reg.Prescaler));

        // 32b vs 16b mode
        const auto value = control_reg.Counter_32b ? Get_Reg(NRegister::Value) : (Get_Reg(NRegister::Value) & 0xFFFFU);

        // Make sure at least one prescaled CPU cycles has passed by.
        if (count > 0)
        {
            // Check for an underflow.
            if (count >= value)
            {
                // The timer has reached 0.
                Timer_Has_Reached_Zero(control_reg);
            }
            else
            {
                // Update the value by subtracting the amount of prescaled CPU cycles from it.
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

    void CARM_Timer::Reset() noexcept
    {
        m_prescaler.Reset();
        std::fill(m_regs.begin(), m_regs.end(), 0);

        // Set up default settings of the timer.
        // clang-format off
        Get_Reg(NRegister::Control) = std::bit_cast<std::uint32_t>(TControl_Register{
            .Unused_0               = 0b0U,
            .Counter_32b            = 0b1U, // 32-bit mode
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

    void CARM_Timer::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        // An attempt to write to a read-only register
        if (s_read_only_registers.contains(reg_type))
        {
            // clang-format off
            m_logging_system.Warning(fmt::format("The ARM timer {} register is read-only",
                                                 magic_enum::enum_name(reg_type)).c_str());
            // clang-format on

            return;
        }

        // Write data to the peripheral's registers.
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

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

            default: // Not all register are currently being used (count).
                break;
        }
    }

    void CARM_Timer::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        // An attempt to read from a write-only register.
        if (s_write_only_registers.contains(reg_type))
        {
            // clang-format off
            m_logging_system.Warning(fmt::format("The ARM timer {} register is write-only",
                                                 magic_enum::enum_name(reg_type)).c_str());
            // clang-format on

            return;
        }

        // Read data from the peripheral's registers.
        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);
    }

    inline void CARM_Timer::Clear_Basic_IRQ()
    {
        // Check if 1 has been written to IRQ_Clear.
        if (Get_Reg(NRegister::IRQ_Clear) == 1U)
        {
            // Tell the interrupt control that there is no longer a pending IRQ.
            m_interrupt_controller->Clear_Pending_Basic_IRQ(CInterrupt_Controller::NIRQ_Basic_Source::ARM_Timer);

            // Clear the registers.
            Get_Reg(NRegister::IRQ_Clear) = 0;
            Get_Reg(NRegister::IRQ_Raw) = 0;
            Get_Reg(NRegister::IRQ_Masked) = 0;
        }
    }

} // namespace zero_mate::peripheral