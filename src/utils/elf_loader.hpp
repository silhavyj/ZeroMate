#pragma once

#include "../bus/bus.hpp"

namespace zero_mate::utils::elf
{
    enum class NError_Code : std::uint8_t
    {
        OK,
        ELF_64_Not_Supported,
        Error
    };

    struct TStatus
    {
        NError_Code error_code;
        std::uint32_t pc;
    };

    [[nodiscard]] TStatus Load_Kernel(CBus& bus, const char* filename);
}