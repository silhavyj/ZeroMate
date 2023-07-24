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

        enum class NLSR_Flags : std::uint32_t
        {
            Data_Ready = 0b1U << 0U,
            Transmitter_Empty = 0b1U << 5U,
            Transmitter_Idle = 0b1U << 6U
        };

        enum class NCNTL_Flags : std::uint32_t
        {
            Receiver_Enable = 0b1U << 0U,
            Transmitter_Enable = 0b1U << 1U
        };

        enum class NIIR_Flags : std::uint32_t
        {
            Enable_Transmit_Interrupt = 0b1U << 0U,
            Enable_Receive_Interrupt = 0b1U << 1U
        };

        enum class NIER_Flags : std::uint32_t
        {
            Pending_IRQ = 0b1U << 0U,
            Clear_Receive_FIFO = 0b1U << 1U,
            Clear_Transmit_FIFO = 0b1U << 2U
        };

    public:
        explicit CMini_UART(CAUX& aux);

        void Set_Transmit_Shift_Reg(std::uint8_t value);
        void Clear_Data_Ready();
        [[nodiscard]] bool Is_Receive_Interrupt_Enabled() const noexcept;
        [[nodiscard]] bool Is_Transmit_Interrupt_Enabled() const noexcept;
        [[nodiscard]] NChar_Length Get_Char_Length() const noexcept;
        [[nodiscard]] bool Is_Transmitter_Enabled() const noexcept;
        [[nodiscard]] bool Is_Receiver_Enabled() const noexcept;
        [[nodiscard]] std::uint32_t Get_Baud_Rate_Counter() const noexcept;
        void Enable(bool enabled);
        void Increment_Passed_Cycles(std::uint32_t count);
        void Reset();
        void Clear_IRQ();

    private:
        struct TState_Machine_Data
        {
            NState_Machine state;
            std::uint8_t bit_idx;
            std::uint8_t fifo;
        };

    private:
        void Update();

        inline void Update_TX();
        inline void Update_RX();

        inline void Send_Start_Bit();
        inline void Send_Payload();
        inline void Send_Stop_bit();
        inline void Reset_Transmission();
        inline void Set_TX_Pin(bool set);
        inline void Set_RX_Pin(bool set);

        inline void Receive_Start_Bit();
        inline void Receive_Payload();
        inline void Receive_Stop_Bit();

        [[nodiscard]] static std::uint32_t Get_Char_Length_Value(NChar_Length char_length) noexcept;
        [[nodiscard]] inline bool Is_Transmit_FIFO_Empty() const noexcept;
        inline void Trigger_IRQ();
        inline void Set_GPIO_pin(std::uint8_t pin_idx, bool set);

    private:
        CAUX& m_aux;
        std::uint32_t m_cpu_cycles{};
        TState_Machine_Data m_tx{};
        TState_Machine_Data m_rx{};
    };
}