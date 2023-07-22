#pragma once

#include <thread>
#include <atomic>
#include <cstdint>

namespace zero_mate::peripheral
{
    class CAUX;

    class CMini_UART final
    {
    public:
        static constexpr std::uint32_t UART_0_TX_PIN_IDX = 14;
        static constexpr std::uint32_t UART_0_RX_PIN_IDX = 15;

        enum class NChar_Length : std::uint32_t
        {
            Char_7 = 0,
            Char_8 = 1
        };

        enum class NState_Machine
        {
            Send_Start_Bit,
            Send_Payload,
            Send_Stop_Bit,
            End_Of_Frame
        };

    public:
        explicit CMini_UART(CAUX& aux);
        ~CMini_UART();

        [[noreturn]] void Run();

        void Set_Transmit_Shift_Reg(std::uint8_t value);
        [[nodiscard]] bool Is_Receive_Interrupt_Enabled() const noexcept;
        [[nodiscard]] bool Is_Transmit_Interrupt_Enabled() const noexcept;
        [[nodiscard]] NChar_Length Get_Char_Length() const noexcept;
        [[nodiscard]] bool Is_Transmitter_Enabled() const noexcept;
        [[nodiscard]] bool Is_Receiver_Enabled() const noexcept;
        [[nodiscard]] std::uint32_t Get_Baudrate_Counter() const noexcept;

    private:
        [[nodiscard]] std::uint32_t Get_Char_Length_Value(NChar_Length char_length) const noexcept;

    private:
        CAUX& m_aux;
        std::uint8_t m_transmit_shift_reg;
        std::uint8_t m_receive_shift_reg;
        std::atomic<bool> m_is_there_data_to_transmit;
        std::atomic<bool> m_stop_UART_thread;
        std::atomic<bool> m_UART_thread_has_stopped;
        std::thread m_UART_thread;
    };
}