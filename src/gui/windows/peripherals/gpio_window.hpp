#pragma once

#include <memory>

#include <imgui.h>

#include "../../window.hpp"
#include "../../../core/peripherals/gpio.hpp"

namespace zero_mate::gui
{
    class CGPIO_Window final : public IGUI_Window
    {
    public:
        explicit CGPIO_Window(std::shared_ptr<peripheral::CGPIO_Manager> gpio);

        void Render() override;

    private:
        static constexpr ImGuiTableFlags Table_Flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        std::shared_ptr<peripheral::CGPIO_Manager> m_gpio;
    };
}