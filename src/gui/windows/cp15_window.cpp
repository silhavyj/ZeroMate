#include <imgui.h>
#include <fmt/format.h>

#include "cp15_window.hpp"

namespace zero_mate::gui
{
    CCP15_Window::CCP15_Window(std::shared_ptr<coprocessor::CCP15> cp15)
    : m_cp15{ cp15 }
    {

    }

    void CCP15_Window::Render()
    {
        if (ImGui::Begin("CP15"))
        {
            Render_Primary_Register_C1();
        }

        ImGui::End();
    }

    void CCP15_Window::Render_Primary_Register_C1()
    {
        ImGui::Text("Primary register C1");

        if (ImGui::BeginTable("C1", 2, TABLE_FLAGS))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Unaligned access");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", m_cp15->Is_Unaligned_Access_Permitted()).c_str());

            ImGui::EndTable();
        }

        ImGui::Separator();
    }
}