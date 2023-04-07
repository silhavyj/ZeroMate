#include <imgui/imgui.h>
#include <ImGuiFileDialog/ImGuiFileDialog.h>
#include <fmt/include/fmt/core.h>

#include "file_window.hpp"
#include "../../core/utils/singleton.hpp"

namespace zero_mate::gui
{
    CFile_Window::CFile_Window(std::shared_ptr<CBus> bus,
                               std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                               std::vector<utils::elf::TText_Section_Record>& source_code)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_code{ source_code }
    , m_logging_system{ utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
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
                                m_cpu->Set_PC(pc);
                                m_source_code = disassembly;
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

                            case utils::elf::NError_Code::Disassembly_Error:
                                m_logging_system.Error("Failed to disassemble the .ELF file");
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