// ---------------------------------------------------------------------------------------------------------------------
/// \file file_window.cpp
/// \date 09. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that allows the user to load ELF files (kernel + processes).
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <filesystem>
/// \endcond

// 3rd party libraries

#include "fmt/format.h"

// Project file imports

#include "file_window.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::gui
{
    CFile_Window::CFile_Window(std::shared_ptr<CBus> bus,
                               std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                               utils::elf::Source_Codes_t& source_codes,
                               bool& kernel_has_been_loaded,
                               std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals,
                               const bool& cpu_running)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_codes{ source_codes }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_kernel_has_been_loaded{ kernel_has_been_loaded }
    , m_peripherals{ peripherals }
    , m_file_browser{ ImGuiFileBrowserFlags_MultipleSelection | ImGuiFileBrowserFlags_CloseOnEsc }
    , m_loading_kernel{ true }
    , m_cpu_running{ cpu_running }
    {
        Init_File_Browser();
    }

    void CFile_Window::Init_File_Browser()
    {
        m_file_browser.SetTitle("Select an ELF file"); // Title
        m_file_browser.SetTypeFilters({ ".elf" });     // Only allow the user to select ELF files
    }

    void CFile_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("File"))
        {
            // Render the load kernel, load process, and reset button.
            Render_Load_Button("Load Kernel", true);
            Render_Load_Button("Load Processes", false);
            Render_Reload_Button();

            Render_Kernel_Filename();
            Render_File_Browser();
        }

        ImGui::End();
    }

    void CFile_Window::Render_Kernel_Filename()
    {
        ImGui::Separator();
        ImGui::Text("Loaded kernel: %s", m_kernel_filename.c_str());
    }

    void CFile_Window::Render_Reload_Button()
    {
        if (ImGui::Button("Reload kernel"))
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
    }

    void CFile_Window::Render_Load_Button(const char* name, bool loading_kernel)
    {
        if (ImGui::Button(name))
        {
            // The user must stop the execution before loading any input ELF files.
            if (m_cpu_running)
            {
                m_logging_system.Error("The CPU is running. You need to first stop the execution.");
                return;
            }

            // Are we loading a kernel or a process?
            m_loading_kernel = loading_kernel;

            // Open the file browser.
            m_file_browser.Open();
        }
    }

    void CFile_Window::Render_File_Browser()
    {
        m_file_browser.Display();

        // Check if the user has selected any files.
        if (m_file_browser.HasSelected())
        {
            Load_ELF_Files();
            m_file_browser.ClearSelected();
        }
    }

    void CFile_Window::Load_ELF_Files()
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

    void CFile_Window::Load_ELF_File(const std::string& path, bool loading_kernel)
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
                m_source_codes[filename] = { .is_kernel = m_loading_kernel, .code = code };
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

    std::string CFile_Window::Get_Filename(const std::string& path)
    {
        const std::filesystem::path full_path{ path };
        return full_path.filename().string();
    }

} // namespace zero_mate::gui