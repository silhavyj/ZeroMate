#pragma once

#include "../window.hpp"

#include "../../core/arm1176jzf_s/cpu_core.hpp"

namespace zero_mate::gui
{
    class CControl_Window final : public CGUI_Window
    {
    public:
        explicit CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                 bool& scroll_to_curr_line);

        void Render() override;

    private:
        static void Render_CPU_State(bool running, bool breakpoint);
        void Render_Control_Buttons(bool& running, bool& breakpoint);
        static void Render_ImGUI_Demo();

        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        bool& m_scroll_to_curr_line;
    };
}