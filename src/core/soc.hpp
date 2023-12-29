// ---------------------------------------------------------------------------------------------------------------------
/// \file spc.hpp
/// \date 16. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the entire system on chip (SoC).
///
/// It creates, hooks up, and provides access to individual peripherals used on the Raspberry Pi Zero board.
/// Any file includes his header file can access all Raspberry Pi Zero components (CPU, RAM, ...)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
#include <vector>
#include <cstdint>
/// \endcond

// Project file imports

#include "zero_mate/utils/logging_system.hpp"
#include "zero_mate/external_peripheral.hpp"

#include "bus.hpp"
#include "arm1176jzf_s/core.hpp"
#include "arm1176jzf_s/mmu/mmu.hpp"
#include "coprocessors/cp15/cp15.hpp"
#include "coprocessors/cp10/cp10.hpp"
#include "peripherals/ram.hpp"
#include "peripherals/interrupt_controller.hpp"
#include "peripherals/arm_timer.hpp"
#include "peripherals/monitor.hpp"
#include "peripherals/trng.hpp"
#include "peripherals/gpio.hpp"
#include "peripherals/bsc.hpp"
#include "peripherals/auxiliary/auxiliary.hpp"

namespace zero_mate::soc
{
    namespace config
    {
        /// Path to the external peripherals config file.
        inline const char* const External_Peripherals_Config_File = "peripherals.json";

        namespace sections
        {
            /// Name of an external peripheral
            inline const char* const Name = "name";

            /// Connection of an external peripheral (GPIO pins, I2C address, etc.)
            inline const char* const Connection = "connection";

            /// Path to the directory where the shared library is located
            inline const char* const Lib_Dir = "lib_dir";

            /// Name of the shared library
            inline const char* const Lib_Name = "lib_name";

        } // namespace sections

        // -------------------------------------------------------------------------------------------------------------
        /// Helper function to convert a number of bytes to megabytes.
        /// \param size Number of bytes to convert
        /// \return Number of megabytes
        // -------------------------------------------------------------------------------------------------------------
        inline constexpr std::uint32_t operator""_MB(std::size_t size)
        {
            return static_cast<std::uint32_t>(size * 1024 * 1024);
        }

        /// Default RAM size
        inline constexpr std::uint32_t RAM_Size = 512_MB; // 512 MB

        /// Default RAM map address (where it is found in the address space)
        inline constexpr std::uint32_t RAM_Address = 0x0;

        /// Default GPIO map address (where it is found in the address space)
        inline constexpr std::uint32_t GPIO_Address = 0x20200000;

        /// Default interrupt controller (IC) map address (where it is found in the address space)
        inline constexpr std::uint32_t IC_Address = 0x2000B200;

        /// Default ARM times map address (where it is found in the address space)
        inline constexpr std::uint32_t ARM_Timer_Address = 0x2000B400;

        /// Default monitor map address (where it is found in the address space)
        inline constexpr std::uint32_t Monitor_Address = 0x30000000;

        /// Default TRNG (random number generator) map address (where it is found in the address space)
        inline constexpr std::uint32_t TRNG_Address = 0x20104000;

        /// Default AUX peripheral address (where it is found in the address space)
        inline constexpr std::uint32_t AUX_Address = 0x20215000;

        /// Default address of the broadcom serial controller 1 (BSC 1)
        inline constexpr std::uint32_t BSC_1_Address = 0x20205000;

        /// Default address of the broadcom serial controller 2 (BSC 2)
        inline constexpr std::uint32_t BSC_2_Address = 0x20804000;

        /// Default address of the broadcom serial controller 3 (BSC 3)
        inline constexpr std::uint32_t BSC_3_Address = 0x20805000;

    } // namespace zero_mate::config

    /// Global reference to a logging system used throughout the project
    extern utils::CLogging_System& g_logging_system;

    /// Global reference to the RAM
    extern std::shared_ptr<peripheral::CRAM> g_ram;

    /// Global reference to the bus which the CPU uses to access memory-mapped peripherals
    extern std::shared_ptr<CBus> g_bus;

    /// Global reference to the CPU
    extern std::shared_ptr<arm1176jzf_s::CCPU_Core> g_cpu;

    /// Global reference to the CP15 (system control coprocessor)
    extern std::shared_ptr<coprocessor::cp15::CCP15> g_cp15;

    /// Global reference to FPU (floating point unit CP10)
    extern std::shared_ptr<coprocessor::cp10::CCP10> g_cp10;

    /// Global reference to the MMU (memory management unit).
    extern std::shared_ptr<arm1176jzf_s::mmu::CMMU> g_mmu;

    /// Global reference to the interrupt controller
    extern std::shared_ptr<peripheral::CInterrupt_Controller> g_ic;

    /// Global reference to the ARM timer
    extern std::shared_ptr<peripheral::CARM_Timer> g_arm_timer;

    /// Global reference to the GPIO pins
    extern std::shared_ptr<peripheral::CGPIO_Manager> g_gpio;

    /// Global reference to the debug monitor
    extern std::shared_ptr<peripheral::CMonitor> g_monitor;

    /// Global reference to the TRNG (random number generator)
    extern std::shared_ptr<peripheral::CTRNG> g_trng;

    /// Collection of all "internal" peripherals (so they can be globally all reset, updated, etc)
    extern std::vector<std::shared_ptr<peripheral::IPeripheral>> g_peripherals;

    /// Collection of all external peripherals that are connected to the system via GPIO pins
    extern std::vector<IExternal_Peripheral*> g_external_peripherals;

    /// Global reference to the auxiliary peripheral (UART, SPI_1, and SPI_2)
    extern std::shared_ptr<peripheral::CAUX> g_aux;

    /// Broadcom serial controller 1 (BSC 1)
    extern std::shared_ptr<peripheral::CBSC> g_bsc_1;

    /// Broadcom serial controller 2 (BSC 2)
    extern std::shared_ptr<peripheral::CBSC> g_bsc_2;

    /// Broadcom serial controller 3 (BSC 3)
    extern std::shared_ptr<peripheral::CBSC> g_bsc_3;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes the system.
    ///
    /// It creates instances of all "internal" peripherals, loads and hooks up external peripherals, etc.
    // -----------------------------------------------------------------------------------------------------------------
    void Init();

} // namespace zero_mate::soc