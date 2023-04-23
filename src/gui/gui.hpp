#pragma once

#include <cstdint>

namespace zero_mate::gui
{
    inline const char* const FONT_PATH = "fonts/Cousine-Regular.ttf";
    inline const char* const ICONS_PATH = "fonts/icons/fa-solid-900.ttf";

    namespace config
    {
        inline const char* const CONFIG_FILE = "peripherals.ini";

        inline const char* const RAM_SECTION = "ram";
        inline const char* const GPIO_SECTION = "gpio";
        inline const char* const INTERRUPT_CONTROLLER_SECTION = "interrupt_controller";

        inline constexpr std::uint32_t DEFAULT_RAM_SIZE = 256 * 1024 * 1024;
        inline constexpr std::uint32_t DEFAULT_RAM_MAP_ADDR = 0x0;
        inline constexpr std::uint32_t DEFAULT_GPIO_MAP_ADDR = 0x20200000;
        inline constexpr std::uint32_t DEFAULT_INTERRUPT_CONTROLLER_MAP_ADDR = 0x2020B000;
    }

    int Main_GUI(int argc, const char* argv[]);
}