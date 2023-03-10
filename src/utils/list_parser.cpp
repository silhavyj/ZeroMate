#include <fstream>
#include <sstream>

#include "list_parser.hpp"

namespace zero_mate::utils
{
    [[nodiscard]] static std::string Trim(const std::string& str, char c = ' ')
    {
        const auto str_begin = str.find_first_not_of(c);

        if (str_begin == std::string::npos)
        {
            return "";
        }

        const auto str_end = str.find_last_not_of(c);
        const auto str_range = str_end - str_begin + 1;

        return str.substr(str_begin, str_range);
    }

    [[nodiscard]] std::vector<std::string> Split(const std::string& str, char c)
    {
        std::vector<std::string> parts{};
        std::stringstream sstream{ str };
        std::string part{};

        while (getline(sstream, part, c))
        {
            if (!part.empty())
            {
                parts.emplace_back(part);
            }
        }

        return parts;
    }

    [[nodiscard]] static TText_Section_Record Create_Record(std::string& line)
    {
        static constexpr int BASE = 16;

        TText_Section_Record record{};

        line = Trim(line);
        const auto parts = Split(line, '\t');

        if (parts.size() >= 3)
        {
            record.addr = static_cast<std::uint32_t>(std::stoul(Trim(parts[0], ':'), nullptr, BASE));
            record.opcode = static_cast<std::uint32_t>(std::stoul(parts[1], nullptr, BASE));

            for (std::size_t i = 2; i < parts.size(); ++i)
            {
                record.desc += parts[i] + '\t';
            }

            if (!record.desc.empty() && record.desc[record.desc.length() - 1] == ' ')
            {
                record.desc.pop_back();
            }
        }

        return record;
    }

    std::vector<TText_Section_Record> Extract_Text_Section_From_List_File(const char* const filename)
    {
        static constexpr const char* const START_TXT_SECTION = "Disassembly of section .text:";
        static constexpr const char* const END_TXT_SECTION = "Disassembly of section";

        std::uint32_t state{ 0 };
        std::string line{};
        bool end{ false };
        std::vector<TText_Section_Record> text_section{};
        std::ifstream file{ filename, std::ios::in };

        if (!file)
        {
            return text_section;
        }

        while (std::getline(file, line) && !end)
        {
            switch (state)
            {
                case 0:
                    if (line == START_TXT_SECTION)
                    {
                        state = 1;
                    }
                    break;

                case 1:
                    if (line.starts_with(END_TXT_SECTION))
                    {
                        end = true;
                    }
                    else if (!line.empty() && line[0] == ' ')
                    {
                        text_section.emplace_back(Create_Record(line));
                    }
                    break;

                default:
                    break;
            }
        }

        return text_section;
    }
}