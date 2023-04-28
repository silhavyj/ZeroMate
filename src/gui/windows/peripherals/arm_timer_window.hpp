#pragma once

#include <memory>

#include <imgui.h>

#include "../../window.hpp"
#include "../../../core/peripherals/arm_timer.hpp"

namespace zero_mate::gui
{
    class CARM_Timer_Window final : public CGUI_Window
    {
    public:
        explicit CARM_Timer_Window(const std::shared_ptr<peripheral::CARM_Timer>& arm_timer);

        void Render() override;

    private:
        static constexpr ImGuiTableFlags TABLE_FLAGS = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        void Render_Registers();
        void Render_Control_Register();

        const std::shared_ptr<peripheral::CARM_Timer> m_arm_timer;
    };
}