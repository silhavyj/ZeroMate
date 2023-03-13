#include <elfio/elfio.hpp>

#include "elf_loader.hpp"

namespace zero_mate::utils::elf
{
    static inline void Map_Section_To_RAM(CBus& bus, const ELFIO::section& section)
    {
        const char* data = section.get_data();

        for (ELFIO::Elf_Xword i = 0; i < section.get_size(); ++i)
        {
            const auto value = static_cast<std::uint8_t>(data[i]);
            const auto addr = static_cast<std::uint32_t>(section.get_address() + i);

            bus.Write<std::uint8_t>(addr, value);
        }
    }

    static inline void Map_Sections_To_RAM(CBus& bus, const ELFIO::elfio& elf_reader)
    {
        const ELFIO::Elf_Half number_of_sections = elf_reader.sections.size();

        for (ELFIO::Elf_Half idx = 0; idx < number_of_sections; ++idx)
        {
            const ELFIO::section& section = *elf_reader.sections[idx];

            if ((section.get_flags() & ELFIO::SHF_ALLOC) == ELFIO::SHF_ALLOC)
            {
                Map_Section_To_RAM(bus, section);
            }
        }
    }

    TStatus Load_Kernel(CBus& bus, const char* filename)
    {
        ELFIO::elfio elf_reader;

        if (!elf_reader.load(filename, true))
        {
            return { NError_Code::Error, {} };
        }

        if (elf_reader.get_class() == ELFIO::ELFCLASS64)
        {
            return { NError_Code::ELF_64_Not_Supported, {} };
        }

        Map_Sections_To_RAM(bus, elf_reader);

        return { NError_Code::OK, static_cast<std::uint32_t>(elf_reader.get_entry()) };
    }
}