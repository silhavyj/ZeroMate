#pragma once

#include <memory>

#include "../../../window.hpp"

#include "../../../../core/peripherals/gpio.hpp"
#include "../../../../core/utils/logger/logger.hpp"

namespace zero_mate::gui::external_peripheral
{
    class CButton final : public CGUI_Window
    {
    public:
        explicit CButton(std::shared_ptr<peripheral::CGPIO_Manager> gpio);

        void Render() override;
        void Render_Combobox();
        void Render_Button();

    private:
        inline void Swap_State();

        std::shared_ptr<peripheral::CGPIO_Manager> m_gpio;
        utils::CLogging_System& m_logging_system;
        peripheral::CGPIO_Manager::CPin::NState m_state;
        std::size_t m_pin_idx;
    };
}