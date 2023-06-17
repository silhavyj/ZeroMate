#pragma once

#include <memory>

#include <imgui.h>

#include "../../window.hpp"
#include "../../../core/peripherals/interrupt_controller.hpp"

namespace zero_mate::gui
{
    class CInterrupt_Controller_Window final : public IGUI_Window
    {
    public:
        explicit CInterrupt_Controller_Window(const std::shared_ptr<peripheral::CInterrupt_Controller>& interrupt_controller);

        void Render() override;

    private:
        void Render_Basic_IRQ();
        void Render_IRQ();

    private:
        static constexpr ImGuiTableFlags Table_Flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        const std::shared_ptr<peripheral::CInterrupt_Controller> m_interrupt_controller;
    };
}