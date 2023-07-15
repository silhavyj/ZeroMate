// ---------------------------------------------------------------------------------------------------------------------
/// \file cp15_window.cpp
/// \date 10. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that displays data (information) related to coprocessor 15.
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party libraries

#include "fmt/format.h"
#include "magic_enum.hpp"

// Project file imports

#include "cp15_window.hpp"

namespace zero_mate::gui
{
    CCP15_Window::CCP15_Window(std::shared_ptr<coprocessor::cp15::CCP15> cp15)
    : m_cp15{ cp15 }
    {
    }

    void CCP15_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("CP15"))
        {
            Render_Tab_Bar();
        }

        ImGui::End();
    }

    void CCP15_Window::Render_Tab_Bar()
    {
        // Render a label (primary registers).
        ImGui::Text("Primary registers");

        if (ImGui::BeginTabBar("##CP15_regs"))
        {
            // Render C1 primary register.
            if (ImGui::BeginTabItem("C1", nullptr))
            {
                Render_Primary_Register_C1();
                ImGui::EndTabItem();
            }

            // Render C2 primary register.
            if (ImGui::BeginTabItem("C2", nullptr))
            {
                Render_Primary_Register_C2();
                ImGui::EndTabItem();
            }

            // Render C3 primary register.
            if (ImGui::BeginTabItem("C3", nullptr))
            {
                Render_Primary_Register_C3();
                ImGui::EndTabItem();
            }

            // Render C7 primary register.
            if (ImGui::BeginTabItem("C7", nullptr))
            {
                Render_Primary_Register_C7();
                ImGui::EndTabItem();
            }

            // Render C8 primary register.
            if (ImGui::BeginTabItem("C8", nullptr))
            {
                Render_Primary_Register_C8();
                ImGui::EndTabItem();
            }

            ImGui::EndTabBar();
        }
    }

    void CCP15_Window::Render_Primary_Register_C1()
    {
        // So we do not have to type the whole namespace within this function.
        using namespace coprocessor::cp15;

        // Retrieve primary register C1.
        const auto cp15_c1 = m_cp15->Get_Primary_Register<CC1>(NPrimary_Register::C1);

        // clang-format off
        // Render secondary register C0 (0).
        Render_Table("C0 (0) - Control register", {
            {
                "MMU enabled",
                fmt::format("{}", cp15_c1->Is_Control_Flag_Set(CC1::NC0_Control_Flags::MMU_Enable))
            },
            {
                "Data cache enabled",
                fmt::format("{}", cp15_c1->Is_Control_Flag_Set(CC1::NC0_Control_Flags::Data_Cache_Enable))
            },
            {
                "Branch prediction enabled",
                fmt::format("{}", cp15_c1->Is_Control_Flag_Set(CC1::NC0_Control_Flags::Branch_Prediction_Enable))
            },
            {
                "Instruction cache enable",
                fmt::format("{}", cp15_c1->Is_Control_Flag_Set(CC1::NC0_Control_Flags::Instruction_Cache_Enable))
            },
            {
                "High exception vectors enabled",
                fmt::format("{}", cp15_c1->Is_Control_Flag_Set(CC1::NC0_Control_Flags::High_Exception_Vectors))
            },
            {
                "Unaligned access enabled",
                fmt::format("{}", cp15_c1->Is_Control_Flag_Set(CC1::NC0_Control_Flags::Unaligned_Memory_Access_Enable))
            },
            {
                "TEX remap enabled",
                fmt::format("{}", cp15_c1->Is_Control_Flag_Set(CC1::NC0_Control_Flags::TEX_Remap_Enable))
            },
        });
        // clang-format on
    }

    void CCP15_Window::Render_Primary_Register_C2()
    {
        // So we do not have to type the whole namespace within this function.
        using namespace coprocessor::cp15;

        // Retrieve primary register C2.
        const auto cp15_c2 = m_cp15->Get_Primary_Register<CC2>(NPrimary_Register::C2);

        // clang-format off
        // Render secondary register C0 (0).
        Render_Table("C0 (0) - Translation Table Base 0", {
            {
                "Shared",
                fmt::format("{}", cp15_c2->Is_TTB_Shared(CC2::NCRm_C0_Register::Translation_Table_Base_0))
            },
            {
                "Inner cacheable",
                fmt::format("{}", cp15_c2->Is_TTB_Inner_Cacheable(CC2::NCRm_C0_Register::Translation_Table_Base_0))
            },
            {
                "Address",
                fmt::format("0x{:08X}", cp15_c2->Get_TTB_Address(CC2::NCRm_C0_Register::Translation_Table_Base_0))
            }
        });

        ImGui::Separator();

        // Render secondary register C0 (1).
        Render_Table("C0 (1) - Translation Table Base 1", {
            {
                "Shared",
                fmt::format("{}", cp15_c2->Is_TTB_Shared(CC2::NCRm_C0_Register::Translation_Table_Base_1))
            },
            {
                "Inner cacheable",
                fmt::format("{}", cp15_c2->Is_TTB_Inner_Cacheable(CC2::NCRm_C0_Register::Translation_Table_Base_1))
            },
            {
                "Address",
                fmt::format("0x{:08X}", cp15_c2->Get_TTB_Address(CC2::NCRm_C0_Register::Translation_Table_Base_1))
            }
        });

        ImGui::Separator();

        // Render secondary register C0 (2).
        Render_Table("C0 (2) - Translation Table Base Ctrl", {
            {
                "Boundary",
                fmt::format("{}", magic_enum::enum_name(cp15_c2->Get_Boundary_Type()))
            },
            {
                "PD0",
                fmt::format("{}", cp15_c2->Is_PD0_Set())
            },
            {
                "PD1",
                fmt::format("{}", cp15_c2->Is_PD1_Set())
            }
        });
        // clang-format on
    }

    void CCP15_Window::Render_Primary_Register_C3()
    {
        // So we do not have to type the whole namespace within this function.
        using namespace coprocessor::cp15;

        // Retrieve primary register C3.
        const auto cp15_c3 = m_cp15->Get_Primary_Register<CC3>(NPrimary_Register::C3);

        // clang-format off
        // Render domains (secondary register C0 (0)).
        Render_Table("C0 (0) - Domain Access Control", {
            {
                "D0",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D0))).c_str()
            },
            {
                "D1",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D1))).c_str()
            },
            {
                "D2",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D2))).c_str()
            },
            {
                "D3",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D3))).c_str()
            },
            {
                "D4",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D4))).c_str()
            },
            {
                "D5",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D5))).c_str()
            },
            {
                "D6",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D6))).c_str()
            },
            {
                "D7",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D7))).c_str()
            },
            {
                "D8",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D8))).c_str()
            },
            {
                "D9",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D9))).c_str()
            },
            {
                "D10",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D10))).c_str()
            },
            {
                "D11",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D11))).c_str()
            },
            {
                "D12",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D12))).c_str()
            },
            {
                "D13",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D13))).c_str()
            },
            {
                "D14",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D14))).c_str()
            },
            {
                "D15",
                fmt::format("{}", magic_enum::enum_name(cp15_c3->Get_Domain_Value(CC3::NDomain::D15))).c_str()
            }
        });
        // clang-format on
    }

    void CCP15_Window::Render_Primary_Register_C7()
    {
        // So we do not have to type the whole namespace within this function.
        using namespace coprocessor::cp15;

        // Retrieve primary register C7.
        const auto cp15_c7 = m_cp15->Get_Primary_Register<CC7>(NPrimary_Register::C7);

        // clang-format off
        // Render secondary register C5 (4).
        Render_Table("C5 (4)", {
            {
                "Flush Prefetch Buffer",
                fmt::format("{}", cp15_c7->Is_Flush_Prefetch_Buffer_Set())
            }
        });

        ImGui::Separator();

        // Render secondary register C6 (0).
        Render_Table("C6 (0)", {
            {
                "Invalidate Entire Data Cache",
                fmt::format("{}", cp15_c7->Is_Invalidate_Entire_Data_Cache_Set())
            }
        });

        ImGui::Separator();

        // Render secondary register C7 (0).
        Render_Table("C7 (0)", {
            {
                "Invalidate Both Caches",
                fmt::format("{}", cp15_c7->Is_Invalidate_Both_Caches_Set())
            }
        });

        ImGui::Separator();

        // Render secondary register C10 (4).
        Render_Table("C10 (4)", {
            {
                "Data Synchronization Barrier",
                fmt::format("{}", cp15_c7->Is_Data_Synchronization_Barrier_Set())
            }
        });
        // clang-format on
    }

    void CCP15_Window::Render_Primary_Register_C8()
    {
        // So we do not have to type the whole namespace within this function.
        using namespace coprocessor::cp15;

        // Retrieve primary register C8.
        const auto cp15_c8 = m_cp15->Get_Primary_Register<CC8>(NPrimary_Register::C8);

        // clang-format off
        // Render secondary register C7 (0).
        Render_Table("C7 (0)", { 
            {
                "Invalidate Unified TLB Unlocked Entries",
                fmt::format("{}", cp15_c8->Is_Invalidate_Unified_TLB_Unlocked_Entries_Set())
            } 
        });
        // clang-format on
    }

    void CCP15_Window::Render_Table(const char* title, const std::vector<std::pair<std::string, std::string>>& data)
    {
        // Render the title of the table.
        ImGui::Text("%s", title);

        if (ImGui::BeginTable(title, 2, Table_Flags))
        {
            // Table headings
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            // Render table data row by row.
            for (const auto& [key, value] : data)
            {
                ImGui::TableNextRow();
                ImGui::TableNextColumn();
                ImGui::Text("%s", key.c_str());
                ImGui::TableNextColumn();
                ImGui::Text("%s", value.c_str());
            }

            ImGui::EndTable();
        }
    }

} // namespace zero_mate::gui