#pragma once

#include "window.hpp"

#include "../peripherals/ram.hpp"

namespace zero_mate::gui
{
    class CRAM_Window : public CGUI_Window
    {
    public:
        explicit CRAM_Window(std::shared_ptr<peripheral::CRAM<>> ram);

        void Render() override;

    private:
        std::shared_ptr<peripheral::CRAM<>> m_ram;
    };
}