#pragma once

#include <zero_mate/gui_window.hpp>
#include <zero_mate/external_peripheral.hpp>

class CButton final : public zero_mate::IExternal_Peripheral, zero_mate::IGUI_Window
{
public:
    explicit CButton(const std::string& name,
                     std::uint32_t pin_idx,
                     zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin);

    void Render() override;
    [[nodiscard]] bool Implements_GUI() const noexcept override;

private:
    void Toggle();
    void Render_Pin_Idx();
    void Render_Button();

private:
    std::string m_name;
    std::uint32_t m_pin_idx;
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin;
    bool m_output;
};