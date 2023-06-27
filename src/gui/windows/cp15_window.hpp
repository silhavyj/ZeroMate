#pragma once

#include "../window.hpp"

#include "../../core/coprocessors/cp15/cp15.hpp"

namespace zero_mate::gui
{
    class CCP15_Window final : public IGUI_Window
    {
    public:
        explicit CCP15_Window(std::shared_ptr<coprocessor::cp15::CCP15> cp15);

        void Render() override;

    private:
        inline void Render_Primary_Register_C1();
        inline void Render_Primary_Register_C2();
        inline void Render_Primary_Register_C3();
        inline void Render_Primary_Register_C7();

    private:
        static constexpr ImGuiTableFlags Table_Flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        std::shared_ptr<coprocessor::cp15::CCP15> m_cp15;
    };
}