#include <fmt/format.h>
#include <magic_enum.hpp>

#include "gpio.hpp"
#include "../utils/math.hpp"
#include "../utils/singleton.hpp"

namespace zero_mate::peripheral
{
    const std::unordered_set<CGPIO_Manager::NRegister> CGPIO_Manager::s_read_only_registers = {
        CGPIO_Manager::NRegister::GPLEV0,
        CGPIO_Manager::NRegister::GPLEV1
    };

    const std::unordered_set<CGPIO_Manager::NRegister> CGPIO_Manager::s_write_only_registers = {
        CGPIO_Manager::NRegister::GPSET0,
        CGPIO_Manager::NRegister::GPSET1,
        CGPIO_Manager::NRegister::GPCLR0,
        CGPIO_Manager::NRegister::GPCLR1
    };

    CGPIO_Manager::CPin::CPin()
    : m_state{ NState::Low }
    , m_function{ NFunction::Input }
    , m_enabled_interrupts{}
    , m_pending_irq{ false }
    {
    }

    CGPIO_Manager::CPin::NFunction CGPIO_Manager::CPin::Get_Function() const noexcept
    {
        return m_function;
    }

    void CGPIO_Manager::CPin::Set_Function(NFunction function) noexcept
    {
        m_function = function;
    }

    CGPIO_Manager::CPin::NState CGPIO_Manager::CPin::Get_State() const noexcept
    {
        return m_state;
    }

    void CGPIO_Manager::CPin::Set_State(NState state) noexcept
    {
        m_state = state;
    }

    bool CGPIO_Manager::CPin::Has_Pending_IRQ() const noexcept
    {
        return m_pending_irq;
    }

    void CGPIO_Manager::CPin::Set_Pending_IRQ(bool set)
    {
        m_pending_irq = set;
    }

    void CGPIO_Manager::CPin::Enable_Interrupt_Type(NInterrupt_Type type)
    {
        m_enabled_interrupts[static_cast<std::size_t>(type)] = true;
    }

    void CGPIO_Manager::CPin::Disable_Interrupt_Type(NInterrupt_Type type)
    {
        m_enabled_interrupts[static_cast<std::size_t>(type)] = false;
    }

    bool CGPIO_Manager::CPin::Is_Interrupt_Enabled(NInterrupt_Type type) const
    {
        return m_enabled_interrupts[static_cast<std::size_t>(type)];
    }

    bool CGPIO_Manager::CPin::Interrupt_Detected(NState new_state) const noexcept
    {
        if (Is_Interrupt_Enabled(CPin::NInterrupt_Type::Rising_Edge) && Get_State() == CPin::NState::Low && new_state == CPin::NState::High)
        {
            return true;
        }
        if (Is_Interrupt_Enabled(CPin::NInterrupt_Type::Falling_Edge) && Get_State() == CPin::NState::High && new_state == CPin::NState::Low)
        {
            return true;
        }
        if (Is_Interrupt_Enabled(CPin::NInterrupt_Type::Low) && new_state == NState::Low)
        {
            return true;
        }
        if (Is_Interrupt_Enabled(CPin::NInterrupt_Type::High) && new_state == NState::High)
        {
            return true;
        }

        return false;
    }

    CGPIO_Manager::CGPIO_Manager(std::shared_ptr<CInterrupt_Controller> interrupt_controller) noexcept
    : m_regs{}
    , m_pins{}
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_interrupt_controller{ interrupt_controller }
    {
    }

    std::uint32_t CGPIO_Manager::Get_Size() const noexcept
    {
        return static_cast<std::uint32_t>(sizeof(m_regs));
    }

    void CGPIO_Manager::Update_Pin_Function(std::size_t reg_idx, bool last_reg)
    {
        static constexpr std::size_t NUMBER_OF_PINS_IN_SEL_REG = 10;
        static constexpr std::size_t LAST_BIT_INDEX = (NUMBER_OF_PINS_IN_REG / NUMBER_OF_PINS_IN_SEL_REG) * NUMBER_OF_PINS_IN_SEL_REG;

        const std::uint32_t last_bit_idx = last_reg ? 12 : LAST_BIT_INDEX;

        for (std::uint32_t idx = 0; idx < last_bit_idx; idx += 3)
        {
            const auto function = static_cast<CPin::NFunction>((m_regs[reg_idx] >> idx) & 0b111U);

            const auto pin_idx = (reg_idx * NUMBER_OF_PINS_IN_SEL_REG) + idx / 3;

            if (m_pins[pin_idx].Get_Function() != function)
            {
                m_logging_system.Debug(fmt::format("Function of pin {} is set to {}", pin_idx, magic_enum::enum_name(function)).c_str());
            }

            m_pins[pin_idx].Set_Function(function);
        }
    }

    void CGPIO_Manager::Update_Pin_State(std::size_t reg_idx, CPin::NState state, bool last_reg)
    {
        const std::uint32_t last_bit_idx = last_reg ? (NUMBER_OF_GPIO_PINS - NUMBER_OF_PINS_IN_REG) : NUMBER_OF_PINS_IN_REG;

        for (std::uint32_t idx = 0; idx < last_bit_idx; ++idx)
        {
            const auto pin_idx = last_reg ? (NUMBER_OF_PINS_IN_REG + idx) : idx;

            if (utils::math::Is_Bit_Set(m_regs[reg_idx], idx))
            {
                if (m_pins[pin_idx].Get_Function() == CPin::NFunction::Output)
                {
                    if (m_pins[pin_idx].Get_State() != state)
                    {
                        m_logging_system.Debug(fmt::format("State of pin {} is set to {}", pin_idx, magic_enum::enum_name(state)).c_str());
                    }

                    m_pins[pin_idx].Set_State(state);
                    Reflect_Pin_State_In_GPLEVn(pin_idx, state);
                }
                else
                {
                    m_logging_system.Warning(fmt::format("Cannot change the state of pin {} as its function has not been to output", pin_idx).c_str());
                }
            }
        }

        m_regs[reg_idx] = 0; // Only the last write sets the state of the PIN (RS flip-flop)
    }

    std::size_t CGPIO_Manager::Get_Register_Index(std::size_t& pin_idx, NRegister reg_0, NRegister reg_1) noexcept
    {
        if (pin_idx >= NUMBER_OF_PINS_IN_REG)
        {
            pin_idx -= NUMBER_OF_PINS_IN_REG;
            return static_cast<std::size_t>(reg_1);
        }

        return static_cast<std::size_t>(reg_0);
    }

    void CGPIO_Manager::Reflect_Pin_State_In_GPLEVn(std::size_t pin_idx, CPin::NState state)
    {
        const auto reg_index = Get_Register_Index(pin_idx, NRegister::GPLEV0, NRegister::GPLEV1);
        auto& GPLEVn_reg = m_regs[reg_index];

        if (state == CPin::NState::High)
        {
            GPLEVn_reg |= (0b1U << pin_idx);
        }
        else
        {
            GPLEVn_reg &= ~(0b1U << pin_idx);
        }
    }

    void CGPIO_Manager::Set_Interrupt(std::size_t reg_idx, bool last_reg, CPin::NInterrupt_Type type)
    {
        const std::uint32_t last_bit_idx = last_reg ? (NUMBER_OF_GPIO_PINS - NUMBER_OF_PINS_IN_REG) : NUMBER_OF_PINS_IN_REG;

        for (std::uint32_t idx = 0; idx < last_bit_idx; ++idx)
        {
            const auto pin_idx = last_reg ? (NUMBER_OF_PINS_IN_REG + idx) : idx;

            if (utils::math::Is_Bit_Set(m_regs[reg_idx], idx))
            {
                if (!m_pins[pin_idx].Is_Interrupt_Enabled(type))
                {
                    m_logging_system.Debug(fmt::format("Interrupt {} has been enabled on pin {}", magic_enum::enum_name(type), pin_idx).c_str());
                }
                m_pins[pin_idx].Enable_Interrupt_Type(type);
            }
            else
            {
                if (m_pins[pin_idx].Is_Interrupt_Enabled(type))
                {
                    m_logging_system.Debug(fmt::format("Interrupt {} has been disabled on pin {}", magic_enum::enum_name(type), pin_idx).c_str());
                }
                m_pins[pin_idx].Disable_Interrupt_Type(type);
            }
        }
    }

    void CGPIO_Manager::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        if (s_read_only_registers.contains(reg_type))
        {
            m_logging_system.Warning(fmt::format("The GPIO {} register is read-only", magic_enum::enum_name(reg_type)).c_str());
            return;
        }

        switch (reg_type)
        {
            case NRegister::GPFSEL0:
                [[fallthrough]];
            case NRegister::GPFSEL1:
            case NRegister::GPFSEL2:
            case NRegister::GPFSEL3:
            case NRegister::GPFSEL4:
            case NRegister::GPFSEL5:
                Update_Pin_Function(reg_idx, reg_type == NRegister::GPFSEL5);
                break;

            case NRegister::GPSET0:
                [[fallthrough]];
            case NRegister::GPSET1:
                Update_Pin_State(reg_idx, CPin::NState::High, reg_type == NRegister::GPSET1);
                break;

            case NRegister::GPCLR0:
                [[fallthrough]];
            case NRegister::GPCLR1:
                Update_Pin_State(reg_idx, CPin::NState::Low, reg_type == NRegister::GPCLR1);
                break;

            case NRegister::GPLEV0:
                [[fallthrough]];
            case NRegister::GPLEV1:
                // These registers reflect the actual state of each PIN
                // The corresponding bits are set/cleared whenever a pin changes its state
                break;

            case NRegister::GPEDS0:
                [[fallthrough]];
            case NRegister::GPEDS1:
                Clear_IRQ(reg_idx, reg_type == NRegister::GPEDS1);
                break;

            case NRegister::GPREN0:
                [[fallthrough]];
            case NRegister::GPREN1:
                Set_Interrupt(reg_idx, reg_type == NRegister::GPREN1, CPin::NInterrupt_Type::Rising_Edge);
                break;

            case NRegister::GPHEN0:
                [[fallthrough]];
            case NRegister::GPHEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister::GPHEN1, CPin::NInterrupt_Type::High);
                break;

            case NRegister::GPLEN0:
                [[fallthrough]];
            case NRegister::GPLEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister::GPLEN1, CPin::NInterrupt_Type::Low);
                break;

            case NRegister::Reserved_01:
                [[fallthrough]];
            case NRegister::Reserved_02:
            case NRegister::Reserved_03:
            case NRegister::Reserved_04:
            case NRegister::Reserved_05:
            case NRegister::Reserved_06:
            case NRegister::Reserved_07:
            case NRegister::Reserved_08:
            case NRegister::Reserved_09:
            case NRegister::Reserved_10:
            case NRegister::Reserved_11:
            case NRegister::Reserved_12:
                break;

            case NRegister::GPFEN0:
                [[fallthrough]];
            case NRegister::GPFEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister::GPFEN1, CPin::NInterrupt_Type::Falling_Edge);
                break;

            default:
                // TODO add the rest of the registers
                break;
        }
    }

    void CGPIO_Manager::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        if (s_write_only_registers.contains(reg_type))
        {
            m_logging_system.Warning(fmt::format("The GPIO {} register is write-only", magic_enum::enum_name(reg_type)).c_str());
            return;
        }

        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);
    }

    const CGPIO_Manager::CPin& CGPIO_Manager::Get_Pin(std::size_t idx) const
    {
        return m_pins.at(idx);
    }

    CGPIO_Manager::NPin_Set_Status CGPIO_Manager::Set_Pin_State(std::size_t pin_idx, CPin::NState state)
    {
        if (pin_idx >= NUMBER_OF_GPIO_PINS)
        {
            return NPin_Set_Status::Invalid_Pin_Number;
        }

        auto& pin = m_pins[pin_idx];

        // TODO there might be exceptions such as the Alt_x functions?
        if (pin.Get_Function() != CPin::NFunction::Input)
        {
            return NPin_Set_Status::Not_Input_Pin;
        }

        if (pin.Get_State() == state)
        {
            return NPin_Set_Status::State_Already_Set;
        }

        const bool interrupt_detected = pin.Interrupt_Detected(state);

        pin.Set_State(state);
        Reflect_Pin_State_In_GPLEVn(pin_idx, state);

        if (interrupt_detected)
        {
            pin.Set_Pending_IRQ(true);
            const auto irq_source = CInterrupt_Controller::Get_IRQ_Source(pin_idx);
            m_interrupt_controller->Signalize_IRQ(irq_source);
        }

        return NPin_Set_Status::OK;
    }

    void CGPIO_Manager::Clear_IRQ(std::size_t reg_idx, bool last_reg)
    {
        const std::uint32_t last_bit_idx = last_reg ? (NUMBER_OF_GPIO_PINS - NUMBER_OF_PINS_IN_REG) : NUMBER_OF_PINS_IN_REG;

        for (std::uint32_t idx = 0; idx < last_bit_idx; ++idx)
        {
            const auto pin_idx = last_reg ? (NUMBER_OF_PINS_IN_REG + idx) : idx;
            auto& pin = m_pins[pin_idx];

            if (utils::math::Is_Bit_Set(m_regs[reg_idx], idx) && pin.Has_Pending_IRQ())
            {
                pin.Set_Pending_IRQ(false);
                const auto irq_source = CInterrupt_Controller::Get_IRQ_Source(pin_idx);
                m_interrupt_controller->Clear_Pending_IRQ(irq_source);

                m_logging_system.Debug(fmt::format("Pending interrupt on GPIO pin {} has been cleared", pin_idx).c_str());
            }
        }

        m_regs[reg_idx] = 0;
    }
}
