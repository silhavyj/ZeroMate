#pragma once

#include "../object.hpp"

#include "../../core/peripherals/ram.hpp"

namespace zero_mate::gui
{
    class CRAM_Window final : public CGUI_Object
    {
    public:
        explicit CRAM_Window(std::shared_ptr<peripheral::CRAM<>> ram);

        void Render() override;

    private:
        std::shared_ptr<peripheral::CRAM<>> m_ram;
    };
}