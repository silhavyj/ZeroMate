#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace zero_mate::utils
{
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

    [[nodiscard]] std::vector<TText_Section_Record> Extract_Text_Section_From_List_File(const char* const filename);
}