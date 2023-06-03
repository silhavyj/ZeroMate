#include <imgui/imgui.h>
#include <ImGuiFileDialog/ImGuiFileDialog.h>
#include <fmt/include/fmt/core.h>

#include "file_window.hpp"
#include "../../core/utils/singleton.hpp"

namespace zero_mate::gui
{
    CFile_Window::CFile_Window(std::shared_ptr<CBus> bus,
                               std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                               std::vector<utils::elf::TText_Section_Record>& source_code,
                               bool& elf_file_has_been_loaded,
                               std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_code{ source_code }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_elf_file_has_been_loaded{ elf_file_has_been_loaded }
    , m_peripherals{ peripherals }
    {
    }

    void CFile_Window::Reset_Emulator(std::uint32_t pc)
    {
        m_cpu->Reset_Context();
        m_cpu->Set_PC(pc);
        std::for_each(m_peripherals.begin(), m_peripherals.end(), [](auto& peripheral) -> void {
            peripheral->Reset();
        });
    }

    void CFile_Window::Render()
    {
        if (ImGui::Begin("File"))
        {
            static bool s_open_elf{ false };
            static std::string s_elf_filename{};

            if (ImGui::Button("Open .ELF"))
            {
                if (!s_open_elf)
                {
                    ImGuiFileDialog::Instance()->OpenDialog("ChooseFileDlgKey", "Choose File", ".elf", ".");
                    s_open_elf = true;
                }
            }

            ImGui::SameLine();
            ImGui::Text("%s", s_elf_filename.c_str());

            if (ImGuiFileDialog::Instance()->Display("ChooseFileDlgKey"))
            {
                if (ImGuiFileDialog::Instance()->IsOk())
                {
                    if (s_open_elf)
                    {
                        s_elf_filename = ImGuiFileDialog::Instance()->GetFilePathName();
                        const auto [error_code, pc, disassembly] = utils::elf::Load_Kernel(*m_bus, s_elf_filename.c_str());

                        switch (error_code)
                        {
                            case utils::elf::NError_Code::OK:
                                Reset_Emulator(pc);
                                m_source_code = disassembly;
                                m_logging_system.Info(fmt::format("The .ELF file has been loaded successfully. The program starts at 0x{:08X}", pc).c_str());
                                m_elf_file_has_been_loaded = true;
                                break;

                            case utils::elf::NError_Code::ELF_64_Not_Supported:
                                m_logging_system.Error("64 bit ELF format is not supported by the emulator");
                                break;

                            case utils::elf::NError_Code::ELF_Loader_Error:
                                m_logging_system.Error("Failed to load the ELF file. Make sure you entered a valid path to a valid ELF file");
                                break;

                            case utils::elf::NError_Code::Disassembly_Engine_Error:
                                m_logging_system.Error("Failed to initialize a disassembly engine");
                                break;
                        }
                    }
                }

                s_open_elf = false;

                ImGuiFileDialog::Instance()->Close();
            }
        }

        ImGui::End();
    }
}