#include <imgui/imgui.h>
#include <ImGuiFileDialog/ImGuiFileDialog.h>
#include <fmt/core.h>

#include "file_window.hpp"
#include "../utils/elf_loader.hpp"

namespace zero_mate::gui
{
    CFile_Window::CFile_Window(std::shared_ptr<CBus> bus,
                               std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                               std::vector<utils::TText_Section_Record>& source_code)
    : m_bus{ bus }
    , m_cpu{ cpu }
    , m_source_code{ source_code }
    {
    }

    void CFile_Window::Render()
    {
        ImGui::Begin("File");

        static std::string s_filepath{};

        // TODO change these to an enum -> switch
        static bool s_open_elf{ false };
        static bool s_open_list{ false };

        if (ImGui::Button("Open .ELF"))
        {
            if (!s_open_elf && !s_open_list)
            {
                ImGuiFileDialog::Instance()->OpenDialog("ChooseFileDlgKey", "Choose File", ".elf", ".");
                s_open_elf = true;
            }
        }
        if (ImGui::Button("Open .list"))
        {
            if (!s_open_elf && !s_open_list)
            {
                ImGuiFileDialog::Instance()->OpenDialog("ChooseFileDlgKey", "Choose File", ".list", ".");
                s_open_list = true;
            }
        }

        if (ImGuiFileDialog::Instance()->Display("ChooseFileDlgKey"))
        {
            if (ImGuiFileDialog::Instance()->IsOk())
            {
                s_filepath = ImGuiFileDialog::Instance()->GetFilePathName();

                if (s_open_elf)
                {
                    const auto [error_code, pc] = utils::elf::Load_Kernel(*m_bus, s_filepath.c_str());
                    if (error_code != utils::elf::NError_Code::OK)
                    {
                        // TODO
                    }

                    m_cpu->Set_PC(pc);
                }
                else
                {
                    m_source_code = utils::Extract_Text_Section_From_List_File(s_filepath.c_str());
                }

                s_open_elf = false;
                s_open_list = false;
            }

            ImGuiFileDialog::Instance()->Close();
        }

        ImGui::End();
    }
}