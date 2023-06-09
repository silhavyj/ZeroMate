#include <imgui.h>
#include <fmt/format.h>

#include "seven_segment_display.hpp"
#include "../../../../core/utils/math.hpp"

namespace zero_mate::gui::external_peripheral
{
    CSeven_Segment_Display::CSeven_Segment_Display(std::shared_ptr<peripheral::external::CShift_Register<>> shift_register)
    : m_shift_register{ shift_register }
    {
    }

    void CSeven_Segment_Display::Render()
    {
        if (ImGui::Begin("Seven segment display"))
        {
            Render_Shift_Register();
            Render_Seven_Segment_Display();
        }

        ImGui::End();
    }

    void CSeven_Segment_Display::Render_Shift_Register()
    {
        ImGui::Text("shift register: %s", fmt::format("{:08b}", m_shift_register->Get_Value()).c_str());

        ImGui::Separator();

        Render_Latch_Combobox();
        Render_Data_Combobox();
        Render_Clock_Combobox();

        ImGui::Separator();
    }

    void CSeven_Segment_Display::Render_Latch_Combobox()
    {
        const auto latch_pin_idx = m_shift_register->Get_Latch_Pin_Idx();

        if (ImGui::BeginCombo("Latch pin index", fmt::format("{}", latch_pin_idx).c_str()))
        {
            for (std::size_t i = 0; i < peripheral::CGPIO_Manager::NUMBER_OF_GPIO_PINS; ++i)
            {
                if (ImGui::Selectable(fmt::format("pin {}", i).c_str()) && latch_pin_idx != i)
                {
                    m_shift_register->Set_Latch_Pin_Idx(static_cast<std::uint32_t>(i));
                }
            }

            ImGui::EndCombo();
        }
    }

    void CSeven_Segment_Display::Render_Data_Combobox()
    {
        const auto data_pin_idx = m_shift_register->Get_Data_Pin_Idx();

        if (ImGui::BeginCombo("Data pin index", fmt::format("{}", data_pin_idx).c_str()))
        {
            for (std::size_t i = 0; i < peripheral::CGPIO_Manager::NUMBER_OF_GPIO_PINS; ++i)
            {
                if (ImGui::Selectable(fmt::format("pin {}", i).c_str()) && data_pin_idx != i)
                {
                    m_shift_register->Set_Data_Pin_idx(static_cast<std::uint32_t>(i));
                }
            }

            ImGui::EndCombo();
        }
    }

    void CSeven_Segment_Display::Render_Clock_Combobox()
    {
        const auto clock_pin_idx = m_shift_register->Get_Clock_Pin_Idx();

        if (ImGui::BeginCombo("Clock pin index", fmt::format("{}", clock_pin_idx).c_str()))
        {
            for (std::size_t i = 0; i < peripheral::CGPIO_Manager::NUMBER_OF_GPIO_PINS; ++i)
            {
                if (ImGui::Selectable(fmt::format("pin {}", i).c_str()) && clock_pin_idx != i)
                {
                    m_shift_register->Set_Clock_Pin_Idx(static_cast<std::uint32_t>(i));
                }
            }

            ImGui::EndCombo();
        }
    }

    void CSeven_Segment_Display::Render_Seven_Segment_Display()
    {
        ImDrawList* draw_list = ImGui::GetWindowDrawList();

        ImVec2 v_min = ImGui::GetWindowContentRegionMin();

        static constexpr int OFFSET_Y = 110;
        static constexpr int SIZE = 25;
        static constexpr int THICKNESS = 5;

        // Move it relatively to the window position.
        v_min.x += ImGui::GetWindowPos().x;
        v_min.y += ImGui::GetWindowPos().y + OFFSET_Y;

        draw_list->AddLine(v_min, { v_min.x + SIZE, v_min.y }, Get_Segment_Color(7), THICKNESS);
        draw_list->AddLine(v_min, { v_min.x, v_min.y + SIZE }, Get_Segment_Color(1), THICKNESS);
        draw_list->AddLine({ v_min.x + SIZE, v_min.y }, { v_min.x + SIZE, v_min.y + SIZE }, Get_Segment_Color(4), THICKNESS);

        draw_list->AddLine({ v_min.x, v_min.y + SIZE }, { v_min.x + SIZE, v_min.y + SIZE }, Get_Segment_Color(0), THICKNESS);

        draw_list->AddLine({ v_min.x, v_min.y + SIZE }, { v_min.x, v_min.y + 2 * SIZE }, Get_Segment_Color(6), THICKNESS);
        draw_list->AddLine({ v_min.x + SIZE, v_min.y + SIZE }, { v_min.x + SIZE, v_min.y + 2 * SIZE }, Get_Segment_Color(2), THICKNESS);
        draw_list->AddLine({ v_min.x, v_min.y + 2 * SIZE }, { v_min.x + SIZE, v_min.y + 2 * SIZE }, Get_Segment_Color(3), THICKNESS);

        draw_list->AddCircleFilled({ v_min.x + SIZE + 2 * THICKNESS, v_min.y + 2 * SIZE }, THICKNESS, Get_Segment_Color(5));
    }

    ImU32 CSeven_Segment_Display::Get_Segment_Color(std::uint8_t segment_idx) const
    {
       static constexpr ImU32 ACTIVE_COLOR = IM_COL32(255, 0, 0, 255);
       static constexpr ImU32 PASIVE_COLOR = IM_COL32(60, 60, 60, 255);

       const std::uint8_t index = static_cast<std::uint8_t>(std::numeric_limits<std::uint8_t>::digits - 1) - segment_idx;

       if (!utils::math::Is_Bit_Set(m_shift_register->Get_Value(), index))
       {
            return ACTIVE_COLOR;
       }

       return PASIVE_COLOR;
    }
}