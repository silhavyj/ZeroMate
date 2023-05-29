// ---------------------------------------------------------------------------------------------------------------------
/// \file elf_loader.hpp
/// \date 29. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the functionality of an ELF loader.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <vector>
/// \endcond

// Project file imports

#include "../bus.hpp"

namespace zero_mate::utils::elf
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \enum NError_Code
    /// \brief This enumeration defines different error codes that can be returned from #Load_Kernel.
    // -----------------------------------------------------------------------------------------------------------------
    enum class NError_Code : std::uint8_t
    {
        OK,                      ///< All went well
        ELF_64_Not_Supported,    ///< 64-bit ELF format is not supported by the emulator
        ELF_Loader_Error,        ///< Failed to load an ELF file
        Disassembly_Engine_Error ///< Failed to initialize the engine disassembly engine (capstone library)
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \enum NText_Section_Record_Type
    /// \brief This enumeration defines different record types within an ELF file.
    // -----------------------------------------------------------------------------------------------------------------
    enum class NText_Section_Record_Type
    {
        Instruction, ///< The record represents an instruction
        Label        ///< The record represents a label
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \struct TText_Section_Record
    /// \brief This structure represents a single record (line) within an ELF file.
    // -----------------------------------------------------------------------------------------------------------------
    struct TText_Section_Record
    {
        NText_Section_Record_Type type; ///< Type of the type (record type)
        std::uint32_t addr;             ///< Address of the instruction
        std::uint32_t opcode;           ///< Opcode of the instruction (32-bit encoding)
        std::string disassembly;        ///< Disassembly (description) of the instruction
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \struct TStatus
    /// \brief This structure represents the return value of #Load_Kernel.
    // -----------------------------------------------------------------------------------------------------------------
    struct TStatus
    {
        NError_Code error_code;                        ///< Indication of whether something went wrong
        std::uint32_t pc;                              ///< Address of the first instruction (start of execution)
        std::vector<TText_Section_Record> disassembly; ///< Collection of disassembled instructions
    };

    /// \brief Disassembly (description) of an unknown instruction.
    ///
    /// It is used when the capstone library fails to recognize an instruction.
    inline static const char* const UNKNOWN_INSTRUCTION_STR = "Unknown instruction";

    /// Start label (entry point of the program)
    inline static const char* const START_LABEL = "_start";

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Loads a given ELF file (kernel) into the memory.
    /// \param bus Reference to a bus via which the memory is accessed
    /// \param filename Path to the ELF file (kernel) on the user's machine
    /// \return Packed structure containing disassembled instructions as well as a status code
    // -----------------------------------------------------------------------------------------------------------------
    [[nodiscard]] TStatus Load_Kernel(CBus& bus, const char* filename);

} // namespace zero_mate::utils::elf