// ---------------------------------------------------------------------------------------------------------------------
/// \file interrupt_controller.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the interrupt controller used in BCM2835 (defined in interrupt_controller.hpp).
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 7)
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <algorithm>
/// \endcond

// 3rd party library includes

#include <fmt/format.h>
#include <magic_enum.hpp>

// Project file imports

#include "interrupt_controller.hpp"
#include "zero_mate/utils/math.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::peripheral
{
    CInterrupt_Controller::CInterrupt_Controller(const arm1176jzf_s::CCPU_Context& cpu_context)
    : m_cpu_context{ cpu_context }
    , m_regs{}
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
        Reset();
    }

    void CInterrupt_Controller::Reset() noexcept
    {
        // Clear the contents of the registers.
        std::fill(m_regs.begin(), m_regs.end(), 0);

        Initialize_Basic_IRQ_Sources();
        Initialize_IRQ_Sources();
    }

    void CInterrupt_Controller::Initialize_Basic_IRQ_Sources()
    {
        // Initialize basic IRQ sources (enable = false, pending = false).
        m_irq_basic_sources[NIRQ_Basic_Source::ARM_Timer] = {};
        m_irq_basic_sources[NIRQ_Basic_Source::ARM_Mailbox] = {};
        m_irq_basic_sources[NIRQ_Basic_Source::ARM_Doorbell_0] = {};
        m_irq_basic_sources[NIRQ_Basic_Source::ARM_Doorbell_1] = {};
        m_irq_basic_sources[NIRQ_Basic_Source::GPU_0_Halted] = {};
        m_irq_basic_sources[NIRQ_Basic_Source::GPU_1_Halted] = {};
        m_irq_basic_sources[NIRQ_Basic_Source::Illegal_Access_Type_1] = {};
        m_irq_basic_sources[NIRQ_Basic_Source::Illegal_Access_Type_0] = {};
    }

    void CInterrupt_Controller::Initialize_IRQ_Sources()
    {
        // Initialize IRQ sources (enable = false, pending = false).
        m_irq_sources[NIRQ_Source::AUX] = {};
        m_irq_sources[NIRQ_Source::I2C_SPI_SLV] = {};
        m_irq_sources[NIRQ_Source::PWA_0] = {};
        m_irq_sources[NIRQ_Source::PWA_1] = {};
        m_irq_sources[NIRQ_Source::SMI] = {};
        m_irq_sources[NIRQ_Source::GPIO_0] = {};
        m_irq_sources[NIRQ_Source::GPIO_1] = {};
        m_irq_sources[NIRQ_Source::GPIO_2] = {};
        m_irq_sources[NIRQ_Source::GPIO_3] = {};
        m_irq_sources[NIRQ_Source::I2C] = {};
        m_irq_sources[NIRQ_Source::SPI] = {};
        m_irq_sources[NIRQ_Source::PCM] = {};
        m_irq_sources[NIRQ_Source::UART] = {};
    }

    std::uint32_t CInterrupt_Controller::Get_Size() const noexcept
    {
        return static_cast<std::uint32_t>(sizeof(m_regs));
    }

    void CInterrupt_Controller::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        // Write data into the peripheral's register.
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        switch (reg_type)
        {
            // Enable basic IRQs.
            case NRegister::Enable_Basic_IRQs:
                Enable_IRQ_Basic_Sources(reg_type, true);
                break;

            // Disable basic IRQs.
            case NRegister::Disable_Basic_IRQs:
                Enable_IRQ_Basic_Sources(reg_type, false);
                break;

            // Enable IRQs.
            case NRegister::Enable_IRQs_1:
                [[fallthrough]];
            case NRegister::Enable_IRQs_2:
                Enable_IRQ_Sources(reg_type, true);
                break;

            // Disable IRQs.
            case NRegister::Disable_IRQs_1:
                [[fallthrough]];
            case NRegister::Disable_IRQs_2:
                Enable_IRQ_Sources(reg_type, false);
                break;

            // TODO pending interrupts can be cleared directly in the IC (not via the peripheral)?
            case NRegister::IRQ_Basic_Pending:
                [[fallthrough]];
            case NRegister::IRQ_Pending_1:
            case NRegister::IRQ_Pending_2:
                break;

            // TODO the emulator does not support this yet.
            case NRegister::FIQ_Control:
                break;

            default: // Not all register are currently being used (count).
                break;
        }
    }

    void CInterrupt_Controller::Enable_IRQ_Basic_Sources(NRegister reg, bool enable)
    {
        const auto reg_idx = static_cast<std::size_t>(reg);

        // Iterate through individual bits of the register.
        for (auto& [source, state] : m_irq_basic_sources)
        {
            // Is the bit set? => interrupts should be enabled/disabled for the corresponding source.
            if (utils::math::Is_Bit_Set(m_regs[reg_idx], static_cast<std::uint32_t>(source)))
            {
                // Enable/disable interrupts generated by the source.
                state.enabled = enable;

                // clang-format off
                m_logging_system.Debug(fmt::format("Basic IRQ source {} has been {}",
                                                   magic_enum::enum_name(source),
                                                   enable ? "enabled" : "disabled").c_str());
                // clang-format on
            }
        }

        // RS latch - only the last write defines the next state (SW emulation).
        m_regs[reg_idx] = 0;
    }

    void CInterrupt_Controller::Enable_IRQ_Sources(NRegister reg, bool enable)
    {
        const auto reg_idx = static_cast<std::size_t>(reg);

        // Iterate through individual bits of the register.
        for (auto& [source, state] : m_irq_sources)
        {
            auto source_bit_idx = static_cast<std::uint32_t>(source);

            // Make sure we do not use the wrong register.
            if ((source_bit_idx >= 32U && (reg == NRegister::Disable_IRQs_1 || reg == NRegister::Enable_IRQs_1)) ||
                (source_bit_idx <= 31U && (reg == NRegister::Disable_IRQs_2 || reg == NRegister::Enable_IRQs_2)))
            {
                continue;
            }

            // Adjust the index (relative position within the register).
            if (source_bit_idx >= 32U)
            {
                source_bit_idx -= 32U;
            }

            // Is the bit set? => interrupts should be enabled/disabled for the corresponding source.
            if (utils::math::Is_Bit_Set(m_regs[reg_idx], source_bit_idx))
            {
                // Enable/disable interrupts generated by the source.
                state.enabled = enable;

                // clang-format off
                m_logging_system.Debug(fmt::format("IRQ source {} has been {}",
                                                   magic_enum::enum_name(source),
                                                   enable ? "enabled" : "disabled").c_str());
                // clang-format on
            }
        }

        // RS latch - only the last write defines the next state (SW emulation).
        m_regs[reg_idx] = 0;
    }

    void CInterrupt_Controller::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        // Read data from the peripheral's register.
        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);
    }

    bool CInterrupt_Controller::Is_IRQ_Source_Enabled(NIRQ_Source source) const
    {
        // The GPIO banks have to be checked separately because GPIO_3 enables interrupts from all GPIO pins.
        if (source == NIRQ_Source::GPIO_0 || source == NIRQ_Source::GPIO_1 || source == NIRQ_Source::GPIO_2)
        {
            // If GPIO_3 is NOT enabled, GPIO_0-2 may still be enabled - check at the end of this function.
            if (m_irq_sources.at(NIRQ_Source::GPIO_3).enabled)
            {
                return true;
            }
        }

        // Check if the given source is enabled.
        return m_irq_sources.at(source).enabled;
    }

    void CInterrupt_Controller::Signalize_IRQ(NIRQ_Source source)
    {
        // Check if interrupts are enabled globally and the IRQ source is enabled as well.
        if (m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::I) || !Is_IRQ_Source_Enabled(source))
        {
            return;
        }

        // Get the bit index corresponding to the IRQ source.
        auto source_bit_idx = static_cast<std::uint32_t>(source);

        // Calculate the register index.
        const auto reg_idx =
        static_cast<std::size_t>(source_bit_idx >= 32U ? NRegister::IRQ_Pending_2 : NRegister::IRQ_Pending_1);

        // Adjust the index (relative position within the register).
        if (source_bit_idx >= 32U)
        {
            source_bit_idx -= 32U;
        }

        // Set the corresponding bit in the IRQ pending register.
        m_regs[reg_idx] |= (1U << source_bit_idx);
        m_irq_sources[source].pending = true;

        m_logging_system.Debug(fmt::format("IRQ {} has been signalized", magic_enum::enum_name(source)).c_str());
    }

    void CInterrupt_Controller::Signalize_Basic_IRQ(NIRQ_Basic_Source source)
    {
        // Check if interrupts are enabled globally and the basic IRQ source is enabled as well.
        if (m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::I) || !m_irq_basic_sources[source].enabled)
        {
            return;
        }

        // Get the bit index corresponding to the basic IRQ source.
        const auto source_bit_idx = static_cast<std::size_t>(source);
        const auto reg_idx = static_cast<std::size_t>(NRegister::IRQ_Basic_Pending);

        // Set the corresponding bit in the basic IRQ pending register.
        m_regs[reg_idx] |= (1U << source_bit_idx);
        m_irq_basic_sources[source].pending = true;

        m_logging_system.Debug(fmt::format("Basic IRQ {} has been signalized", magic_enum::enum_name(source)).c_str());
    }

    bool CInterrupt_Controller::Has_Pending_IRQ() const
    {
        // Check if any of the IRQ sources has a pending interrupt.
        return std::ranges::any_of(m_irq_sources, [](const auto& source) -> bool { return source.second.pending; });
    }

    bool CInterrupt_Controller::Has_Pending_Basic_IRQ() const
    {
        // Check if any of the basic IRQ sources has a pending interrupt.
        return std::ranges::any_of(m_irq_basic_sources,
                                   [](const auto& source) -> bool { return source.second.pending; });
    }

    bool CInterrupt_Controller::Has_Pending_Interrupt() const noexcept
    {
        // 1. Interrupts must be enabled globally
        // 2. Either basic IRQs or IRQs must have a pending interrupt
        return !m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::I) &&
               (Has_Pending_Basic_IRQ() || Has_Pending_IRQ());
    }

    void CInterrupt_Controller::Clear_Pending_Basic_IRQ(NIRQ_Basic_Source source) noexcept
    {
        m_irq_basic_sources[source].pending = false;
    }

    void CInterrupt_Controller::Clear_Pending_IRQ(NIRQ_Source source) noexcept
    {
        m_irq_sources[source].pending = false;
    }

    const std::unordered_map<CInterrupt_Controller::NIRQ_Basic_Source, CInterrupt_Controller::TInterrupt_Info>&
    CInterrupt_Controller::Get_Basic_IRQs() const
    {
        return m_irq_basic_sources;
    }

    const std::unordered_map<CInterrupt_Controller::NIRQ_Source, CInterrupt_Controller::TInterrupt_Info>&
    CInterrupt_Controller::Get_IRQs() const
    {
        return m_irq_sources;
    }

    CInterrupt_Controller::NIRQ_Source CInterrupt_Controller::Get_IRQ_Source(std::size_t pin_idx) noexcept
    {
        // https://raspberrypi.stackexchange.com/questions/51737/use-of-gpio-interrupt-2-rather-than-interrupt-3

        if (pin_idx <= 27U)
        {
            return NIRQ_Source::GPIO_0;
        }
        else if (pin_idx <= 45U)
        {
            return NIRQ_Source::GPIO_1;
        }

        return NIRQ_Source::GPIO_2;
    }

} // namespace zero_mate::peripheral