#pragma once

#include <memory>
#include <vector>
#include <cstdint>

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

#include "core/utils/logger/logger.hpp"
#include "core/utils/elf_loader.hpp"

namespace zero_mate::soc
{
    namespace config
    {
        inline const char* const External_Peripherals_Config_File = "peripherals.json";

        inline constexpr std::uint32_t RAM_Size = 512 * 1024 * 1024; // 512 MB
        inline constexpr std::uint32_t RAM_Address = 0x0;
        inline constexpr std::uint32_t GPIO_Address = 0x20200000;
        inline constexpr std::uint32_t IC_Address = 0x2000B200;
        inline constexpr std::uint32_t ARM_Timer_Address = 0x2000B400;
        inline constexpr std::uint32_t Monitor_Address = 0x30000000;
        inline constexpr std::uint32_t TRNG_Address = 0x20104000;

    } // namespace zero_mate::config

    extern utils::CLogging_System& g_logging_system;

    extern std::shared_ptr<peripheral::CRAM> g_ram;
    extern std::shared_ptr<zero_mate::CBus> g_bus;
    extern std::shared_ptr<arm1176jzf_s::CCPU_Core> g_cpu;
    extern std::shared_ptr<coprocessor::CCP15> g_cp15;
    extern std::shared_ptr<peripheral::CInterrupt_Controller> g_ic;
    extern std::shared_ptr<peripheral::CARM_Timer> g_arm_timer;
    extern std::shared_ptr<peripheral::CGPIO_Manager> g_gpio;
    extern std::shared_ptr<peripheral::CMonitor> g_monitor;
    extern std::shared_ptr<peripheral::CTRNG> g_trng;

    extern std::vector<std::shared_ptr<peripheral::IPeripheral>> g_peripherals;
    extern std::vector<IExternal_Peripheral *> g_external_peripherals;

    extern std::vector<utils::elf::TText_Section_Record> g_source_code;

    void Init();

} // namespace zero_mate::soc