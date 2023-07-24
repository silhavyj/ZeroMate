// ---------------------------------------------------------------------------------------------------------------------
/// \file aux.hpp
/// \date 24. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the auxiliaries (UART1 & SPI1, and SPI2) used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 2)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <memory>
#include <unordered_set>
/// \endcond

// Project file imports

#include "gpio.hpp"
#include "mini_uart.hpp"
#include "peripheral.hpp"
#include "system_clock_listener.hpp"
#include "interrupt_controller.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CAUX
    /// \brief This class represents the auxiliaries (UART1 & SPI1, and SPI2).
    // -----------------------------------------------------------------------------------------------------------------
    class CAUX final : public IPeripheral, public ISystem_Clock_Listener
    {
    public:
        // Allow the CMini_UART class to have access to private members of this class (regs, ic, gpio, ...)
        friend class CMini_UART;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NAUX_Peripheral
        /// \brief This enumeration represents different auxiliary peripherals.
        // -------------------------------------------------------------------------------------------------------------
        enum class NAUX_Peripheral : std::uint32_t
        {
            Mini_UART = 0, ///< Mini UART
            SPI_1 = 1,     ///< SPI 1
            SPI_2 = 2      ///< SPI 2
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NRegister
        /// \brief This enumeration represents different register associated with the auxiliaries.
        // -------------------------------------------------------------------------------------------------------------
        enum class NRegister : std::uint32_t
        {
            IRQ = 0,     ///< Pending IRQs
            ENABLES = 1, ///< Enable different auxiliaries (Mini UART, SPI1, SPI2)

            // Mini UART registers (not all of them are being used)

            MU_IO = 16,      ///< IO (sent/received data)
            MU_IER = 17,     ///< IER
            MU_IIR = 18,     ///< IIR
            MU_LCR = 19,     ///< LCR (data length 7/8 bits)
            MU_MCR = 20,     ///< MCR
            MU_LSR = 21,     ///< LSR (transmit FIFO clear)
            MU_MSR = 22,     ///< MSR
            MU_SCRATCH = 23, ///< SCRATCH
            MU_CNTL = 24,    ///< CNTL (enable transmission/reception)
            MU_STAT = 25,    ///< STAT
            MU_BAUD = 26,    ///< BAUD (baud rate)

            // TODO Add SPI registers
            Count = 27 ///< Total number of registers (helper record)
        };

        /// Total number of registers
        static constexpr auto Number_Of_Registers = static_cast<std::uint32_t>(NRegister::Count);

        /// Size of a single register
        static constexpr auto Reg_Size = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        /// Collection of read-only registers
        static const std::unordered_set<NRegister> s_read_only_registers;

        // Collection of write-only registers
        static const std::unordered_set<NRegister> s_write_only_registers;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param gpio Reference to the GPIO manager (setting & reading GPIO pins)
        /// \param ic Reference to the interrupt controller (IC)
        // -------------------------------------------------------------------------------------------------------------
        CAUX(std::shared_ptr<CGPIO_Manager> gpio, std::shared_ptr<CInterrupt_Controller> ic);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets/re-initializes the peripheral (IPeripheral interface).
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
        /// \brief Notifies the peripherals about how many CPU cycles have passed (ISystem_Clock_Listener interface).
        /// \param count Number of CPU cycles it took to execute the last instruction
        // -------------------------------------------------------------------------------------------------------------
        void Increment_Passed_Cycles(std::uint32_t count) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether an auxiliary peripheral is enabled or not.
        /// \param peripheral Auxiliary peripheral
        /// \return true, if the peripheral is enabled. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Enabled(NAUX_Peripheral peripheral) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether an auxiliary peripheral has a pending interrupt or not.
        /// \param peripheral Auxiliary peripheral
        /// \return true, if the peripheral has a pending interrupt. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Has_Pending_IRQ(NAUX_Peripheral peripheral) const;

    private:
        std::array<std::uint32_t, Number_Of_Registers> m_regs; ///< Peripheral's registers
        utils::CLogging_System& m_logging_system;              ///< Logging system
        std::shared_ptr<CGPIO_Manager> m_gpio;                 ///< GPIO manager
        std::shared_ptr<CInterrupt_Controller> m_ic;           ///< Interrupt controller

        std::unique_ptr<CMini_UART> m_mini_UART;               ///< Mini UART
    };

} // namespace zero_mate::peripheral