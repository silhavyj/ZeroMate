#pragma once

#include <imgui/imgui.h>

#include "../window.hpp"

#include "../../core/arm1176jzf_s/cpu_core.hpp"

namespace zero_mate::gui
{
    class CRegisters_Window final : public CGUI_Window
    {
    public:
        explicit CRegisters_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu);

        void Render() override;

    private:
        static constexpr ImGuiTableFlags TABLE_FLAGS = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        void Render_Registers_Table(const char* const title, const char* const type, const char* const format);
        void Render_Flags();

        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
    };
}