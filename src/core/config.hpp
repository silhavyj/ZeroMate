#pragma once

#include <cstdint>

namespace zero_mate::config
{
    static constexpr std::uint32_t RAM_SIZE = 256 * 1024 * 1024;

    static constexpr std::uint32_t RAM_MAP_ADDR = 0x0;

    static constexpr std::uint32_t GPIO_MAP_ADDR = 0x20200000;
}