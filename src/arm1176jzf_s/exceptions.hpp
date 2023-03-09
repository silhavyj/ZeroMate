#pragma once

#include <stdexcept>

#include <fmt/format.h>

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

    class CBus_Fault : public std::runtime_error
    {
    public:
        explicit CBus_Fault(const char* error_msg)
        : std::runtime_error{ error_msg }
        {
        }
    };

    class CUnaligned_Memory_Access : public CBus_Fault
    {
    public:
        explicit CUnaligned_Memory_Access(std::uint32_t addr)
        : CBus_Fault{ fmt::format("Unaligned memory access detected at 0x{:08X}", addr).c_str() }
        {
        }
    };

    class CInvalid_Peripheral_Access : public CBus_Fault
    {
    public:
        explicit CInvalid_Peripheral_Access(std::uint32_t addr)
        : CBus_Fault{ fmt::format("Invalid peripheral access at 0x{:08X}", addr).c_str() }
        {
        }
    };
}