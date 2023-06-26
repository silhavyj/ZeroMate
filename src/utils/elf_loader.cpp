// ---------------------------------------------------------------------------------------------------------------------
/// \file elf_loader.cpp
/// \date 29. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the functionality of an ELF loader defined in  elf_loader.hpp.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <memory>
#include <cstdlib>
#include <unordered_map>
/// \endcond

// 3rd party library includes

#include <fmt/format.h>
#include <elfio/elfio.hpp>
#include <capstone/capstone.h>
#include <llvm/Demangle/Demangle.h>

// Project file imports

#include "zero_mate/utils/singleton.hpp"
#include "elf_loader.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::utils::elf
{
    // Anonymous namespace to make its content visible only to this translation unit.
    namespace
    {
        // Name of the last .elf file that was loaded
        std::string s_last_filename_loaded{ "" };

        // Alias for labels just to make the code less wordy (addr, <label_name, count>)
        using Labels_t = std::unordered_map<std::uint32_t, std::pair<std::string, std::size_t>>;

        // -------------------------------------------------------------------------------------------------------------
        /// \struct TDisassembly_Result
        /// \brief This structure represents the return value of the #Disassemble_Instructions function.
        // -------------------------------------------------------------------------------------------------------------
        struct TDisassembly_Result
        {
            NError_Code status;                            ///< Status code
            std::vector<TText_Section_Record> disassembly; ///< Disassembled instructions
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Maps an ELF section into the RAM which is accessed through the bus.
        /// \param bus Bus that is used to access the RAM
        /// \param section Section to be mapped to the RAM
        // -------------------------------------------------------------------------------------------------------------
        inline void Map_Section_To_RAM(CBus& bus, ELFIO::Elf64_Addr physical_addr, const ELFIO::section& section)
        {
            // Retrieve the data of the given section.
            const char* data = section.get_data();

            // Make sure it is not the BSS section.
            if (data == nullptr)
            {
                return;
            }

            // Iterate over the data of the section (byte by byte).
            for (ELFIO::Elf_Xword i = 0; i < section.get_size(); ++i)
            {
                const auto value = static_cast<std::uint8_t>(data[i]);
                const auto addr = static_cast<std::uint32_t>(physical_addr + section.get_offset() + i);

                // Map the byte to its corresponding address.
                bus.Write<std::uint8_t>(addr, value);
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Maps a segment of an ELF file to RAM.
        /// \param bus Bus used to access the RAM
        /// \param elf_reader Reference to an ELF reader
        // -------------------------------------------------------------------------------------------------------------
        inline void Map_Segments_To_RAM(CBus& bus, const ELFIO::elfio& elf_reader)
        {
            // Get the total number of ELF segments.
            const ELFIO::Elf_Half number_of_segments = elf_reader.segments.size();

            // Iterate over the segments.
            for (ELFIO::Elf_Half idx = 0; idx < number_of_segments; ++idx)
            {
                // Retrieve the current, number of ELF section that fall under this segment, and its physical address.
                const ELFIO::segment& segment = *elf_reader.segments[idx];
                const ELFIO::Elf_Half number_of_sections = segment.get_sections_num();
                const ELFIO::Elf64_Addr physical_addr = segment.get_physical_address();

                // Go over all ELF sections of the current ELF segment.
                for (ELFIO::Elf_Half i = 0; i < number_of_sections; ++i)
                {
                    // Retrieve the ELF section.
                    const ELFIO::Elf_Half section_idx = segment.get_section_index_at(i);
                    const ELFIO::section& section = *elf_reader.sections[section_idx];

                    // Check whether it should be mapped to the RAM.
                    if ((section.get_flags() & ELFIO::SHF_ALLOC) == ELFIO::SHF_ALLOC)
                    {
                        // Map it to the RAM.
                        Map_Section_To_RAM(bus, physical_addr, section);
                    }
                }
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Demangles the name of a given label.
        /// \param label Name of the label to be demangled
        /// \return Demangled name (if it fails to demangle the name, it returns the original one)
        // -------------------------------------------------------------------------------------------------------------
        inline std::string Demangle_Label_Name(const std::string& label)
        {
            // clang-format off
            // RAII, so we do not have to manually manage the buffer.
            const std::unique_ptr<char, void (*)(void*)> demangled_label(
                llvm::itaniumDemangle(label.c_str(), nullptr, nullptr, nullptr),
                std::free
            );
            // clang-format on

            // Check if demangling was successful
            if (demangled_label != nullptr)
            {
                return demangled_label.get();
            }

            // If it was not, return the original label.
            return label;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Retrieves all labels that are found in the ELF file.
        /// \param elf_reader Reference to an ELF loader (ELF parser)
        /// \return Collection of all labels found in the ELF file (key: address, value: label)
        // -------------------------------------------------------------------------------------------------------------
        inline Labels_t Get_Labels(const ELFIO::elfio& elf_reader)
        {
            // Section with all labels.
            static constexpr const char* const Symbol_Section = ".symtab";

            // Collection of labels to be returned.
            Labels_t labels;

            // Keep track of duplicities, so we can append an index to them.
            std::unordered_map<std::string, std::size_t> name_count;

            // Retrieve all symbols.
            const ELFIO::symbol_section_accessor symbols(elf_reader, elf_reader.sections[Symbol_Section]);

            // Datatype returned from the get_symbol function (we are only interested in the address and name).
            ELFIO::Elf64_Addr addr{};
            std::string name;
            ELFIO::Elf_Xword size{};
            unsigned char bind{};
            unsigned char type{};
            ELFIO::Elf_Half section_index{};
            unsigned char other{};

            // Iterate over all the symbols that were found.
            for (ELFIO::Elf_Xword i = 0; i < symbols.get_symbols_num(); ++i)
            {
                // Retrieve more detailed information about the current symbol.
                symbols.get_symbol(i, name, addr, size, bind, type, section_index, other);

                // Make sure the label is not empty
                if (!name.empty()) [[likely]]
                {
                    // Demangle the name and increment the number of times it has been seen.
                    name = Demangle_Label_Name(name);
                    ++name_count[name];

                    // Add the label with its address to the collection.
                    labels[static_cast<std::uint32_t>(addr)] = { name, name_count[name] };
                }
            }

            // Return the labels.
            return labels;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Disassembles instructions in an ELF section.
        /// \param section ELF section to be disassembled
        /// \param cs_handle Reference to csh that performs the disassembly
        /// \param labels Reference to all labels retrieved from the ELF file
        /// \param result Disassembled instructions
        // -------------------------------------------------------------------------------------------------------------
        inline void Disassemble_Instructions_In_Section(const ELFIO::section& section,
                                                        csh& cs_handle,
                                                        const Labels_t& labels,
                                                        TDisassembly_Result& result)
        {
            auto& logging_system = *CSingleton<CLogging_System>::Get_Instance();

            // Raw data (bytes) of the ELF section.
            const auto* data = std::bit_cast<const uint8_t*>(section.get_data());

            cs_insn* instructions{ nullptr };                         // Disassembled instructions
            bool done{ false };                                       // Has the whole section been processed?
            std::size_t remaining_section_size{ section.get_size() }; // Remaining size to be processed
            std::size_t address_offset{ section.get_address() };      // Offset of the ELF section (virtual addr)

            while (!done)
            {
                instructions = nullptr;

                // Disassemble next set of instructions.
                const auto count = cs_disasm(cs_handle, data, remaining_section_size, address_offset, 0, &instructions);

                // Iterate over all the instruction that have been disassembled.
                for (std::size_t i = 0; i < count; ++i)
                {
                    // Address of the instruction.
                    const auto address = static_cast<std::uint32_t>(instructions[i].address);

                    // Human representation of the instruction (assembly language).
                    const auto instruction_str =
                    std::string(instructions[i].mnemonic) + " " + std::string(instructions[i].op_str);

                    // Reconstruct the opcode of the instruction.
                    const std::uint32_t opcode = (static_cast<std::uint32_t>(instructions[i].bytes[3]) << 24U) |
                                                 (static_cast<std::uint32_t>(instructions[i].bytes[2]) << 16U) |
                                                 (static_cast<std::uint32_t>(instructions[i].bytes[1]) << 8U) |
                                                 (static_cast<std::uint32_t>(instructions[i].bytes[0]) << 0U);

                    // Is there a label at this address?
                    if (labels.contains(address))
                    {
                        // Push_back the label first before you push_back the instruction itself.
                        result.disassembly.push_back({ .type = NText_Section_Record_Type::Label,
                                                       .addr = {},
                                                       .opcode = {},
                                                       .disassembly = labels.at(address).first,
                                                       .index = labels.at(address).second });
                    }

                    // Add the instruction to the result.
                    // clang-format off
                    result.disassembly.push_back({ .type = NText_Section_Record_Type::Instruction,
                                                   .addr = address,
                                                   .opcode = opcode,
                                                   .disassembly = instruction_str,
                                                   .index = 0 });
                    // clang-format on
                }

                cs_free(instructions, count);

                // Update the size of the section that has been processed.
                data += count * sizeof(std::uint32_t);
                remaining_section_size -= count * sizeof(std::uint32_t);
                address_offset += count * sizeof(std::uint32_t);

                // Are we done yet?
                if (remaining_section_size == 0)
                {
                    done = true;
                }
                else
                {
                    // An unknown instruction has been found (capstone failed to disassemble it).
                    result.disassembly.push_back({ .type = NText_Section_Record_Type::Instruction,
                                                   .addr = static_cast<std::uint32_t>(address_offset),
                                                   .opcode = static_cast<std::uint32_t>(*data),
                                                   .disassembly = UNKNOWN_INSTRUCTION_STR,
                                                   .index = 0 });

                    // clang-format off
                    logging_system.Warning(fmt::format("Unknown instruction found at address 0x{:08X} in the "
                                                       ".text section of the ELF file", address_offset).c_str());
                    // clang-format on

                    // Skip the unknown instruction (move on to the next one).
                    data += sizeof(std::uint32_t);
                    remaining_section_size -= sizeof(std::uint32_t);
                    address_offset += sizeof(std::uint32_t);
                }
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Disassembles instructions found in all executable segments of the ELF file.
        /// \param elf_reader Reference to an ELF reader
        /// \return Disassembled instructions
        // -------------------------------------------------------------------------------------------------------------
        inline TDisassembly_Result Disassemble_Instructions(const ELFIO::elfio& elf_reader)
        {
            csh cs_handle{};
            TDisassembly_Result result{};

            // Initialize the capstone library.
            if (cs_open(CS_ARCH_ARM, CS_MODE_ARM, &cs_handle) != CS_ERR_OK)
            {
                result.status = NError_Code::Disassembly_Engine_Error;
                return result;
            }

            // Retrieve all labels found in the .symtab section.
            const Labels_t labels = Get_Labels(elf_reader);

            // Retrieve the total number of ELF segments.
            const ELFIO::Elf_Half number_of_segments = elf_reader.segments.size();

            // Iterate over all segments.
            for (ELFIO::Elf_Half idx = 0; idx < number_of_segments; ++idx)
            {
                // Retrieve the current segment and the total number of its ELF sections.
                const ELFIO::segment& segment = *elf_reader.segments[idx];
                const ELFIO::Elf_Half number_of_sections = segment.get_sections_num();

                // Iterate over all sections.
                for (ELFIO::Elf_Half i = 0; i < number_of_sections; ++i)
                {
                    // Retrieve the current section.
                    const ELFIO::Elf_Half section_idx = segment.get_section_index_at(i);
                    const ELFIO::section& section = *elf_reader.sections[section_idx];

                    // Check if it is an executable section and therefore shall be disassembled.
                    if (((section.get_flags() & ELFIO::SHF_ALLOC) == ELFIO::SHF_ALLOC) &&
                        ((section.get_flags() & ELFIO::SHF_EXECINSTR) == ELFIO::SHF_EXECINSTR))
                    {
                        Disassemble_Instructions_In_Section(section, cs_handle, labels, result);
                    }
                }
            }

            // Close the handler.
            cs_close(&cs_handle);

            return result;
        }
    }

    TStatus Load_Kernel(CBus& bus, const char* filename)
    {
        ELFIO::elfio elf_reader;
        s_last_filename_loaded = filename;

        // Load the kernel using the elfio library.
        if (!elf_reader.load(filename, true))
        {
            return { NError_Code::ELF_Loader_Error, {}, {} };
        }

        // Make sure it is a 32-bit kernel.
        if (elf_reader.get_class() == ELFIO::ELFCLASS64)
        {
            return { NError_Code::ELF_64_Not_Supported, {}, {} };
        }

        // Map the instructions (32-bit values) into the memory via the bus.
        Map_Segments_To_RAM(bus, elf_reader);

        // Disassemble the instructions, so they can be visualized in the GUI.
        const auto disassembly_result = Disassemble_Instructions(elf_reader);

        return {
            disassembly_result.status,                          // Status code
            static_cast<std::uint32_t>(elf_reader.get_entry()), // Address of the first instruction
            disassembly_result.disassembly                      // Disassembled instructions
        };
    }

    TStatus Reload_Kernel(CBus& bus)
    {
        return Load_Kernel(bus, s_last_filename_loaded.c_str());
    }

} // namespace zero_mate::utils::elf