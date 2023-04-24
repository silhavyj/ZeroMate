#include <fmt/format.h>
#include <magic_enum.hpp>

#include "interrupt_controller.hpp"
#include "../utils/math.hpp"
#include "../utils/singleton.hpp"

namespace zero_mate::peripheral
{
    CInterrupt_Controller::CInterrupt_Controller(const arm1176jzf_s::CCPU_Context& cpu_context)
    : m_cpu_context{ cpu_context }
    , m_regs{}
    , m_irq_pending{ false }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
        Initialize();
    }

    void CInterrupt_Controller::Initialize()
    {
        Initialize_IRQ_Basic_Sources();
        Initialize_IRQ_Sources();
    }

    void CInterrupt_Controller::Initialize_IRQ_Basic_Sources()
    {
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
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        switch (reg_type)
        {
            case NRegister::IRQ_Basic_Pending:
                // TODO
                break;

            case NRegister::Enable_Basic_IRQs:
                Update_IRQ_Basic_Sources(reg_type, true);
                break;

            case NRegister::Disable_Basic_IRQs:
                Update_IRQ_Basic_Sources(reg_type, false);
                break;

            case NRegister::IRQ_Pending_1:
                [[fallthrough]];
            case NRegister::IRQ_Pending_2:
                break;

            case NRegister::Enable_IRQs_1:
                [[fallthrough]];
            case NRegister::Enable_IRQs_2:
                Update_IRQ_Sources(reg_type, true);
                break;

            case NRegister::Disable_IRQs_1:
                [[fallthrough]];
            case NRegister::Disable_IRQs_2:
                Update_IRQ_Sources(reg_type, false);
                break;

            case NRegister::FIQ_Control:
                // TODO
                break;

            default:
                break;
        }
    }

    void CInterrupt_Controller::Update_IRQ_Basic_Sources(NRegister reg, bool enable)
    {
        const auto reg_idx = static_cast<std::size_t>(reg);

        for (auto& [source, state] : m_irq_basic_sources)
        {
            if (utils::math::Is_Bit_Set(m_regs[reg_idx], static_cast<std::uint32_t>(source)))
            {
                state.enabled = enable;
                m_logging_system.Debug(fmt::format("Basic IRQ source {} has been {}", magic_enum::enum_name(source), enable ? "enabled" : "disabled").c_str());
            }
        }

        m_regs[reg_idx] = 0; // RS flip flop
    }

    void CInterrupt_Controller::Update_IRQ_Sources(NRegister reg, bool enable)
    {
        const auto reg_idx = static_cast<std::size_t>(reg);

        for (auto& [source, state] : m_irq_sources)
        {
            auto source_bit_idx = static_cast<std::uint32_t>(source);

            if ((source_bit_idx >= 32U && (reg == NRegister::Disable_IRQs_1 || reg == NRegister::Enable_IRQs_1)) ||
                (source_bit_idx <= 31U && (reg == NRegister::Disable_IRQs_2 || reg == NRegister::Enable_IRQs_2)))
            {
                continue;
            }

            if (source_bit_idx >= 32U)
            {
                source_bit_idx -= 32U;
            }

            if (utils::math::Is_Bit_Set(m_regs[reg_idx], source_bit_idx))
            {
                state.enabled = enable;
                m_logging_system.Debug(fmt::format("IRQ source {} has been {}", magic_enum::enum_name(source), enable ? "enabled" : "disabled").c_str());
            }
        }

        m_regs[reg_idx] = 0; // RS flip flop
    }

    void CInterrupt_Controller::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / REG_SIZE;
        std::copy_n(&m_regs[reg_idx], size, data);
    }

    bool CInterrupt_Controller::Is_IRQ_Source_Enabled(NIRQ_Source source) const
    {
        if (source == NIRQ_Source::GPIO_0 || source == NIRQ_Source::GPIO_1 || source == NIRQ_Source::GPIO_2)
        {
            if (m_irq_sources.at(NIRQ_Source::GPIO_3).enabled)
            {
                return true;
            }
        }

        return m_irq_sources.at(source).enabled;
    }

    void CInterrupt_Controller::Signalize_IRQ(NIRQ_Source source)
    {
        if (m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::I) || !Is_IRQ_Source_Enabled(source))
        {
            return;
        }

        auto source_bit_idx = static_cast<std::uint32_t>(source);
        const auto reg_idx = static_cast<std::size_t>(source_bit_idx >= 32U ? NRegister::IRQ_Pending_2 : NRegister::IRQ_Pending_1);

        if (source_bit_idx >= 32U)
        {
            source_bit_idx -= 32U;
        }

        m_regs[reg_idx] |= (1U << source_bit_idx);
        m_irq_sources[source].pending = true;
        m_irq_pending = true;

        m_logging_system.Debug(fmt::format("IRQ {} has been signalized", magic_enum::enum_name(source)).c_str());
    }

    void CInterrupt_Controller::Signalize_Basic_IRQ(NIRQ_Basic_Source source)
    {
        if (m_cpu_context.Is_Flag_Set(arm1176jzf_s::CCPU_Context::NFlag::I) || !m_irq_basic_sources[source].enabled)
        {
            return;
        }

        const auto reg_idx = static_cast<std::size_t>(NRegister::IRQ_Basic_Pending);
        const auto source_bit_idx = static_cast<std::size_t>(source);

        m_regs[reg_idx] |= (1U << source_bit_idx);
        m_irq_basic_sources[source].pending = true;
        m_irq_pending = true;

        m_logging_system.Debug(fmt::format("Basic IRQ {} has been signalized", magic_enum::enum_name(source)).c_str());
    }

    bool CInterrupt_Controller::Has_Pending_IRQ() const noexcept
    {
        return m_irq_pending;
    }

    void CInterrupt_Controller::Clear_Pending_IRQ() noexcept
    {
        m_irq_pending = false;
    }

    CInterrupt_Controller::NIRQ_Source CInterrupt_Controller::Get_IRQ_Source(std::size_t pin_idx) noexcept
    {
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
}