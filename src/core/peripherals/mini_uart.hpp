#pragma once

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
            Start_Bit,
            Payload,
            Stop_Bit,
            End_Of_Frame
        };

    public:
        explicit CMini_UART(CAUX& aux);

        void Set_Transmit_Shift_Reg(std::uint8_t value);
        [[nodiscard]] bool Is_Receive_Interrupt_Enabled() const noexcept;
        [[nodiscard]] bool Is_Transmit_Interrupt_Enabled() const noexcept;
        [[nodiscard]] NChar_Length Get_Char_Length() const noexcept;
        [[nodiscard]] bool Is_Transmitter_Enabled() const noexcept;
        [[nodiscard]] bool Is_Receiver_Enabled() const noexcept;
        [[nodiscard]] std::uint32_t Get_Baud_Rate_Counter() const noexcept;
        void Enable(bool enabled);
        void Increment_Passed_Cycles(std::uint32_t count);

    private:
        [[nodiscard]] static std::uint32_t Get_Char_Length_Value(NChar_Length char_length) noexcept;
        void Update();
        inline void Update_TX();
        inline void Update_RX();

        inline void Send_Start_Bit();
        inline void Send_Payload();
        inline void Send_Stop_bit();
        inline void Reset_Transmission();
        inline void Set_TX_Pin(bool state);

    private:
        CAUX& m_aux;
        std::uint8_t m_transmit_shift_reg;
        std::uint8_t m_receive_shift_reg;
        bool m_is_there_data_to_transmit;
        std::uint32_t m_cpu_cycles;
        std::uint8_t m_TX_bit_idx;
        NState_Machine m_TX_state;
    };
}