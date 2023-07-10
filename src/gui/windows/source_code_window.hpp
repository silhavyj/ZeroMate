// ---------------------------------------------------------------------------------------------------------------------
/// \file source_code_window.hpp
/// \date 09. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that displays loaded ELF files (disassembled instructions of the source code).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <unordered_map>
/// \endcond

// Project file imports

#include "../window.hpp"
#include "../../core/arm1176jzf_s/core.hpp"
#include "../../utils/elf_loader.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSource_Code_Window
    /// \brief This class represents a windows that displays the contents of loaded ELF files.
    // -----------------------------------------------------------------------------------------------------------------
    class CSource_Code_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu Reference to the CPU (adding/removing breakpoints)
        /// \param source_codes Collection of loaded ELF files (source codes)
        /// \param scroll_to_curr_line Indication that the window should scroll to the current line of execution
        /// \param cpu_running Indication of whether the CPU is running or not
        // -------------------------------------------------------------------------------------------------------------
        explicit CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     utils::elf::Source_Codes_t& source_codes,
                                     bool& scroll_to_curr_line,
                                     const bool& cpu_running);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the window (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a block of code (a single function/method).
        /// \param source_code Disassembled instructions
        /// \param idx Index of the current instruction (current line)
        // -------------------------------------------------------------------------------------------------------------
        void Render_Code_Block(const utils::elf::TSource_Code& source_code, std::size_t& idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the block of code which is currently being rendered should be highlighted or not.
        ///
        /// A block of code (function) should be highlighted if it contains the instruction
        /// that currently being executed.
        ///
        /// \param source_code Disassembled instructions
        /// \param idx Index of the current instruction (current line)
        /// \return true, if the block should be highlighted. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Should_Code_Block_Be_Highlighted(const utils::elf::TSource_Code& source_code,
                                                            std::size_t idx) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Extracts the class name from a given label (function name).
        ///
        /// If the function is not associated with any class, an empty string is returned.
        ///
        /// \param label Function name
        /// \return Name of the class the function is associated with
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static std::string Extract_Class_Name(std::string label);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the disassembled contents of all ELF loaded into the emulator.
        // -------------------------------------------------------------------------------------------------------------
        void Render_Source_Codes();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Removes all tabs (ELF source files) which the user has closed.
        // -------------------------------------------------------------------------------------------------------------
        void Remove_Closed_Tabs();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a single tab (ELF source file).
        /// \param filename Filename (e.g. kernel.elf)
        /// \param source_code Disassembled instructions
        // -------------------------------------------------------------------------------------------------------------
        void Render_Tab(const std::string& filename, const utils::elf::TSource_Code& source_code);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a table that containing disassembled instructions.
        /// \param source_code Disassembled instructions
        /// \param idx Index of the current instruction (current line)
        // -------------------------------------------------------------------------------------------------------------
        void Render_Code_Table(const utils::elf::TSource_Code& source_code, std::size_t& idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Skips a block of code (function) which is collapsed and therefore not visible to the user.
        /// \param source_code Disassembled instructions
        /// \param idx Index of the current instruction (current line)
        // -------------------------------------------------------------------------------------------------------------
        void Skip_Collapsed_Block(const utils::elf::TSource_Code& source_code, std::size_t& idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the body of a source code table.
        /// \param source_code Disassembled instructions
        /// \param idx Index of the current instruction (current line)
        // -------------------------------------------------------------------------------------------------------------
        void Render_Table_Body(const utils::elf::TSource_Code& source_code, std::size_t& idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders table headings (breakpoint, address, opcode, disassembly)
        /// \param source_code Disassembled instructions
        /// \param idx Index of the current instruction (current line)
        // -------------------------------------------------------------------------------------------------------------
        static void Render_Table_Headings(const utils::elf::TSource_Code& source_code, std::size_t& idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a single breakpoint.
        /// \param source_code Disassembled instructions
        /// \param idx Index of the current instruction (current line)
        // -------------------------------------------------------------------------------------------------------------
        void Render_Breakpoint(const utils::elf::TSource_Code& source_code, std::size_t& idx);

    private:
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;        ///< CPU
        utils::elf::Source_Codes_t& m_source_codes;            ///< Collection of all ELF files loaded into the emulator
        std::unordered_map<std::uint32_t, bool> m_breakpoints; ///< Collection of all breakpoints [addr, active]
        bool& m_scroll_to_curr_line;                           ///< Should the windows scroll to the line of execution?
        const bool& m_cpu_running;                             ///< Is the CPU running?
        std::unordered_map<std::string, bool> m_open_tabs;     ///< Collection of open tabs (ELF source files)
    };

} // namespace zero_mate::gui