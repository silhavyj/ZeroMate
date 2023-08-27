// ---------------------------------------------------------------------------------------------------------------------
/// \file file_window.hpp
/// \date 09. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a top bar menu that allows the user to load ELF files (kernel + processes).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// 3rd party libraries

#include "imgui.h"
#include "imfilebrowser.h"

// Project file imports

#include "../window.hpp"
#include "../../core/arm1176jzf_s/core.hpp"
#include "../../core/bus.hpp"
#include "../../utils/elf_loader.hpp"
#include "zero_mate/utils/logging_system.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CTop_Bar_Menu
    /// \brief This class represents a top bar through which the user can load ELF files.
    // -----------------------------------------------------------------------------------------------------------------
    class CTop_Bar_Menu final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param bus Reference to the system bus through which the kernel is mapped into RAM
        /// \param cpu Reference to the CPU for resetting its context
        /// \param source_codes Collection of all ELF files loaded into the emulator
        /// \param kernel_has_been_loaded Flag indicating whether a kernel has been loaded or not
        /// \param peripherals Collection of all peripherals (reset purposes)
        /// \param cpu_running Flag indicating whether the CPU is running or not
        /// \param kernel_filename Name of the loaded kernel
        // -------------------------------------------------------------------------------------------------------------
        explicit CTop_Bar_Menu(std::shared_ptr<CBus> bus,
                               std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                               utils::elf::Source_Codes_t& source_codes,
                               bool& kernel_has_been_loaded,
                               std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals,
                               const bool& cpu_running,
                               std::string& kernel_filename);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the bar (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the file browser.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_File_Browser();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the file browser.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_File_Browser();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Shows the about window of the application.
        // -------------------------------------------------------------------------------------------------------------
        inline void Show_About_Window();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Loads ELF files selected by the user using the file browser.
        // -------------------------------------------------------------------------------------------------------------
        inline void Load_ELF_Files();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Opens up a file browser.
        /// \param loading_kernel Flag indication whether the user is loading a kernel or a process.
        // -------------------------------------------------------------------------------------------------------------
        inline void Open_File_Browser(bool loading_kernel);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reloads the kernel.
        // -------------------------------------------------------------------------------------------------------------
        inline void Reload_Kernel();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Loads a single ELF file.
        /// \param path Path to the ELF file to be loaded
        /// \param loading_kernel Indication of whether the file should be mapped into the RAM (only kernels do)
        // -------------------------------------------------------------------------------------------------------------
        inline void Load_ELF_File(const std::string& path, bool loading_kernel);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a filename of a given filepath.
        /// \param path Filepath
        /// \return Filename
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static std::string Get_Filename(const std::string& path);

    private:
        std::shared_ptr<CBus> m_bus;                                          ///< System bus
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;                       ///< CPU
        utils::elf::Source_Codes_t& m_source_codes;                           ///< Collection of loaded ELF file
        utils::CLogging_System& m_logging_system;                             ///< Logging system
        bool& m_kernel_has_been_loaded;                                       ///< Has the kernel been loaded?
        std::vector<std::shared_ptr<peripheral::IPeripheral>>& m_peripherals; ///< Collection of peripherals
        ImGui::FileBrowser m_file_browser;                                    ///< File browser
        bool m_loading_kernel;                                                ///< Is a kernel being loaded?
        const bool& m_cpu_running;                                            ///< Is the CPU running?
        std::string& m_kernel_filename;                                       ///< Filepath of the kernel
        bool m_show_about_window;                                             ///< Show the about windnow
    };

} // namespace zero_mate::gui