#pragma once

#include "zero_mate/external_peripheral.hpp"

class CButton final : public zero_mate::IExternal_Peripheral
{
public:
    explicit CButton(const std::vector<std::uint32_t>& gpio_pins,
                     zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin);

private:
    std::uint32_t m_pin_idx;
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin;
    bool m_output;
};