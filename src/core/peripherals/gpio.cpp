#include <algorithm>

#include <fmt/format.h>

#include "../utils/singleton.hpp"
#include "gpio.hpp"

namespace zero_mate::peripheral
{
    CGPIO_Manager::CGPIO_Manager() noexcept
    : m_regs{}
    , m_pins{}
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
    }

    std::uint32_t CGPIO_Manager::Get_Size() const noexcept
    {
        return sizeof(m_regs);
    }

    void CGPIO_Manager::Update_Pin_Function(std::size_t reg_idx, bool last_reg)
    {
        static constexpr std::size_t NUMBER_OF_PINS_IN_REG = 10;
        const std::uint32_t last_bit_idx = last_reg ? 12 : 30;

        for (std::uint32_t idx = 0; idx < last_bit_idx; idx += 3)
        {
            const auto function = static_cast<CPin::NFunction>((m_regs.at(reg_idx) >> idx) & 0b111);
            const auto pin_idx = (reg_idx * NUMBER_OF_PINS_IN_REG) + idx / 3;

            m_pins.at(pin_idx).m_function = function;

            m_logging_system.Debug(fmt::format("Function of pin {} is set to {}", pin_idx, static_cast<std::uint32_t>(function)).c_str());
        }
    }

    void CGPIO_Manager::Update_Pin_State(std::size_t reg_idx, CPin::NState state, bool last_reg)
    {
        const std::uint32_t last_bit_idx = last_reg ? 22 : 32;

        for (std::uint32_t idx = 0; idx < last_bit_idx; ++idx)
        {
            const auto set_bit = static_cast<bool>((m_regs.at(reg_idx) >> idx) & 0b1);
            const auto pin_idx = last_reg ? (32 + idx) : idx;

            if (set_bit)
            {
                if (m_pins.at(pin_idx).m_function == CPin::NFunction::Output)
                {
                    m_pins.at(pin_idx).m_state = state;
                    m_logging_system.Debug(fmt::format("State of pin {} is set to {}", pin_idx, static_cast<std::uint32_t>(state)).c_str());
                }
                else
                {
                    m_logging_system.Warning(fmt::format("Cannot change the state of pin {} as its function has not been to output", pin_idx).c_str());
                }
            }
        }

        m_regs.at(reg_idx) = 0;
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

            case NRegister_Type::Reserved_01:
                break;

            case NRegister_Type::GPSET0:
                [[fallthrough]];
            case NRegister_Type::GPSET1:
                Update_Pin_State(reg_idx, CPin::NState::High, reg_type == NRegister_Type::GPSET1);
                break;

            case NRegister_Type::Reserved_02:
                break;

            case NRegister_Type::GPCLR0:
                [[fallthrough]];
            case NRegister_Type::GPCLR1:
                Update_Pin_State(reg_idx, CPin::NState::Low, reg_type == NRegister_Type::GPCLR1);
                break;

            case NRegister_Type::Reserved_03:
                break;

            case NRegister_Type::GPLEV0:
                [[fallthrough]];
            case NRegister_Type::GPLEV1:
                break;

            case NRegister_Type::Reserved_04:
                break;

            case NRegister_Type::GPEDS0:
                [[fallthrough]];
            case NRegister_Type::GPEDS1:
                break;

            case NRegister_Type::GPREN1:
                [[fallthrough]];
            case NRegister_Type::GPFEN1:
                break;

            case NRegister_Type::Reserved_07:
                break;

            case NRegister_Type::GPHEN0:
                [[fallthrough]];
            case NRegister_Type::GPHEN1:
                break;

            case NRegister_Type::Reserved_08:
                break;

            case NRegister_Type::GPLEN0:
                [[fallthrough]];
            case NRegister_Type::GPLEN1:
                break;

            case NRegister_Type::Reserved_09:
                break;

            case NRegister_Type::GPAREN0:
                [[fallthrough]];
            case NRegister_Type::GPAREN1:
                break;

            case NRegister_Type::GPAFEN1:
                break;

            case NRegister_Type::Reserved_11:
                break;

            case NRegister_Type::GPPUD:
                break;

            case NRegister_Type::GPPUDCLK0:
                [[fallthrough]];
            case NRegister_Type::GPPUDCLK1:
                break;
        }
    }

    void CGPIO_Manager::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        // TODO
        static_cast<void>(addr);
        static_cast<void>(data);
        static_cast<void>(size);

        // const std::size_t reg_idx = addr / sizeof(std::uint32_t);
        // std::copy_n(&m_regs.at(reg_idx), size, data);
    }
}