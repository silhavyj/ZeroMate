// ---------------------------------------------------------------------------------------------------------------------
/// \file file_window.cpp
/// \date 09. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a top bar menu that allows the user to load ELF files (kernel + processes).
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <filesystem>
/// \endcond

// 3rd party libraries

#include "fmt/format.h"

// Project file imports

#include "top_bar_menu.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::gui
{
    CTop_Bar_Menu::CTop_Bar_Menu(std::shared_ptr<CBus> bus,
                                 std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                 utils::elf::Source_Codes_t& source_codes,
                                 bool& kernel_has_been_loaded,
                                 std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals,
                                 const bool& cpu_running,
                                 std::string& kernel_filename)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_codes{ source_codes }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_kernel_has_been_loaded{ kernel_has_been_loaded }
    , m_peripherals{ peripherals }
    , m_file_browser{ ImGuiFileBrowserFlags_MultipleSelection | ImGuiFileBrowserFlags_CloseOnEsc }
    , m_loading_kernel{ true }
    , m_cpu_running{ cpu_running }
    , m_kernel_filename{ kernel_filename }
    {
        Init_File_Browser();
    }

    void CTop_Bar_Menu::Init_File_Browser()
    {
        m_file_browser.SetTitle("Select an ELF file"); // Title
        m_file_browser.SetTypeFilters({ ".elf" });     // Only allow the user to select ELF files
    }

    void CTop_Bar_Menu::Render()
    {
        // Render a menu bar
        if (ImGui::BeginMainMenuBar())
        {
            // File tab
            if (ImGui::BeginMenu("File"))
            {
                if (ImGui::BeginMenu("Load"))
                {
                    // Load a kernel
                    if (ImGui::MenuItem("Load Kernel", nullptr))
                    {
                        Open_File_Browser(true);
                    }

                    // Load processes
                    if (ImGui::MenuItem("Load Processes", nullptr))
                    {
                        Open_File_Browser(false);
                    }

                    ImGui::EndMenu();
                }

                // Reload the kernel
                if (ImGui::MenuItem("Reload kernel", nullptr))
                {
                    Reload_Kernel();
                }

                ImGui::EndMenu();
            }

            ImGui::EndMainMenuBar();
        }

        // Render the file browser.
        Render_File_Browser();
    }

    void CTop_Bar_Menu::Open_File_Browser(bool loading_kernel)
    {
        // The user must stop the execution before loading any input ELF files.
        if (m_cpu_running)
        {
            m_logging_system.Error("The CPU is running. You need to first stop the execution.");
        }
        else
        {
            // Are we loading a kernel or a process?
            m_loading_kernel = loading_kernel;

            // Open the file browser.
            m_file_browser.Open();
        }
    }

    void CTop_Bar_Menu::Reload_Kernel()
    {
        // Do not allow the user to reload the kernel if the CPU is still running.
        if (m_cpu_running)
        {
            m_logging_system.Error("The CPU is running. You need to first stop the execution.");
            return;
        }

        // Reload the kernel.
        Load_ELF_File(m_kernel_filename, true);
    }

    void CTop_Bar_Menu::Render_File_Browser()
    {
        m_file_browser.Display();

        // Check if the user has selected any files.
        if (m_file_browser.HasSelected())
        {
            Load_ELF_Files();
            m_file_browser.ClearSelected();
        }
    }

    void CTop_Bar_Menu::Load_ELF_Files()
    {
        if (m_loading_kernel)
        {
            // Load the kernel and map it into the RAM.
            Load_ELF_File(m_file_browser.GetSelected().string(), m_loading_kernel);
        }
        else
        {
            // Load all process ELF files the user has selected.
            for (const auto& file : m_file_browser.GetMultiSelected())
            {
                Load_ELF_File(file.string(), m_loading_kernel);
            }
        }
    }

    void CTop_Bar_Menu::Load_ELF_File(const std::string& path, bool loading_kernel)
    {
        // Get the filename from the given path.
        const std::string filename = Get_Filename(path);

        // Make sure such filename has not been loaded yet.
        if (!loading_kernel && m_source_codes.contains(filename)) [[unlikely]]
        {
            // clang-format off
            m_logging_system.Error(fmt::format("{} has already been loaded. You may need to close it first",
                                               filename).c_str());
            // clang-format on
            return;
        }

        // Reset all peripherals if a kernel is being loaded.
        if (loading_kernel)
        {
            // Erase the previous kernel.
            m_source_codes.erase(filename);

            // clang-format off
            std::for_each(m_peripherals.begin(),
                          m_peripherals.end(),
                          [](auto& peripheral) -> void {
                peripheral->Reset();
            });
            // clang-format on
        }

        // Load the ELF file.
        const auto [error_code, pc, code] = utils::elf::Load_ELF(*m_bus, path.c_str(), loading_kernel);

        // Check for any error codes.
        switch (error_code)
        {
            // All went well.
            case utils::elf::NError_Code::OK:
                // Reset the CPU is a kernel has just been loaded,
                if (loading_kernel)
                {
                    m_cpu->Reset_Context();
                    m_cpu->Set_PC(pc);
                    m_kernel_has_been_loaded = true;
                    m_kernel_filename = path;
                }

                // Add the disassembled ELF file into the collection of all loaded source codes.
                m_source_codes[filename] = { .is_kernel = loading_kernel, .code = code };
                m_logging_system.Info(fmt::format("{} has been loaded successfully", path).c_str());
                break;

            // ELF 64 is not supported by the emulator.
            case utils::elf::NError_Code::ELF_64_Not_Supported:
                // clang-format off
                m_logging_system.Error(fmt::format("64 bit ELF format is not supported by the emulator ({})",
                                                   path).c_str());
                // clang-format on
                break;

            // Invalid path/file.
            case utils::elf::NError_Code::ELF_Loader_Error:
                // clang-format off
                m_logging_system.Error(fmt::format("Failed to load {}. Make sure you entered a valid"
                                                   " path to a valid ELF file", path).c_str());
                // clang-format on
                break;

            // Failed to initialize the disassembly engine.
            case utils::elf::NError_Code::Disassembly_Engine_Error:
                m_logging_system.Error("Failed to initialize a disassembly engine");
                break;
        }
    }

    std::string CTop_Bar_Menu::Get_Filename(const std::string& path)
    {
        const std::filesystem::path full_path{ path };
        return full_path.filename().string();
    }

} // namespace zero_mate::gui