#include <filesystem>

#include "fmt/include/fmt/core.h"

#include "file_window.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::gui
{
    CFile_Window::CFile_Window(std::shared_ptr<CBus> bus,
                               std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                               utils::elf::Source_Codes_t& source_codes,
                               bool& m_kernel_has_been_loaded,
                               std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals,
                               const bool& cpu_running)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_codes{ source_codes }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_kernel_has_been_loaded{ m_kernel_has_been_loaded }
    , m_peripherals{ peripherals }
    , m_file_browser{ ImGuiFileBrowserFlags_MultipleSelection | ImGuiFileBrowserFlags_CloseOnEsc }
    , m_loading_kernel{ true }
    , m_cpu_running{ cpu_running }
    {
        Init_File_Browser();
    }

    void CFile_Window::Init_File_Browser()
    {
        m_file_browser.SetTitle("Select an ELF file");
        m_file_browser.SetTypeFilters({ ".elf" });
    }

    void CFile_Window::Render()
    {
        if (ImGui::Begin("File"))
        {
            Render_Load_Button("Load Kernel", true);
            Render_Load_Button("Load Process", false);
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
            if (m_cpu_running)
            {
                m_logging_system.Error("The CPU is running. You need to first stop the execution.");
                return;
            }

            Load_ELF_File(m_kernel_filename, true);
        }
    }

    void CFile_Window::Render_Load_Button(const char* name, bool loading_kernel)
    {
        if (ImGui::Button(name))
        {
            if (m_cpu_running)
            {
                m_logging_system.Error("The CPU is running. You need to first stop the execution.");
                return;
            }

            m_loading_kernel = loading_kernel;
            m_file_browser.Open();
        }
    }

    void CFile_Window::Render_File_Browser()
    {
        m_file_browser.Display();

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
            Load_ELF_File(m_file_browser.GetSelected().string(), m_loading_kernel);
        }
        else
        {
            for (const auto& file : m_file_browser.GetMultiSelected())
            {
                Load_ELF_File(file.string(), m_loading_kernel);
            }
        }
    }

    void CFile_Window::Load_ELF_File(const std::string& path, bool loading_kernel)
    {
        const std::string filename = Get_Filename(path);

        if (m_source_codes.contains(filename))
        {
            // clang-format off
            m_logging_system.Error(fmt::format("{} has already been loaded. You may need to close it first",
                                               filename).c_str());
            // clang-format on
        }

        if (loading_kernel)
        {
            // clang-format off
            std::for_each(m_peripherals.begin(),
                          m_peripherals.end(),
                          [](auto& peripheral) -> void {
                peripheral->Reset();
            });
            // clang-format on
        }

        const auto [error_code, pc, code] = utils::elf::Load_ELF(*m_bus, path.c_str(), loading_kernel);

        switch (error_code)
        {
            case utils::elf::NError_Code::OK:
                if (loading_kernel)
                {
                    m_cpu->Reset_Context();
                    m_cpu->Set_PC(pc);
                    m_kernel_has_been_loaded = true;
                    m_kernel_filename = path;
                }
                m_source_codes[filename] = { .kernel = m_loading_kernel, .code = code };
                m_logging_system.Info(fmt::format("{} has been loaded successfully", path).c_str());
                break;

            case utils::elf::NError_Code::ELF_64_Not_Supported:
                // clang-format off
                m_logging_system.Error(fmt::format("64 bit ELF format is not supported by the emulator ({})",
                                                   path).c_str());
                // clang-format on
                break;

            case utils::elf::NError_Code::ELF_Loader_Error:
                // clang-format off
                m_logging_system.Error(fmt::format("Failed to load {}. Make sure you entered a valid"
                                                   " path to a valid ELF file", path).c_str());
                // clang-format on
                break;

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
}