#include <chrono>

#include "mini_uart.hpp"
#include "auxiliary.hpp"

namespace zero_mate::peripheral
{
    CMini_UART::CMini_UART(CAUX& aux)
    : m_aux{ aux }
    , m_is_there_data_to_transmit{ false }
    , m_stop_UART_thread{ false }
    , m_UART_thread_has_stopped{ false }
    {
        m_UART_thread = std::thread{ &CMini_UART::Run, this };
        m_UART_thread.detach();
    }

    CMini_UART::~CMini_UART()
    {
        m_stop_UART_thread = true;

        while (!m_UART_thread_has_stopped)
        {
        }
    }

    void CMini_UART::Set_Transmit_Shift_Reg(std::uint8_t value)
    {
        m_transmit_shift_reg = value;
        m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] &= ~(1U << 5U);
        m_is_there_data_to_transmit = true;
    }

    bool CMini_UART::Is_Receive_Interrupt_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_IER)] & 0b10U);
    }

    bool CMini_UART::Is_Transmit_Interrupt_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_IER)] & 0b01U);
    }

    CMini_UART::NChar_Length CMini_UART::Get_Char_Length() const noexcept
    {
        return static_cast<NChar_Length>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LCR)] & 0b1U);
    }

    bool CMini_UART::Is_Transmitter_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_CNTL)] & 0b10U);
    }

    bool CMini_UART::Is_Receiver_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_CNTL)] & 0b01U);
    }

    std::uint32_t CMini_UART::Get_Baudrate_Counter() const noexcept
    {
        return m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_BAUD)] & 0xFFFFU;
    }

    std::uint32_t CMini_UART::Get_Char_Length_Value(NChar_Length char_length) const noexcept
    {
        switch (char_length)
        {
            case NChar_Length::Char_7:
                return 7U;
                break;

            case NChar_Length::Char_8:
                return 8U;
                break;
        }

        return 0U;
    }

    void CMini_UART::Run()
    {
        NState_Machine state{ NState_Machine::Send_Start_Bit };
        std::uint8_t payload_counter{ 0 };
        CGPIO_Manager::CPin::NState value;

        m_aux.m_gpio->Set_Pin_State(UART_0_TX_PIN_IDX, CGPIO_Manager::CPin::NState::High);

        while (!m_stop_UART_thread)
        {
            // TODO add a condition variable
            while (m_aux.Is_Enabled(CAUX::NAUX_Peripheral::Mini_UART) || !m_is_there_data_to_transmit || !Is_Transmitter_Enabled())
            {
                std::this_thread::sleep_for(std::chrono::milliseconds (1));
            }

            switch (state)
            {
                case NState_Machine::Send_Start_Bit:
                    // TODO do not ignore the return value
                    m_aux.m_gpio->Set_Pin_State(UART_0_TX_PIN_IDX, CGPIO_Manager::CPin::NState::Low, true);
                    state = NState_Machine::Send_Payload;
                    break;

                case NState_Machine::Send_Payload:
                    value = static_cast<CGPIO_Manager::CPin::NState>(m_transmit_shift_reg & 0b1U);
                    m_aux.m_gpio->Set_Pin_State(UART_0_TX_PIN_IDX, value, true);
                    m_transmit_shift_reg >>= 1U;
                    ++payload_counter;
                    if (payload_counter >= Get_Char_Length_Value(Get_Char_Length()))
                    {
                        payload_counter = 0;
                        state = NState_Machine::Send_Stop_Bit;
                    }
                    break;

                case NState_Machine::Send_Stop_Bit:
                    m_aux.m_gpio->Set_Pin_State(UART_0_TX_PIN_IDX, CGPIO_Manager::CPin::NState::High, true);
                    state = NState_Machine::End_Of_Frame;
                    break;

                case NState_Machine::End_Of_Frame:
                    break;
            }

            std::this_thread::sleep_for(std::chrono::milliseconds (1));

            if (state == NState_Machine::End_Of_Frame)
            {
                // TODO fire an interrupt, if enabled?

                m_is_there_data_to_transmit = false;
                state = NState_Machine::Send_Start_Bit;
                m_aux.m_gpio->Set_Pin_State(UART_0_TX_PIN_IDX, CGPIO_Manager::CPin::NState::High);
                m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] |= (1U << 5U);
            }
        }

        m_UART_thread_has_stopped = true;
    }
}