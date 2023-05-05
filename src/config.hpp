#pragma once

#include <cstdint>

namespace zero_mate::config
{
    inline const char* const CONFIG_FILE = "peripherals.ini";

    // TODO group these up into a structure?
    inline const char* const RAM_SECTION = "ram";
    inline const char* const GPIO_SECTION = "gpio";
    inline const char* const INTERRUPT_CONTROLLER_SECTION = "interrupt_controller";
    inline const char* const ARM_TIMER_SECTION = "arm_timer";
    inline const char* const MONITOR_SECTION = "monitor";

    // TODO group these up into a structure?
    inline constexpr std::uint32_t DEFAULT_RAM_SIZE = 256 * 1024 * 1024;
    inline constexpr std::uint32_t DEFAULT_RAM_MAP_ADDR = 0x0;
    inline constexpr std::uint32_t DEFAULT_GPIO_MAP_ADDR = 0x20200000;
    inline constexpr std::uint32_t DEFAULT_INTERRUPT_CONTROLLER_MAP_ADDR = 0x2020B000;
    inline constexpr std::uint32_t DEFAULT_ARM_TIMER_MAP_ADDR = 0x2000B400;
    inline constexpr std::uint32_t DEFAULT_MONITOR_MAP_ADDR = 0x30000000;
}