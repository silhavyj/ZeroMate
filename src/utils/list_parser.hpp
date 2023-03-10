#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace zero_mate::utils
{
    struct TText_Section_Record
    {
        std::uint32_t addr;
        std::uint32_t opcode;
        std::string desc;
    };

    [[nodiscard]] std::vector<TText_Section_Record> Extract_Text_Section_From_List_File(const char* const filename);
}