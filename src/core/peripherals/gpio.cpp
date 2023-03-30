#include <algorithm>

#include <fmt/format.h>

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
        m_enabled_interrupts.at(static_cast<std::size_t>(type)) = true;
    }

    void CGPIO_Manager::CPin::Remove_Interrupt_Type(NInterrupt_Type type)
    {
        m_enabled_interrupts.at(static_cast<std::size_t>(type)) = false;
    }

    CGPIO_Manager::CGPIO_Manager() noexcept
    : m_regs{}
    , m_pins{}
    , m_logging_system{ utils::CSingleton<utils::CLogging_System>::Get_Instance() }
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
            const auto function = static_cast<CPin::NFunction>((m_regs.at(reg_idx) >> idx) & 0b111U);
            const auto pin_idx = (reg_idx * NUMBER_OF_PINS_IN_SEL_REG) + idx / 3;

            if (m_pins.at(pin_idx).Get_Function() != function)
            {
                m_logging_system.Debug(fmt::format("Function of pin {} is set to {}", pin_idx, static_cast<std::uint32_t>(function)).c_str());
            }

            m_pins.at(pin_idx).Set_Function(function);
        }
    }

    void CGPIO_Manager::Update_Pin_State(std::size_t reg_idx, CPin::NState state, bool last_reg)
    {
        const std::uint32_t last_bit_idx = last_reg ? (NUMBER_OF_GPIO_PINS - NUMBER_OF_PINS_IN_REG) : NUMBER_OF_PINS_IN_REG;

        for (std::uint32_t idx = 0; idx < last_bit_idx; ++idx)
        {
            const auto set_bit = static_cast<bool>((m_regs.at(reg_idx) >> idx) & 0b1U);
            const auto pin_idx = last_reg ? (NUMBER_OF_PINS_IN_REG + idx) : idx;

            if (set_bit)
            {
                if (m_pins.at(pin_idx).Get_Function() == CPin::NFunction::Output)
                {
                    if (m_pins.at(pin_idx).Get_State() != state)
                    {
                        m_logging_system.Debug(fmt::format("State of pin {} is set to {}", pin_idx, static_cast<std::uint32_t>(state)).c_str());
                    }

                    m_pins.at(pin_idx).Set_State(state);
                    Reflect_Pin_State_In_GPLEVn(pin_idx, state);
                }
                else
                {
                    m_logging_system.Warning(fmt::format("Cannot change the state of pin {} as its function has not been to output", pin_idx).c_str());
                }
            }
        }

        m_regs.at(reg_idx) = 0; // Only the last write sets the state of the PIN (RS flip-flop)
    }

    void CGPIO_Manager::Reflect_Pin_State_In_GPLEVn(std::size_t pin_idx, CPin::NState state)
    {
        const std::size_t reg_index = [&]() -> std::uint32_t {
            if (pin_idx >= NUMBER_OF_PINS_IN_REG)
            {
                pin_idx -= NUMBER_OF_PINS_IN_REG;
                return static_cast<std::size_t>(NRegister_Type::GPLEV1);
            }

            return static_cast<std::size_t>(NRegister_Type::GPLEV0);
        }();

        auto& GPLEVn_reg = m_regs.at(reg_index);

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
            const auto set_bit = static_cast<bool>((m_regs.at(reg_idx) >> idx) & 0b1U);
            const auto pin_idx = last_reg ? (NUMBER_OF_PINS_IN_REG + idx) : idx;

            if (set_bit)
            {
                m_pins.at(pin_idx).Add_Interrupt_Type(type);
                m_logging_system.Debug(fmt::format("Interrupt number {} has been enabled on pin {}", static_cast<std::uint32_t>(type), pin_idx).c_str());
            }
            else
            {
                m_pins.at(pin_idx).Remove_Interrupt_Type(type);
                m_logging_system.Debug(fmt::format("Interrupt number {} has been disabled on pin {}", static_cast<std::uint32_t>(type), pin_idx).c_str());
            }
        }
    }

    void CGPIO_Manager::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        const std::size_t reg_idx = addr / sizeof(std::uint32_t);
        const auto reg_type = static_cast<NRegister_Type>(reg_idx);

        switch (reg_type)
        {
            case NRegister_Type::GPFSEL0:
                [[fallthrough]];
            case NRegister_Type::GPFSEL1:
            case NRegister_Type::GPFSEL2:
            case NRegister_Type::GPFSEL3:
            case NRegister_Type::GPFSEL4:
            case NRegister_Type::GPFSEL5:
                Update_Pin_Function(reg_idx, reg_type == NRegister_Type::GPFSEL5);
                break;

            case NRegister_Type::GPSET0:
                [[fallthrough]];
            case NRegister_Type::GPSET1:
                Update_Pin_State(reg_idx, CPin::NState::High, reg_type == NRegister_Type::GPSET1);
                break;

            case NRegister_Type::GPCLR0:
                [[fallthrough]];
            case NRegister_Type::GPCLR1:
                Update_Pin_State(reg_idx, CPin::NState::Low, reg_type == NRegister_Type::GPCLR1);
                break;

            case NRegister_Type::GPLEV0:
                [[fallthrough]];
            case NRegister_Type::GPLEV1:
                // These registers reflect the actual state of each PIN
                // The corresponding bits are set/cleared whenever a changes its state
                break;

            case NRegister_Type::GPEDS0:
                [[fallthrough]];
            case NRegister_Type::GPEDS1:
                // TODO
                break;

            case NRegister_Type::GPREN0:
                [[fallthrough]];
            case NRegister_Type::GPREN1:
                Set_Interrupt(reg_idx, reg_type == NRegister_Type::GPREN1, CPin::NInterrupt_Type::Rising_Edge);
                break;

            case NRegister_Type::GPHEN0:
                [[fallthrough]];
            case NRegister_Type::GPHEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister_Type::GPREN1, CPin::NInterrupt_Type::High);
                break;

            case NRegister_Type::GPLEN0:
                [[fallthrough]];
            case NRegister_Type::GPLEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister_Type::GPREN1, CPin::NInterrupt_Type::Low);
                break;

            case NRegister_Type::Reserved_01:
                [[fallthrough]];
            case NRegister_Type::Reserved_02:
            case NRegister_Type::Reserved_03:
            case NRegister_Type::Reserved_04:
            case NRegister_Type::Reserved_05:
            case NRegister_Type::Reserved_06:
            case NRegister_Type::Reserved_07:
            case NRegister_Type::Reserved_08:
            case NRegister_Type::Reserved_09:
            case NRegister_Type::Reserved_10:
            case NRegister_Type::Reserved_11:
            case NRegister_Type::Reserved_12:
                break;

            case NRegister_Type::GPFEN0:
                [[fallthrough]];
            case NRegister_Type::GPFEN1:
                Set_Interrupt(reg_idx, reg_type == NRegister_Type::GPREN1, CPin::NInterrupt_Type::Falling_Edge);
                break;

            default:
                // TODO add the rest of the registers
                break;
        }
    }

    void CGPIO_Manager::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / sizeof(std::uint32_t);
        std::copy_n(&m_regs.at(reg_idx), size, data);
    }

    const std::array<CGPIO_Manager::CPin, CGPIO_Manager::NUMBER_OF_GPIO_PINS> CGPIO_Manager::Get_Pins() const
    {
        return m_pins;
    }
}