#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <vector>
/// \endcond

#include "../bus.hpp"

namespace zero_mate::utils::elf
{
    enum class NError_Code : std::uint8_t
    {
        OK,
        ELF_64_Not_Supported,
        ELF_Loader_Error,
        Disassembly_Engine_Error
    };

    enum class NText_Section_Record_Type
    {
        Instruction,
        Label
    };

    struct TText_Section_Record
    {
        NText_Section_Record_Type type;
        std::uint32_t addr;
        std::uint32_t opcode;
        std::string disassembly;
    };

    struct TStatus
    {
        NError_Code error_code;
        std::uint32_t pc;
        std::vector<TText_Section_Record> disassembly;
    };

    inline static const char* const UNKNOWN_INSTRUCTION_STR = "Unknown instruction";
    inline static const char* const START_LABEL = "_start";

    [[nodiscard]] TStatus Load_Kernel(CBus& bus, const char* filename);
}