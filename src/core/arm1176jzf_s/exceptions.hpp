#pragma once

#include <stdexcept>

#include "fmt/format.h"

namespace zero_mate::arm1176jzf_s::exceptions
{
    class CUndefined_Instruction : public std::runtime_error
    {
    public:
        CUndefined_Instruction()
        : std::runtime_error{ "Undefined instruction" }
        {
        }
    };

    class CSoftware_Interrupt : public std::runtime_error
    {
    public:
        CSoftware_Interrupt()
        : std::runtime_error{ "Software interrupt" }
        {
        }
    };

    class CData_Abort : public std::runtime_error
    {
    public:
        explicit CData_Abort(const char* error_msg)
        : std::runtime_error{ error_msg }
        {
        }
    };

    class CUnaligned_Memory_Access : public CData_Abort
    {
    public:
        explicit CUnaligned_Memory_Access(std::uint32_t addr)
        : CData_Abort{ fmt::format("Unaligned memory access detected at 0x{:08X}", addr).c_str() }
        {
        }
    };

    class CInvalid_Peripheral_Access : public CData_Abort
    {
    public:
        explicit CInvalid_Peripheral_Access(std::uint32_t addr)
        : CData_Abort{ fmt::format("Invalid peripheral access at 0x{:08X}", addr).c_str() }
        {
        }
    };
}