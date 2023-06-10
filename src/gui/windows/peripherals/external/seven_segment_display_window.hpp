#pragma once

#include <memory>

#include <zero_mate/gui_window.hpp>
#include "../../../../core/peripherals/external/shift_register.hpp"

namespace zero_mate::gui::external_peripheral
{
    class CSeven_Segment_Display final : public IGUI_Window
    {
    public:
        explicit CSeven_Segment_Display(std::shared_ptr<peripheral::external::CShift_Register<>> shift_register);

        void Render() override;

    private:
        inline void Render_Latch_Combobox();
        inline void Render_Data_Combobox();
        inline void Render_Clock_Combobox();
        inline void Render_Shift_Register();
        inline void Render_Seven_Segment_Display();
        [[nodiscard]] inline ImU32 Get_Segment_Color(std::uint8_t segment_idx) const;

    private:
        std::shared_ptr<peripheral::external::CShift_Register<>> m_shift_register;
    };
}