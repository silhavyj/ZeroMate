#include <fmt/format.h>
#include <magic_enum.hpp>

#include "../utils/singleton.hpp"
#include "gpio.hpp"

namespace zero_mate::peripheral
{
    CGPIO_Manager::CPin::CPin()
    : m_state{ NState::Low }
    , m_function{ NFunction::Input }
    , m_enabled_interrupts{}
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

    void CGPIO_Manager::CPin::Add_Interrupt_Type(NInterrupt_Type type)
    {
        m_enabled_interrupts[static_cast<std::size_t>(type)] = true;
    }

    void CGPIO_Manager::CPin::Remove_Interrupt_Type(NInterrupt_Type type)
    {
        m_enabled_interrupts[static_cast<std::size_t>(type)] = false;
    }

    bool CGPIO_Manager::CPin::Is_Interrupt_Enabled(NInterrupt_Type type) const
    {
        return m_enabled_interrupts[static_cast<std::size_t>(type)];
    }

    CGPIO_Manager::CGPIO_Manager() noexcept
    : m_regs{}
    , m_pins{}
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
    }

    std::uint32_t CGPIO_Manager::Get_Size() const noexcept
    {
        return static_cast<std::uint32_t>(sizeof(m_regs)) - REG_SIZE;
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
            const auto set_bit = static_cast<bool>((m_regs[reg_idx] >> idx) & 0b1U);
            const auto pin_idx = last_reg ? (NUMBER_OF_PINS_IN_REG + idx) : idx;

            if (set_bit)
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

    void CGPIO_Manager::Reflect_Pin_State_In_GPLEVn(std::size_t pin_idx, CPin::NState state)
    {
        const std::size_t reg_index = [&]() -> std::uint32_t {
            if (pin_idx >= NUMBER_OF_PINS_IN_REG)
            {
                pin_idx -= NUMBER_OF_PINS_IN_REG;
                return static_cast<std::size_t>(NRegister::GPLEV1);
            }

            return static_cast<std::size_t>(NRegister::GPLEV0);
        }();

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
            const auto set_bit = static_cast<bool>((m_regs[reg_idx] >> idx) & 0b1U);
            const auto pin_idx = last_reg ? (NUMBER_OF_PINS_IN_REG + idx) : idx;

            if (set_bit)
            {
                m_pins[pin_idx].Add_Interrupt_Type(type);
                m_logging_system.Debug(fmt::format("Interrupt number {} has been enabled on pin {}", static_cast<std::uint32_t>(type), pin_idx).c_str());
            }
            else
            {
                m_pins[pin_idx].Remove_Interrupt_Type(type);
                m_logging_system.Debug(fmt::format("Interrupt number {} has been disabled on pin {}", static_cast<std::uint32_t>(type), pin_idx).c_str());
            }
        }
    }

    void CGPIO_Manager::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        const std::size_t reg_idx = addr / REG_SIZE;
        const auto reg_type = static_cast<NRegister>(reg_idx);

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
                // TODO
                break;

            case NRegister::GPREN0:
                [[fallthrough]];
            case NRegister::GPREN1:
                Set_Interrupt(reg_idx, reg_type == NRegister::GPREN1, CPin::NInterrupt_Type::Rising_Edge);
                break;

            case NRegister::GPHEN0:
                [[fallthrough]];
            case NRegister::GPHEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister::GPREN1, CPin::NInterrupt_Type::High);
                break;

            case NRegister::GPLEN0:
                [[fallthrough]];
            case NRegister::GPLEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister::GPREN1, CPin::NInterrupt_Type::Low);
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
                Set_Interrupt(reg_idx, reg_type == NRegister::GPREN1, CPin::NInterrupt_Type::Falling_Edge);
                break;

            default:
                // TODO add the rest of the registers
                break;
        }
    }

    void CGPIO_Manager::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / REG_SIZE;
        std::copy_n(&m_regs[reg_idx], size, data);
    }

    const CGPIO_Manager::CPin& CGPIO_Manager::Get_Pin(std::size_t idx) const
    {
        return m_pins.at(idx);
    }
}
