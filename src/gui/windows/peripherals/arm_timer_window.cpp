#include <fmt/format.h>

#include "arm_timer_window.hpp"

namespace zero_mate::gui
{
    CARM_Timer_Window::CARM_Timer_Window(const std::shared_ptr<peripheral::CARM_Timer>& arm_timer)
    : m_arm_timer{ arm_timer }
    {
    }

    void CARM_Timer_Window::Render()
    {
        if (ImGui::Begin("ARM timer"))
        {
            Render_Registers();
            Render_Control_Register();
        }

        ImGui::End();
    }

    void CARM_Timer_Window::Render_Registers()
    {
        if (ImGui::BeginTable("##ARM_timer_registers", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Register", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("Load");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Load)).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Value");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Value)).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("IRQ Clear");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::IRQ_Clear)).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("IRQ Raw");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::IRQ_Raw)).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("IRQ Masked");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::IRQ_Masked)).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Reload");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Reload)).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Pre divider");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Pre_Divider)).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Free running");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("0x{:08X}", m_arm_timer->Get_Reg(peripheral::CARM_Timer::NRegister::Free_Running)).c_str());

            ImGui::EndTable();
        }
    }

    void CARM_Timer_Window::Render_Control_Register()
    {
        const auto control_reg = m_arm_timer->Get_Control_Reg();
        ImGui::Text("Control register");

        if (ImGui::BeginTable("##ARM_timer_control_register", 2, Table_Flags))
        {
            ImGui::TableSetupColumn("Field", ImGuiTableColumnFlags_WidthFixed);
            ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_WidthStretch);

            ImGui::TableHeadersRow();

            ImGui::TableNextRow();

            ImGui::TableNextColumn();
            ImGui::Text("Counter 32b");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{:b}", control_reg.Counter_32b).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Prescaler");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{:b}", control_reg.Prescaler).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Interrupt enabled");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{:b}", control_reg.Interrupt_Enabled).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Timer enabled");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{:b}", control_reg.Timer_Enabled).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Halt in debug break");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{:b}", control_reg.Halt_In_Debug_Break).c_str());

            ImGui::TableNextColumn();
            ImGui::Text("Free running");
            ImGui::TableNextColumn();
            ImGui::Text("%s", fmt::format("{:b}", control_reg.Free_Running).c_str());

            ImGui::EndTable();
        }
    }
}