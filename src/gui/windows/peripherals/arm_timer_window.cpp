// ---------------------------------------------------------------------------------------------------------------------
/// \file arm_timer_window.cpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that visualizes the contents of the ARM timer registers.
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party libraries

#include "fmt/format.h"

// Project file imports

#include "arm_timer_window.hpp"

namespace zero_mate::gui
{
    CARM_Timer_Window::CARM_Timer_Window(const std::shared_ptr<peripheral::CARM_Timer>& arm_timer)
    : m_arm_timer{ arm_timer }
    {
    }

    void CARM_Timer_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("ARM timer"))
        {
            // Render ARM timer registers.
            Render_Registers();

            // Render the bits of the control register.
            Render_Control_Register();
        }

        ImGui::End();
    }

    void CARM_Timer_Window::Render_Table(const char* title,
                                         const std::vector<std::pair<std::string, std::string>>& data)
    {
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

    void CARM_Timer_Window::Render_Registers()
    {
        ImGui::Text("Registers");

        // clang-format off
        Render_Table("ARM_timer_registers", {
            {
                "Load",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Load))
            },
            {
                "Value",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Value))
            },
            {
                "IRQ Clear",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::IRQ_Clear))
            },
            {
                "IRQ Raw",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::IRQ_Raw))
            },
            {
                "IRQ Masked",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::IRQ_Masked))
            },
            {
                "Reload",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Reload))
            },
            {
                "Pre divider",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Pre_Divider))
            },
            {
                "Free running",
                fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Free_Running))
            }
        });
        // clang-format on
    }

    void CARM_Timer_Window::Render_Control_Register()
    {
        ImGui::Text("Control register");

        // Get the control register.
        const auto control_reg = m_arm_timer->Get_Control_Reg();

        // clang-format off
        Render_Table("ARM_timer_control_register", {
            {
                "Counter 32b",
                fmt::format("{:b}", control_reg.Counter_32b)
            },
            {
                "Prescaler",
                fmt::format("{:b}", control_reg.Prescaler)
            },
            {
                "Interrupt enabled",
                fmt::format("{:b}", control_reg.Interrupt_Enabled)
            },
            {
                "Timer enabled",
                fmt::format("{:b}", control_reg.Timer_Enabled)
            },
            {
                "Halt in debug break",
                fmt::format("{:b}", control_reg.Halt_In_Debug_Break)
            },
            {
                "Free running",
                fmt::format("{:b}", control_reg.Free_Running)
            }
        });
        // clang-format on
    }

} // namespace zero_mate::gui