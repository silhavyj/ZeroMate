#include <imgui.h>
#include <fmt/format.h>
#include <magic_enum.hpp>

#include "cp15_window.hpp"

namespace zero_mate::gui
{
    CCP15_Window::CCP15_Window(std::shared_ptr<coprocessor::cp15::CCP15> cp15)
    : m_cp15{ cp15 }
    {
    }

    void CCP15_Window::Render()
    {
        if (ImGui::Begin("CP15"))
        {
            if (ImGui::BeginTabBar("##CP15_regs"))
            {
                if (ImGui::BeginTabItem("C1", nullptr))
                {
                    Render_Primary_Register_C1();
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("C2", nullptr))
                {
                    Render_Primary_Register_C2();
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("C3", nullptr))
                {
                    Render_Primary_Register_C3();
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("C7", nullptr))
                {
                    Render_Primary_Register_C7();
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("C8", nullptr))
                {
                    Render_Primary_Register_C8();
                    ImGui::EndTabItem();
                }

                ImGui::EndTabBar();
            }
        }

        ImGui::End();
    }

    void CCP15_Window::Render_Primary_Register_C1()
    {
        const auto cp15_c1 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC1>(coprocessor::cp15::NPrimary_Register::C1);

        ImGui::Text("C0 (0) - Control register");

        if (ImGui::BeginTable("C0 0 (Control register)", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("MMU enabled");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", cp15_c1->Is_Control_Flag_Set(coprocessor::cp15::CC1::NC0_Control_Flags::MMU_Enable))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Data cache enabled");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}",
                        cp15_c1->Is_Control_Flag_Set(coprocessor::cp15::CC1::NC0_Control_Flags::Data_Cache_Enable))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Branch prediction enabled");
            ImGui::TableNextColumn();
            ImGui::Text("%s",
                        fmt::format("{}",
                                    cp15_c1->Is_Control_Flag_Set(
                                    coprocessor::cp15::CC1::NC0_Control_Flags::Branch_Prediction_Enable))
                        .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Instruction cache enable");
            ImGui::TableNextColumn();
            ImGui::Text("%s",
                        fmt::format("{}",
                                    cp15_c1->Is_Control_Flag_Set(
                                    coprocessor::cp15::CC1::NC0_Control_Flags::Instruction_Cache_Enable))
                        .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("High exception vectors enabled");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}",
                        cp15_c1->Is_Control_Flag_Set(coprocessor::cp15::CC1::NC0_Control_Flags::High_Exception_Vectors))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Unaligned access enabled");
            ImGui::TableNextColumn();
            ImGui::Text("%s",
                        fmt::format("{}",
                                    cp15_c1->Is_Control_Flag_Set(
                                    coprocessor::cp15::CC1::NC0_Control_Flags::Unaligned_Memory_Access_Enable))
                        .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("TEX remap enabled");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", cp15_c1->Is_Control_Flag_Set(coprocessor::cp15::CC1::NC0_Control_Flags::TEX_Remap_Enable))
            .c_str());

            ImGui::EndTable();
        }

        ImGui::Separator();
    }

    void CCP15_Window::Render_Primary_Register_C2()
    {
        const auto cp15_c2 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC2>(coprocessor::cp15::NPrimary_Register::C2);

        ImGui::Text("C0 (0) - Translation Table Base 0");

        if (ImGui::BeginTable("C0 (0) - Translation Table Base 0", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Shared");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}",
                        cp15_c2->Is_TTB_Shared(coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_0))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Inner cacheable");
            ImGui::TableNextColumn();
            ImGui::Text("%s",
                        fmt::format("{}",
                                    cp15_c2->Is_TTB_Inner_Cacheable(
                                    coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_0))
                        .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Address");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("0x{:08X}",
                        cp15_c2->Get_TTB_Address(coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_0))
            .c_str());

            ImGui::EndTable();
        }

        ImGui::Separator();

        // TODO create a common function for these two tables

        ImGui::Text("C0 (1) - Translation Table Base 1");

        if (ImGui::BeginTable("C0 (1) - Translation Table Base 1", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Shared");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}",
                        cp15_c2->Is_TTB_Shared(coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_1))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Inner cacheable");
            ImGui::TableNextColumn();
            ImGui::Text("%s",
                        fmt::format("{}",
                                    cp15_c2->Is_TTB_Inner_Cacheable(
                                    coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_1))
                        .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Address");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("0x{:08X}",
                        cp15_c2->Get_TTB_Address(coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_1))
            .c_str());

            ImGui::EndTable();
        }

        ImGui::Separator();

        ImGui::Text("C0 (2) - Translation Table Base Ctrl");

        if (ImGui::BeginTable("C0 (2) - Translation Table Base Ctrl", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Boundary");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", magic_enum::enum_name(cp15_c2->Get_Boundary())).c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("PD0");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", cp15_c2->Is_PD0_Set()).c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("PD1");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", cp15_c2->Is_PD1_Set()).c_str());

            ImGui::EndTable();
        }
    }

    void CCP15_Window::Render_Primary_Register_C3()
    {
        const auto cp15_c3 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC3>(coprocessor::cp15::NPrimary_Register::C3);

        ImGui::Text("C0 (0) - Domain Access Control");

        if (ImGui::BeginTable("C0 (0) - Domain Access Control", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D0");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D0)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D1");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D1)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D2");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D2)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D3");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D3)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D4");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D4)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D5");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D5)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D6");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D6)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D7");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D7)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D8");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D8)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D9");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D9)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D10");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D10)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D11");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D11)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D12");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D12)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D13");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D13)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D14");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D14)))
            .c_str());

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("D15");
            ImGui::TableNextColumn();
            ImGui::Text(
            "%s",
            fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(coprocessor::cp15::CC3::NDomain::D15)))
            .c_str());

            ImGui::EndTable();
        }
    }

    void CCP15_Window::Render_Primary_Register_C7()
    {
        const auto cp15_c7 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC7>(coprocessor::cp15::NPrimary_Register::C7);

        ImGui::Text("C5 (4)");

        if (ImGui::BeginTable("C5 (4)", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Flush Prefetch Buffer");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", cp15_c7->Is_Flush_Prefetch_Buffer_Set()).c_str());

            ImGui::EndTable();
        }

        ImGui::Separator();

        ImGui::Text("C6 (0)");

        if (ImGui::BeginTable("C6 (0)", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Invalidate Entire Data Cache");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", cp15_c7->Is_Invalidate_Entire_Data_Cache_Set()).c_str());

            ImGui::EndTable();
        }

        ImGui::Separator();

        ImGui::Text("C7 (0)");

        if (ImGui::BeginTable("C7 (0)", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Invalidate Both Caches");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", cp15_c7->Is_Invalidate_Both_Caches_Set()).c_str());

            ImGui::EndTable();
        }

        ImGui::Separator();

        ImGui::Text("C10 (4)");

        if (ImGui::BeginTable("C10 (4)", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Data Synchronization Barrier");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", cp15_c7->Is_Data_Synchronization_Barrier_Set()).c_str());

            ImGui::EndTable();
        }
    }

    void CCP15_Window::Render_Primary_Register_C8()
    {
        const auto cp15_c8 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC8>(coprocessor::cp15::NPrimary_Register::C8);

        ImGui::Text("C7 (0)");

        if (ImGui::BeginTable("C7 (0)", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::Text("Invalidate Unified TLB Unlocked Entries");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{}", cp15_c8->Is_Invalidate_Unified_TLB_Unlocked_Entries_Set()).c_str());

            ImGui::EndTable();
        }
    }
}