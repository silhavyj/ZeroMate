#pragma once

#include <imgui.h>
#include <zero_mate/external_peripheral.hpp>

class CSerial_Terminal final : public zero_mate::IExternal_Peripheral
{
public:
    explicit CSerial_Terminal(const std::string& name, std::uint32_t pin_idx, zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);

    void Render() override;
    void Set_ImGui_Context(void* context) override;
    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override;

private:
    inline void Init_GPIO_Subscription();

private:
    std::string m_name;
    std::uint32_t m_pin_idx;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    ImGuiContext* m_context;
    std::string m_data;
};