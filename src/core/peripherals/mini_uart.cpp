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
    , m_cpu_cycles{ 0 }
    , m_TX_bit_idx{ 0 }
    , m_TX_state{ NState_Machine::Start_Bit }
    {
    }

    void CMini_UART::Reset()
    {
        m_cpu_cycles = 0;
        m_is_there_data_to_transmit = false;
        m_TX_bit_idx = 0;
        m_TX_state = NState_Machine::Start_Bit;

        m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] |=
        static_cast<std::uint32_t>(NLSR_Flags::Transmitter_Empty);
    }

    void CMini_UART::Set_Transmit_Shift_Reg(std::uint8_t value)
    {
        m_transmit_shift_reg = value;

        m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] &=
        ~static_cast<std::uint32_t>(NLSR_Flags::Transmitter_Empty);

        m_is_there_data_to_transmit = true;
    }

    bool CMini_UART::Is_Receive_Interrupt_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_IER)] &
                                 static_cast<std::uint32_t>(NIIR_Flags::Enable_Receive_Interrupt));
    }

    bool CMini_UART::Is_Transmit_Interrupt_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_IER)] &
                                 static_cast<std::uint32_t>(NIIR_Flags::Enable_Transmit_Interrupt));
    }

    CMini_UART::NChar_Length CMini_UART::Get_Char_Length() const noexcept
    {
        return static_cast<NChar_Length>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LCR)] & 0b1U);
    }

    bool CMini_UART::Is_Transmitter_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_CNTL)] &
                                 static_cast<std::uint32_t>(NCNTL_Flags::Transmitter_Enable));
    }

    bool CMini_UART::Is_Receiver_Enabled() const noexcept
    {
        return static_cast<bool>(m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_CNTL)] &
                                 static_cast<std::uint32_t>(NCNTL_Flags::Receiver_Enable));
    }

    std::uint32_t CMini_UART::Get_Baud_Rate_Counter() const noexcept
    {
        static constexpr std::uint32_t Baud_Rate_Mask = 0xFFFFU;

        return m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_BAUD)] & Baud_Rate_Mask;
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
    }

    void CMini_UART::Update()
    {
        if (!m_aux.Is_Enabled(CAUX::NAUX_Peripheral::Mini_UART))
        {
            return;
        }

        Update_TX();
        Update_RX();
    }

    void CMini_UART::Update_TX()
    {
        if (!m_is_there_data_to_transmit || !Is_Transmitter_Enabled())
        {
            return;
        }

        switch (m_TX_state)
        {
            case NState_Machine::Start_Bit:
                Send_Start_Bit();
                break;

            case NState_Machine::Payload:
                Send_Payload();
                break;

            case NState_Machine::Stop_Bit:
                Send_Stop_bit();
                break;

            case NState_Machine::End_Of_Frame:
                break;
        }

        if (m_TX_state == NState_Machine::End_Of_Frame)
        {
            Reset_Transmission();
        }
    }

    void CMini_UART::Update_RX()
    {
        // TODO
    }

    void CMini_UART::Send_Start_Bit()
    {
        Set_TX_Pin(false);
        m_TX_state = NState_Machine::Payload;
    }

    void CMini_UART::Send_Payload()
    {
        Set_TX_Pin(static_cast<bool>(m_transmit_shift_reg & 0b1U));

        m_transmit_shift_reg >>= 1U;
        ++m_TX_bit_idx;

        if (m_TX_bit_idx >= Get_Char_Length_Value(Get_Char_Length()))
        {
            m_TX_bit_idx = 0;
            m_TX_state = NState_Machine::Stop_Bit;
        }
    }

    void CMini_UART::Send_Stop_bit()
    {
        Set_TX_Pin(true);
        m_TX_state = NState_Machine::End_Of_Frame;
    }

    void CMini_UART::Reset_Transmission()
    {
        // TODO fire an interrupt, if enabled?

        m_is_there_data_to_transmit = false;
        m_TX_state = NState_Machine::Start_Bit;
        Set_TX_Pin(true);

        m_aux.m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] |=
        static_cast<std::uint32_t>(NLSR_Flags::Transmitter_Empty);
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

    void CMini_UART::Increment_Passed_Cycles(std::uint32_t count)
    {
        m_cpu_cycles += count;

        if (m_cpu_cycles >= Get_Baud_Rate_Counter())
        {
            m_cpu_cycles = 0;
            Update();
        }
    }
}