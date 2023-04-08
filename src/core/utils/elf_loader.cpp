#include <bit>
#include <unordered_map>

#include <fmt/format.h>
#include <elfio/elfio.hpp>
#include <capstone/capstone.h>

#include "singleton.hpp"
#include "elf_loader.hpp"
#include "logger/logger.hpp"

namespace zero_mate::utils::elf
{
    namespace
    {
        struct TDisassembly_Result
        {
            NError_Code status;
            std::vector<TText_Section_Record> disassembly;
        };

        inline void Map_Section_To_RAM(CBus& bus, const ELFIO::section& section)
        {
            const char* data = section.get_data();

            if (data == nullptr)
            {
                return;
            }

            for (ELFIO::Elf_Xword i = 0; i < section.get_size(); ++i)
            {
                const auto value = static_cast<std::uint8_t>(data[i]);
                const auto addr = static_cast<std::uint32_t>(section.get_address() + i);

                bus.Write<std::uint8_t>(addr, value);
            }
        }

        inline void Map_Sections_To_RAM(CBus& bus, const ELFIO::elfio& elf_reader)
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

        inline std::unordered_map<std::uint32_t, std::string> Get_Labels(const ELFIO::elfio& elf_reader)
        {
            static constexpr const char* const SYMBOL_SECTION = ".symtab";

            std::unordered_map<std::uint32_t, std::string> labels;

            const ELFIO::symbol_section_accessor symbols(elf_reader, elf_reader.sections[SYMBOL_SECTION]);
            const auto number_of_symbols = symbols.get_symbols_num();

            ELFIO::Elf64_Addr addr{};
            std::string name;
            ELFIO::Elf_Xword size{};
            unsigned char bind{};
            unsigned char type{};
            ELFIO::Elf_Half section_index{};
            unsigned char other{};

            for (ELFIO::Elf_Xword i = 0; i < number_of_symbols; ++i)
            {
                symbols.get_symbol(i, name, addr, size, bind, type, section_index, other);

                if (type == ELFIO::STB_WEAK)
                {
                    labels[static_cast<std::uint32_t>(addr)] = name;
                }
            }

            return labels;
        }

        inline TDisassembly_Result Disassemble_Instructions(const ELFIO::elfio& elf_reader)
        {
            static constexpr const char* const TEXT_SECTION = ".text";

            TDisassembly_Result result{};
            csh handle{};

            if (cs_open(CS_ARCH_ARM, CS_MODE_ARM, &handle) != CS_ERR_OK)
            {
                result.status = NError_Code::Disassembly_Engine_Error;
                return result;
            }

            auto& logging_system = CSingleton<CLogging_System>::Get_Instance();
            const auto labels = Get_Labels(elf_reader);
            const auto* const text_section = elf_reader.sections[TEXT_SECTION];
            const auto* data = std::bit_cast<const uint8_t*>(text_section->get_data());

            cs_insn* instructions{ nullptr };
            bool done{ false };
            std::size_t remaining_section_size{ text_section->get_size() };
            std::size_t address_offset{ text_section->get_address() };

            while (!done)
            {
                instructions = nullptr;

                const auto count = cs_disasm(handle, data, remaining_section_size, address_offset, 0, &instructions);

                for (std::size_t i = 0; i < count; ++i)
                {
                    const auto address = static_cast<std::uint32_t>(instructions[i].address);
                    const auto instruction_str = std::string(instructions[i].mnemonic) + " " + std::string(instructions[i].op_str);

                    const std::uint32_t opcode = (static_cast<std::uint32_t>(instructions[i].bytes[3]) << 24U) |
                                                 (static_cast<std::uint32_t>(instructions[i].bytes[2]) << 16U) |
                                                 (static_cast<std::uint32_t>(instructions[i].bytes[1]) << 8U) |
                                                 (static_cast<std::uint32_t>(instructions[i].bytes[0]) << 0U);

                    if (labels.contains(address))
                    {
                        result.disassembly.push_back({ NText_Section_Record_Type::Label, {}, {}, labels.at(address) });
                    }

                    result.disassembly.push_back({ NText_Section_Record_Type::Instruction,
                                                   address,
                                                   opcode,
                                                   instruction_str });
                }

                cs_free(instructions, count);

                data += count * sizeof(std::uint32_t);
                remaining_section_size -= count * sizeof(std::uint32_t);
                address_offset += count * sizeof(std::uint32_t);

                if (remaining_section_size == 0)
                {
                    done = true;
                }
                else
                {
                    result.disassembly.push_back({ NText_Section_Record_Type::Instruction,
                                                   static_cast<std::uint32_t>(address_offset),
                                                   static_cast<std::uint32_t>(*data),
                                                   UNKNOWN_INSTRUCTION_STR });

                    logging_system.Warning(fmt::format("Unknown instruction found at address 0x{:08X} in the .text section of the ELF file", address_offset).c_str());

                    data += sizeof(std::uint32_t);
                    remaining_section_size -= sizeof(std::uint32_t);
                    address_offset += sizeof(std::uint32_t);
                }
            }

            cs_close(&handle);

            return result;
        }
    }

    TStatus Load_Kernel(CBus& bus, const char* filename)
    {
        ELFIO::elfio elf_reader;

        if (!elf_reader.load(filename, true))
        {
            return { NError_Code::ELF_Loader_Error, {}, {} };
        }

        if (elf_reader.get_class() == ELFIO::ELFCLASS64)
        {
            return { NError_Code::ELF_64_Not_Supported, {}, {} };
        }

        Map_Sections_To_RAM(bus, elf_reader);
        const auto disassembly_result = Disassemble_Instructions(elf_reader);

        return {
            disassembly_result.status,
            static_cast<std::uint32_t>(elf_reader.get_entry()),
            disassembly_result.disassembly
        };
    }
}