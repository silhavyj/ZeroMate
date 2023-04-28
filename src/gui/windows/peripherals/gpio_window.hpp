#pragma once

#include <memory>

#include "../../../core/peripherals/gpio.hpp"
#include "../../window.hpp"

namespace zero_mate::gui
{
    class CGPIO_Window final : public CGUI_Window
    {
    public:
        explicit CGPIO_Window(std::shared_ptr<peripheral::CGPIO_Manager> gpio);

        void Render() override;

    private:
        static constexpr ImGuiTableFlags TABLE_FLAGS = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        std::shared_ptr<peripheral::CGPIO_Manager> m_gpio;
    };
}