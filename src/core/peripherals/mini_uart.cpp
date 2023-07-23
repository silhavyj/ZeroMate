#include <chrono>

#include "mini_uart.hpp"
#include "auxiliary.hpp"

namespace zero_mate::peripheral
{
    CMini_UART::CMini_UART(CAUX& aux)
    : m_aux{ aux }
    , m_transmit_shift_reg{ 0 }
    , m_receive_shift_reg{ 0 }
    , m_is_there_data_to_transmit{ false }
    , m_UART_thread_has_stopped{ true }
    {
    }

    CMini_UART::~CMini_UART()
    {
        while (!m_UART_thread_has_stopped)
        {
        }
    }

    void CMini_UART::Set_Transmit_Shift_Reg(std::uint8_t value)
    {
        m_transmit_shift_reg = value;
        m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] &= ~(1U << 5U);
        m_is_there_data_to_transmit = true;
        Try_To_Transmit_Data();
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

    std::uint32_t CMini_UART::Get_Char_Length_Value(NChar_Length char_length) noexcept
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

    void CMini_UART::Enable(bool enabled)
    {
        Set_TX_Pin(enabled);
        Try_To_Transmit_Data();
    }

    void CMini_UART::Try_To_Transmit_Data()
    {
        // clang-format off
        if (!m_aux.Is_Enabled(CAUX::NAUX_Peripheral::Mini_UART) ||
            !m_is_there_data_to_transmit ||
            !Is_Transmitter_Enabled())
        {
            return;
        }
        // clang-format on

        m_UART_thread = std::thread{ &CMini_UART::Run, this };
        m_UART_thread.detach();
    }

    void CMini_UART::Run()
    {
        m_UART_thread_has_stopped = false;
        NState_Machine state{ NState_Machine::Send_Start_Bit };
        std::uint8_t bit_idx{ 0 };
        const std::uint32_t baudrate = Get_Baudrate_Counter();

        while (true)
        {
            switch (state)
            {
                case NState_Machine::Send_Start_Bit:
                    Send_Start_Bit(state);
                    break;

                case NState_Machine::Send_Payload:
                    Send_Payload(state, bit_idx);
                    break;

                case NState_Machine::Send_Stop_Bit:
                    Send_Stop_bit(state);
                    break;

                case NState_Machine::End_Of_Frame:
                    break;
            }

            std::this_thread::sleep_for(std::chrono::nanoseconds(baudrate));

            if (state == NState_Machine::End_Of_Frame)
            {
                Reset_Transmission(state);
                break;
            }
        }

        m_UART_thread_has_stopped = true;
    }

    void CMini_UART::Send_Start_Bit(NState_Machine& state)
    {
        Set_TX_Pin(false);
        state = NState_Machine::Send_Payload;
    }

    void CMini_UART::Send_Payload(NState_Machine& state, std::uint8_t& bit_idx)
    {
        Set_TX_Pin(static_cast<bool>(m_transmit_shift_reg & 0b1U));

        m_transmit_shift_reg >>= 1U;
        ++bit_idx;

        if (bit_idx >= Get_Char_Length_Value(Get_Char_Length()))
        {
            bit_idx = 0;
            state = NState_Machine::Send_Stop_Bit;
        }
    }

    void CMini_UART::Send_Stop_bit(NState_Machine& state)
    {
        Set_TX_Pin(true);
        state = NState_Machine::End_Of_Frame;
    }

    void CMini_UART::Reset_Transmission(NState_Machine& state)
    {
        // TODO fire an interrupt, if enabled?

        m_is_there_data_to_transmit = false;
        state = NState_Machine::Send_Start_Bit;
        Set_TX_Pin(true);
        m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] |= (1U << 5U);
    }

    void CMini_UART::Set_TX_Pin(bool state)
    {
        const auto status =
        m_aux.m_gpio->Set_Pin_State(UART_0_TX_PIN_IDX, static_cast<CGPIO_Manager::CPin::NState>(state));

        switch (status)
        {
            case CGPIO_Manager::NPin_Set_Status::OK:
                break;

            case CGPIO_Manager::NPin_Set_Status::Invalid_Pin_Function:
                m_aux.m_logging_system.Error("Invalid function of the UART_0 TX pin");
                break;

            case CGPIO_Manager::NPin_Set_Status::Invalid_Pin_Number:
                m_aux.m_logging_system.Error("Invalid pin number");
                break;
        }
    }
}