#pragma once

#include <zero_mate/gui_window.hpp>

#include "../../../core/peripherals/ram.hpp"

namespace zero_mate::gui
{
    class CRAM_Window final : public IGUI_Window
    {
    public:
        explicit CRAM_Window(std::shared_ptr<peripheral::CRAM> ram);

        void Render() override;

    private:
        std::shared_ptr<peripheral::CRAM> m_ram;
    };
}