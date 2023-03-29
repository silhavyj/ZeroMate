#pragma once

#include <memory>

#include "../../core/peripherals/gpio.hpp"
#include "../window.hpp"

namespace zero_mate::gui
{
    class CGPIO_Window final : public CGUI_Window
    {
    public:
        explicit CGPIO_Window(std::shared_ptr<peripheral::CGPIO_Manager> gpio);

        void Render() override;

    private:
        std::shared_ptr<peripheral::CGPIO_Manager> m_gpio;
    };
}