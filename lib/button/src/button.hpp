#pragma once

#include "../../../src/gui/window.hpp"
#include <zero_mate/external_peripheral.hpp>

class CButton final : public zero_mate::IExternal_Peripheral
{
public:
    explicit CButton(const std::string& name,
                     std::uint32_t pin_idx,
                     zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin);

    void Render() override;

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