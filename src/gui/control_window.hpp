#pragma once

#include "window.hpp"

#include "../arm1176jzf_s/core.hpp"

namespace zero_mate::gui
{
    class CControl_Window : public CGUI_Window
    {
    public:
        explicit CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu);

        void Render() override;

    private:
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
    };
}