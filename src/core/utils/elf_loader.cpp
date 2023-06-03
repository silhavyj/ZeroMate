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

#include "singleton.hpp"
#include "elf_loader.hpp"
#include "logger/logger.hpp"

namespace zero_mate::utils::elf
{
    // Anonymous namespace to make its content visible only to this translation unit.
    namespace
    {
        std::string s_last_filename_loaded{""};

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
        inline void Map_Section_To_RAM(CBus& bus, const ELFIO::section& section)
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
                const auto addr = static_cast<std::uint32_t>(section.get_address() + i);

                // Map the byte to its corresponding address.
                bus.Write<std::uint8_t>(addr, value);
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Maps sections of an ELF file into the RAM.
        /// \param bus Bus that is used to access the RAM
        /// \param elf_reader Reference to an ELF reader (ELF parser)
        // -------------------------------------------------------------------------------------------------------------
        inline void Map_Sections_To_RAM(CBus& bus, const ELFIO::elfio& elf_reader)
        {
            // Retrieve all sections from the ELF reader.
            const ELFIO::Elf_Half number_of_sections = elf_reader.sections.size();

            // Iterate over the sections and map them to RAM one by one.
            for (ELFIO::Elf_Half idx = 0; idx < number_of_sections; ++idx)
            {
                // Get the current section
                const ELFIO::section& section = *elf_reader.sections[idx];

                // Should this section be mapped?
                if ((section.get_flags() & ELFIO::SHF_ALLOC) == ELFIO::SHF_ALLOC)
                {
                    Map_Section_To_RAM(bus, section);
                }
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Retrieves all labels that are found in the ELF file.
        /// \param elf_reader Reference to an ELF loader (ELF parser)
        /// \return Collection of all labels found in the ELF file (key: address, value: label)
        // -------------------------------------------------------------------------------------------------------------
        inline std::unordered_map<std::uint32_t, std::string> Get_Labels(const ELFIO::elfio& elf_reader)
        {
            // Section with all labels.
            static constexpr const char* const SYMBOL_SECTION = ".symtab";

            std::unordered_map<std::uint32_t, std::string> labels;

            // The _start label is located at the address of the first instruction.
            labels[static_cast<std::uint32_t>(elf_reader.get_entry())] = START_LABEL;

            // Retrieve all symbols.
            const ELFIO::symbol_section_accessor symbols(elf_reader, elf_reader.sections[SYMBOL_SECTION]);

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

                if (type == ELFIO::STB_WEAK)
                {
                    // Add the label with its address to the collection.
                    labels[static_cast<std::uint32_t>(addr)] = name;
                }
            }

            return labels;
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
        /// \brief Disassembles an ELF file.
        /// \param elf_reader Reference to an ELF reader (ELF parser)
        /// \return Result of the disassembly process
        // -------------------------------------------------------------------------------------------------------------
        inline TDisassembly_Result Disassemble_Instructions(const ELFIO::elfio& elf_reader)
        {
            // Code section
            static constexpr const char* const TEXT_SECTION = ".text";

            csh handle{};
            TDisassembly_Result result{};
            auto& logging_system = *CSingleton<CLogging_System>::Get_Instance();

            // Initialize the capstone library.
            if (cs_open(CS_ARCH_ARM, CS_MODE_ARM, &handle) != CS_ERR_OK)
            {
                result.status = NError_Code::Disassembly_Engine_Error;
                return result;
            }

            // Retrieve all labels found in the .symtab section.
            const auto labels = Get_Labels(elf_reader);

            // Get the .text section and the data stored in it.
            const auto* const text_section = elf_reader.sections[TEXT_SECTION];
            const auto* data = std::bit_cast<const uint8_t*>(text_section->get_data());

            cs_insn* instructions{ nullptr };                               // Disassembled instructions
            bool done{ false };                                             // Has the whole section been processed?
            std::size_t remaining_section_size{ text_section->get_size() }; // Remaining size to be processed
            std::size_t address_offset{ text_section->get_address() };      // Offset to disassemble insts. from

            while (!done)
            {
                instructions = nullptr;

                // Disassemble next set of instruction.
                const auto count = cs_disasm(handle, data, remaining_section_size, address_offset, 0, &instructions);

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
                        const auto demangled_label = Demangle_Label_Name(labels.at(address));
                        result.disassembly.push_back({ NText_Section_Record_Type::Label, {}, {}, demangled_label });
                    }

                    // Add the instruction to the result.
                    // clang-format off
                    result.disassembly.push_back({ NText_Section_Record_Type::Instruction,
                                                   address, opcode,
                                                   instruction_str });
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
                    result.disassembly.push_back({ NText_Section_Record_Type::Instruction,
                                                   static_cast<std::uint32_t>(address_offset),
                                                   static_cast<std::uint32_t>(*data),
                                                   UNKNOWN_INSTRUCTION_STR });

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

            // Close the handler.
            cs_close(&handle);

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
        Map_Sections_To_RAM(bus, elf_reader);

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