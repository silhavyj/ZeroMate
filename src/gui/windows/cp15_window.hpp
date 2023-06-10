#pragma once

#include <zero_mate/gui_window.hpp>

#include "../../core/coprocessors/cp15.hpp"

namespace zero_mate::gui
{
    class CCP15_Window final : public IGUI_Window
    {
    public:
        explicit CCP15_Window(std::shared_ptr<coprocessor::CCP15> cp15);

        void Render() override;

    private:
        inline void Render_Primary_Register_C1();

    private:
        static constexpr ImGuiTableFlags TABLE_FLAGS = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        std::shared_ptr<coprocessor::CCP15> m_cp15;
    };
}