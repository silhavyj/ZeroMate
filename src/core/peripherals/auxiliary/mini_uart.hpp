// ---------------------------------------------------------------------------------------------------------------------
/// \file mini_uart.hpp
/// \date 24. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the Mini UART auxiliary peripheral used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 2)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <queue>
#include <cstdint>
#include <utility>
/// \endcond

namespace zero_mate::peripheral
{
    // Forward declaration of the CAUX class (avoid a cyclic dependency)
    class CAUX;

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CMini_UART
    /// \brief This class represents the Mini UART used in BCM2835.
    // -----------------------------------------------------------------------------------------------------------------
    class CMini_UART final
    {
    public:
        /// Index of the TX GPIO pin
        static constexpr std::uint32_t UART_0_TX_PIN_IDX = 14;

        /// Index of the RX GPIO pin
        static constexpr std::uint32_t UART_0_RX_PIN_IDX = 15;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NChar_Length
        /// \brief Enumeration of data lengths that could be used for data transmission/reception.
        // -------------------------------------------------------------------------------------------------------------
        enum class NChar_Length : std::uint32_t
        {
            Char_7 = 0, ///< 7 bits
            Char_8 = 1  ///< 8 bits
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NState_Machine
        /// \brief Enumeration of different states used when sending/receiving UART frames.
        // -------------------------------------------------------------------------------------------------------------
        enum class NState_Machine
        {
            Start_Bit,   ///< Start bit (start of a new frame)
            Payload,     ///< Sending/receiving payload (actual data)
            Stop_Bit,    ///< Stop bit (there is only one stop bit in this UART implementation)
            End_Of_Frame ///< End of frame
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NLSR_Flags
        /// \brief Flags that can be found in the MU_LSR register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NLSR_Flags : std::uint32_t
        {
            Data_Ready = 0b1U << 0U,       ///< Received data is ready in the MU_IO register
            Transmitter_Empty = 0b1U << 5U ///< Transmission FIFO is empty
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCNTL_Flags
        /// \brief Flags that can be found in the MU_CNTL register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCNTL_Flags : std::uint32_t
        {
            Receiver_Enable = 0b1U << 0U,   ///< Receiver enabled
            Transmitter_Enable = 0b1U << 1U ///< Transmitter enabled
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NIER_Flags
        /// \brief Flags that can be found in the MU_IER register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NIER_Flags : std::uint32_t
        {
            Enable_Transmit_Interrupt = 0b1U << 0U, ///< Enable transmit interrupt
            Enable_Receive_Interrupt = 0b1U << 1U   ///< Enable receive interrupt
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NIIR_Flags
        /// \brief Flags that can be found in the MU_IIR register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NIIR_Flags : std::uint32_t
        {
            Pending_IRQ = 0b1U << 0U,        ///< Is there a pending IRQ (inverted logic)
            Clear_Receive_FIFO = 0b1U << 1U, ///< Should receive FIFO be cleared?
            Clear_Transmit_FIFO = 0b1U << 2U ///< Should the transmit FIFO be cleared?
        };

        /// Pending receive IRQ flag
        static constexpr std::uint32_t IIR_IRQ_Receive_Pending = 0b10U << 1U;

        /// Pending transmit IRQ flag
        static constexpr std::uint32_t IIR_IRQ_Transmit_Pending = 0b01U << 1U;

        /// Pending IRQ type bitmask
        static constexpr std::uint32_t IIR_IRQ_Type_Mask = IIR_IRQ_Transmit_Pending | IIR_IRQ_Transmit_Pending;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param aux Reference to the AUX peripheral (registers, GPIO, etc.)
        // -------------------------------------------------------------------------------------------------------------
        explicit CMini_UART(CAUX& aux);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Moves data from the MU_IO register to the transmission FIFO.
        /// \param value Value to be transmitted.
        // -------------------------------------------------------------------------------------------------------------
        void Set_Transmit_Shift_Reg(std::uint8_t value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears the flag indicating that data is ready to be read from the MU_IO register.
        // -------------------------------------------------------------------------------------------------------------
        void Clear_Data_Ready();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the length of payload (7 or 8 bits).
        /// \return Set up data length
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NChar_Length Get_Char_Length() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether the transmitter is enabled or not.
        /// \return true, if the transmitter is enabled. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Transmitter_Enabled() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether the receiver is enabled or not.
        /// \return true, if the received is enabled. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Receiver_Enabled() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the set up baud rate.
        /// \return Current baud rate
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Baud_Rate_Counter() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Enables/disables the mini UART peripheral.
        /// \param enabled Indication of whether UART should be enabled or disabled
        // -------------------------------------------------------------------------------------------------------------
        void Enable(bool enabled);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the number of passed CPU cycles (forwarded from the AUX peripheral).
        /// \param count Number of CPU cycles that have passed by
        // -------------------------------------------------------------------------------------------------------------
        void Increment_Passed_Cycles(std::uint32_t count);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets UART.
        // -------------------------------------------------------------------------------------------------------------
        void Reset();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears any pending interrupt.
        // -------------------------------------------------------------------------------------------------------------
        void Clear_IRQ();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Pops a byte of data from the RX queue.
        /// \return If there is no data to be popped, the second element will be set to false.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::pair<std::uint8_t, bool> Pop_RX_Data();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether there is a pending receive IRQ.
        /// \return true, if there is a pending receive IRQ. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Has_Pending_Receive_IRQ() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether there is a pending transmit IRQ.
        /// \return true, if there is a transmit receive IRQ. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Has_Pending_Transmit_IRQ() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears a pending receive IRQ.
        // -------------------------------------------------------------------------------------------------------------
        void Clear_Pending_Receive_IRQ();

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TState_Machine_Data
        /// \brief Encapsulation of state machine related data (transmission/reception).
        // -------------------------------------------------------------------------------------------------------------
        struct TState_Machine_Data
        {
            NState_Machine state; ///< Current state of the state machine
            std::uint8_t bit_idx; ///< Number of sent/received bits
            std::uint8_t fifo;    ///< FIFO
        };

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Helper function to clear global IRQ flags (not those related to a particular IRQ type).
        // -------------------------------------------------------------------------------------------------------------
        void Clear_Global_IRQ_Flags();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the state machines (transmission/reception).
        // -------------------------------------------------------------------------------------------------------------
        void Update();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the transmission state machine.
        // -------------------------------------------------------------------------------------------------------------
        inline void Update_TX();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the reception state machines.
        // -------------------------------------------------------------------------------------------------------------
        inline void Update_RX();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends a start bit.
        // -------------------------------------------------------------------------------------------------------------
        inline void UART_Send_Start_Bit();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends another bit of the current payload (actual data).
        // -------------------------------------------------------------------------------------------------------------
        inline void UART_Send_Payload();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends a stop bit.
        // -------------------------------------------------------------------------------------------------------------
        inline void UART_Send_Stop_bit();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets transmission (end of the current UART frame).
        // -------------------------------------------------------------------------------------------------------------
        inline void UART_Reset_Transmission();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the state of the TX pin.
        /// \param set State to which the TX pin will be set
        // -------------------------------------------------------------------------------------------------------------
        inline void Set_TX_Pin(bool set);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the state of the RX pin.
        ///
        /// This function is used only once when UART is enabled, so it pulls the level of voltage into an IDLE state.
        ///
        /// \param set State to which the RX pin will be set
        // -------------------------------------------------------------------------------------------------------------
        inline void Set_RX_Pin(bool set);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Receives a start bit.
        // -------------------------------------------------------------------------------------------------------------
        inline void UART_Receive_Start_Bit();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Receives another bit of the current payload (actual data).
        // -------------------------------------------------------------------------------------------------------------
        inline void UART_Receive_Payload();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Receives a stop bit.
        // -------------------------------------------------------------------------------------------------------------
        inline void UART_Receive_Stop_Bit();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the data length from a given enumeration.
        /// \param char_length Current data length
        /// \return Integral value representing the data length (7/8)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static std::uint32_t Get_Char_Length_Value(NChar_Length char_length) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether the transmission FIFO is empty or not.
        /// \return true, if the transmission FIFO is empty. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_Transmission_FIFO_Empty() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Triggers an interrupt.
        /// \param receive Should we trigger a receive or transmit interrupt?
        // -------------------------------------------------------------------------------------------------------------
        inline void Trigger_IRQ(bool receive);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the state of a given GPIO pin.
        /// \param pin_idx Index of the GPIO pin whose value will be set.
        /// \param set Value the pin state will be set to
        // -------------------------------------------------------------------------------------------------------------
        inline void Set_GPIO_pin(std::uint8_t pin_idx, bool set);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about a receive interrupt is enabled.
        /// \return true, if the receive interrupt is enabled. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Receive_Interrupt_Enabled() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about a transmit interrupt is enabled.
        /// \return true, if the transmit interrupt is enabled. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Transmit_Interrupt_Enabled() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the type of a pending IRQ in the IIR register
        /// \param receive Type of the pending interrupt
        // -------------------------------------------------------------------------------------------------------------
        inline void Set_Pending_IRQ_Type(bool receive);

    private:
        CAUX& m_aux;                         ///< Reference to AUX
        std::uint32_t m_cpu_cycles;          ///< Total number of passed CPU cycles
        TState_Machine_Data m_tx;            ///< TX state machine
        TState_Machine_Data m_rx;            ///< RX state machine
        std::queue<std::uint8_t> m_RX_queue; ///< RX queue of all received characters
    };

} // namespace zero_mate::peripheral