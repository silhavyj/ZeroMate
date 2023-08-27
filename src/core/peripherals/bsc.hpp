// ---------------------------------------------------------------------------------------------------------------------
/// \file bsc.hpp
/// \date 20. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the BSC peripheral used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 3)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <queue>
/// \endcond

// Project file imports

#include "gpio.hpp"
#include "peripheral.hpp"
#include "system_clock_listener.hpp"
#include "zero_mate/utils/logging_system.hpp"

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CBSC
    /// \brief This class represents the BSC peripheral used in BCM2835.
    // -----------------------------------------------------------------------------------------------------------------
    class CBSC final : public IPeripheral, public ISystem_Clock_Listener
    {
    public:
        /// I2C SDA (data) pin on the Raspberry Pi Zero board
        static constexpr std::uint32_t SDA_Pin_Idx = 2;

        /// I2C SCL (clock) pin on the Raspberry Pi Zero board
        static constexpr std::uint32_t SCL_Pin_Idx = 3;

        /// Slave address length
        static constexpr std::uint8_t Slave_Addr_Length = 7;

        /// Data length
        static constexpr std::uint8_t Data_Length = 8;

        // Clock speed
        static constexpr std::uint32_t CPU_Cycles_Per_Update = 30;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NRegister
        /// \brief Enumeration of the BSC registers.
        // -------------------------------------------------------------------------------------------------------------
        enum class NRegister : std::uint32_t
        {
            Control = 0,           ///< Control register
            Status,                ///< Status register
            Data_Length,           ///< Data length (number of bytes to be sent/received)
            Slave_Address,         ///< Address of the target device (slave)
            Data_FIFO,             ///< Interaction with the data FIFO (read/write)
            Clock_Div,             ///< Clock div (not used)
            Data_Delay,            ///< Clock delay (not used)
            Clock_Stretch_Timeout, ///< Clock stretch timeout (not used)
            Count                  ///< Help record (total number of registers)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NControl_Flags
        /// \brief Enumeration of different flags of the control register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NControl_Flags : std::uint32_t
        {
            I2C_Enable = 0b1U << 15U,    ///< Enable the I2C peripheral
            Start_Transfer = 0b1U << 7U, ///< Begin data transfer
            FIFO_Clear = 4U,             ///< Clear the data FIFO
            Read_Transfer = 0b1U << 0U   ///< Begin read transfer
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NStatus_Flags
        /// \brief Enumeration of different flags of the status register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NStatus_Flags : std::uint32_t
        {
            Transfer_Done = 0b1U << 1U ///< Transfer is done
        };

        /// Total number of the peripheral's registers
        static constexpr auto Number_Of_Registers = static_cast<std::size_t>(NRegister::Count);

        /// Size of a single register
        static constexpr auto Reg_Size = static_cast<std::uint32_t>(sizeof(std::uint32_t));

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param gpio Reference to a GPIO manager (changing the state of GPIO pins)
        // -------------------------------------------------------------------------------------------------------------
        explicit CBSC(std::shared_ptr<CGPIO_Manager> gpio);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets/re-initializes the interrupt controller (IPeripheral interface).
        // -------------------------------------------------------------------------------------------------------------
        void Reset() noexcept override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the size of the peripheral (IPeripheral interface).
        /// \return number of register * register size
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Writes data to the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) where the data will be written
        /// \param data Pointer to the data to be written to the peripheral
        /// \param size Size of the data to be written to the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads data from the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) from which the data will be read
        /// \param data Pointer to a buffer the data will be copied into
        /// \param size Size of the data to read from the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Notifies the peripheral about how many CPU cycles have passed (ISystem_Clock_Listener interface).
        /// \param count Number of CPU cycles it took to execute the last instruction
        // -------------------------------------------------------------------------------------------------------------
        void Increment_Passed_Cycles(std::uint32_t count) override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NState_Machine
        /// \brief Enumeration of different states of the I2C state machine.
        // -------------------------------------------------------------------------------------------------------------
        enum class NState_Machine : std::uint8_t
        {
            Start_Bit, ///< Send a start bit (start of a transaction)
            Address,   ///< Send slave's address
            RW,        ///< Are we going to read from the device or write to it?
            ACK_1,     ///< The slave device is supposed to send ACK_1
            Data,      ///< Data payload
            ACK_2,     ///< The slave device is supposed to send ACK_2
            Stop_Bit   ///< Stop bit (end of a transaction)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum TTransaction
        /// \brief Representation of a single data transaction.
        // -------------------------------------------------------------------------------------------------------------
        struct TTransaction
        {
            NState_Machine state{ NState_Machine::Start_Bit }; ///< Current state of the state machine
            std::uint32_t address{ 0x0 };                      ///< Slave address
            std::uint32_t length{ 0 };                         ///< Total number of bytes
            std::uint8_t addr_idx{ Slave_Addr_Length };        ///< Index of the current bit of the slave's address
            std::uint8_t data_idx{ Data_Length };              ///< Index of the current bit of the current data payload
            bool read{ false };                                ///< Are we going to read from the device or write to it?
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NSCL_State
        /// \brief State of the clock signal.
        // -------------------------------------------------------------------------------------------------------------
        enum class NSCL_State
        {
            SDA_Change, ///< SDA shall be updated
            SCL_Low,    ///< SCL shall go low
            SCL_High    ///< SCL shall go high
        };

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Adds data to the FIFO.
        // -------------------------------------------------------------------------------------------------------------
        inline void Add_Data_To_FIFO();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs actions after the control register has been written to.
        // -------------------------------------------------------------------------------------------------------------
        inline void Control_Reg_Callback();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears the FIFO.
        // -------------------------------------------------------------------------------------------------------------
        inline void Clear_FIFO();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a new data transfer (transaction) should begin.
        /// \return true, if a new transaction should begin. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Should_Transaction_Begin();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the FIFO should be cleared or not.
        /// \return true, if the FIFO should be cleared. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Should_FIFO_Be_Cleared();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the state of a given GPIO pin.
        /// \param pin_idx Index of the GPIO pin whose state will be set
        /// \param set Should the state of the pin be set to high or low?
        // -------------------------------------------------------------------------------------------------------------
        inline void Set_GPIO_pin(std::uint8_t pin_idx, bool set);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Terminates an ongoing transaction (stop bit).
        // -------------------------------------------------------------------------------------------------------------
        inline void Terminate_Transaction();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the I2C state machine.
        // -------------------------------------------------------------------------------------------------------------
        void I2C_Update();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends a start bit (start of a frame).
        // -------------------------------------------------------------------------------------------------------------
        inline void I2C_Send_Start_Bit();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends another bit of the slave's address.
        // -------------------------------------------------------------------------------------------------------------
        inline void I2C_Send_Slave_Address();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends the RW bit.
        // -------------------------------------------------------------------------------------------------------------
        inline void I2C_Send_RW_Bit();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the slave device has sent ACK_1 as expected.
        // -------------------------------------------------------------------------------------------------------------
        inline void I2C_Receive_ACK_1();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends another bit of the data payload.
        // -------------------------------------------------------------------------------------------------------------
        inline void I2C_Send_Data();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the slave device has sent ACK_2 as expected.
        // -------------------------------------------------------------------------------------------------------------
        inline void I2C_Receive_ACK_2();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sends a stop bit (end of a frame).
        // -------------------------------------------------------------------------------------------------------------
        inline void I2C_Send_Stop_Bit();

    private:
        std::shared_ptr<CGPIO_Manager> m_gpio;                 ///< GPIO manager
        std::array<std::uint32_t, Number_Of_Registers> m_regs; ///< Peripheral's registers
        std::queue<std::uint8_t> m_fifo;                       ///< Data FIFO
        std::uint32_t m_cpu_cycles;                            ///< Number of passed CPU cycles
        bool m_transaction_in_progress;                        ///< Is there an ongoing transaction?
        TTransaction m_transaction;                            ///< Current transaction
        NSCL_State m_SCL_state;                                ///< State of the clock line (SCL)
        utils::CLogging_System& m_logging_system;              ///< Logging system
    };

} // namespace zero_mate::peripheral