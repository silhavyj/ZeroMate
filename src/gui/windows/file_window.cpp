#include <imgui/imgui.h>
#include <ImGuiFileDialog/ImGuiFileDialog.h>
#include <fmt/include/fmt/core.h>
#include <filesystem>

#include "file_window.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::gui
{
    CFile_Window::CFile_Window(
    std::shared_ptr<CBus> bus,
    std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
    std::unordered_map<std::string, std::vector<utils::elf::TText_Section_Record>>& source_codes,
    bool& elf_file_has_been_loaded,
    std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_codes{ source_codes }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_elf_file_has_been_loaded{ elf_file_has_been_loaded }
    , m_peripherals{ peripherals }
    {
    }

    void CFile_Window::Render()
    {
        if (ImGui::Begin("File"))
        {
            static bool s_open_elf{ false };
            static std::string s_elf_full_path{};

            if (ImGui::Button("Open .ELF"))
            {
                if (!s_open_elf)
                {
                    ImGuiFileDialog::Instance()->OpenDialog("ChooseFileDlgKey", "Choose File", ".elf", ".");
                    s_open_elf = true;
                }
            }

            ImGui::SameLine();

            if (ImGuiFileDialog::Instance()->Display("ChooseFileDlgKey"))
            {
                if (ImGuiFileDialog::Instance()->IsOk())
                {
                    if (s_open_elf)
                    {
                        s_elf_full_path = ImGuiFileDialog::Instance()->GetFilePathName();

                        const std::filesystem::path full_path{ s_elf_full_path };
                        const std::string elf_filename = full_path.filename().string();

                        if (m_source_codes.contains(elf_filename))
                        {
                            m_logging_system.Error(
                            fmt::format("{} has already been loaded. You may need to close it first", elf_filename)
                            .c_str());
                            goto cleanup;
                        }

                        // TODO think of a better way to detect that it is the kernel being loaded

                        // Reset peripherals.
                        if (elf_filename == "kernel.elf")
                        {
                            std::for_each(m_peripherals.begin(), m_peripherals.end(), [](auto& peripheral) -> void {
                                peripheral->Reset();
                            });
                        }

                        const auto [error_code, pc, disassembly] =
                        utils::elf::Load_ELF(*m_bus, s_elf_full_path.c_str(), elf_filename == "kernel.elf");

                        switch (error_code)
                        {
                            case utils::elf::NError_Code::OK:
                                if (elf_filename == "kernel.elf")
                                {
                                    m_cpu->Reset_Context();
                                    m_cpu->Set_PC(pc);
                                }
                                m_source_codes[elf_filename] = disassembly;
                                m_logging_system.Info(
                                fmt::format("{} has been loaded successfully", s_elf_full_path.c_str()).c_str());
                                m_elf_file_has_been_loaded = true;
                                break;

                            case utils::elf::NError_Code::ELF_64_Not_Supported:
                                m_logging_system.Error("64 bit ELF format is not supported by the emulator");
                                break;

                            case utils::elf::NError_Code::ELF_Loader_Error:
                                m_logging_system.Error(
                                "Failed to load the ELF file. Make sure you entered a valid path to a valid ELF file");
                                break;

                            case utils::elf::NError_Code::Disassembly_Engine_Error:
                                m_logging_system.Error("Failed to initialize a disassembly engine");
                                break;
                        }
                    }
                }
            cleanup:
                s_open_elf = false;
                ImGuiFileDialog::Instance()->Close();
            }
        }

        ImGui::End();
    }
}