#include <imgui/imgui.h>
#include <ImGuiFileDialog/ImGuiFileDialog.h>
#include <fmt/include/fmt/core.h>

#include "file_window.hpp"
#include "../../core/utils/elf_loader.hpp"
#include "../../core/utils/singleton.hpp"

namespace zero_mate::gui
{
    CFile_Window::CFile_Window(std::shared_ptr<CBus> bus,
                               std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                               std::vector<utils::TText_Section_Record>& source_code)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_code{ source_code }
    , m_logging_system{ utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
    }

    void CFile_Window::Render()
    {
        ImGui::Begin("File");

        // TODO change these to an enum -> switch
        static bool s_open_elf{ false };
        static bool s_open_list{ false };
        static std::string s_elf_filename{};
        static std::string s_list_filename{};

        if (ImGui::Button("Open .ELF"))
        {
            if (!s_open_elf && !s_open_list)
            {
                ImGuiFileDialog::Instance()->OpenDialog("ChooseFileDlgKey", "Choose File", ".elf", ".");
                s_open_elf = true;
            }
        }

        ImGui::SameLine();
        ImGui::Text("%s", s_elf_filename.c_str());

        if (ImGui::Button("Open .list"))
        {
            if (!s_open_elf && !s_open_list)
            {
                ImGuiFileDialog::Instance()->OpenDialog("ChooseFileDlgKey", "Choose File", ".list", ".");
                s_open_list = true;
            }
        }

        ImGui::SameLine();
        ImGui::Text("%s", s_list_filename.c_str());

        if (ImGuiFileDialog::Instance()->Display("ChooseFileDlgKey"))
        {
            if (ImGuiFileDialog::Instance()->IsOk())
            {
                if (s_open_elf)
                {
                    s_elf_filename = ImGuiFileDialog::Instance()->GetFilePathName();
                    const auto [error_code, pc] = utils::elf::Load_Kernel(*m_bus, s_elf_filename.c_str());

                    switch (error_code)
                    {
                        case utils::elf::NError_Code::OK:
                            m_cpu->Set_PC(pc);
                            break;

                        case utils::elf::NError_Code::ELF_64_Not_Supported:
                            m_logging_system.Error("64 bit ELF format is not supported by the emulator");
                            break;

                        case utils::elf::NError_Code::Error:
                            m_logging_system.Error("Failed to load the ELF file. Make sure you entered a valid path to a valid ELF file");
                            break;
                    }
                }
                else
                {
                    s_list_filename = ImGuiFileDialog::Instance()->GetFilePathName();
                    m_source_code = utils::Extract_Text_Section_From_List_File(s_list_filename.c_str());
                }
            }

            s_open_elf = false;
            s_open_list = false;

            ImGuiFileDialog::Instance()->Close();
        }

        ImGui::End();
    }
}