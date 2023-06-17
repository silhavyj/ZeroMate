// ---------------------------------------------------------------------------------------------------------------------
/// \file spc.hpp
/// \date 16. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defined the entire system on chip (SoC).
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

#include <zero_mate/external_peripheral.hpp>

#include "core/bus.hpp"
#include "core/arm1176jzf_s/core.hpp"
#include "core/coprocessors/cp15.hpp"
#include "core/peripherals/ram.hpp"
#include "core/peripherals/interrupt_controller.hpp"
#include "core/peripherals/arm_timer.hpp"
#include "core/peripherals/monitor.hpp"
#include "core/peripherals/trng.hpp"
#include "core/peripherals/gpio.hpp"

#include "zero_mate/utils/logger.hpp"

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

            /// GPIO pins an external peripherals is connected to
            inline const char* const Pins = "pins";

            /// Path to the directory where the shared library is located
            inline const char* const Lib_Dir = "lib_dir";

            /// Name of the shared library
            inline const char* const Lib_Name = "lib_name";

        } // namespace sections

        /// Default RAM size
        inline constexpr std::uint32_t RAM_Size = 512 * 1024 * 1024; // 512 MB

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

    } // namespace zero_mate::config

    /// Global reference to a logging system used throughout the project
    extern utils::CLogging_System& g_logging_system;

    /// Global reference to the RAM
    extern std::shared_ptr<peripheral::CRAM> g_ram;

    /// Global reference to the bus which the CPU uses to access memory-mapped peripherals
    extern std::shared_ptr<zero_mate::CBus> g_bus;

    /// Global reference to the CPU
    extern std::shared_ptr<arm1176jzf_s::CCPU_Core> g_cpu;

    /// Global reference to the CP15 (system control coprocessor)
    extern std::shared_ptr<coprocessor::CCP15> g_cp15;

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

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes the system.
    ///
    /// It creates instances of all "internal" peripherals, loads and hooks up external peripherals, etc.
    // -----------------------------------------------------------------------------------------------------------------
    void Init();

} // namespace zero_mate::soc