#pragma once

#include "window.hpp"

#include "../arm1176jzf_s/core.hpp"

namespace zero_mate::gui
{
    class CRegisters_Window final : public CGUI_Window
    {
    public:
        explicit CRegisters_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu);

        void Render() override;

    private:
        void Render_Registers_Table(const char* const title, const char* const type, const char* const format);

        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
    };
}