#pragma once

#include "object.hpp"

#include "../arm1176jzf_s/core.hpp"

namespace zero_mate::gui
{
    class CControl_Window final : public CGUI_Object
    {
    public:
        explicit CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu);

        void Render() override;

    private:
        static void Render_CPU_State(bool running, bool breakpoint);
        void Render_Control_Buttons(bool& running, bool& breakpoint);
        static void Render_ImGUI_Demo();

        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
    };
}