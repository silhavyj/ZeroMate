#pragma once

#include <memory>

#include <zero_mate/gui_window.hpp>

#include "../../../../core/peripherals/external/button.hpp"
#include "../../../../core/utils/logger/logger.hpp"

namespace zero_mate::gui::external_peripheral
{
    class CButton_Window final : public IGUI_Window
    {
    public:
        explicit CButton_Window(std::shared_ptr<peripheral::external::CButton> button);

        void Render() override;
        void Render_Combobox();
        void Render_Button();

    private:
        std::shared_ptr<peripheral::external::CButton> m_button;
    };
}