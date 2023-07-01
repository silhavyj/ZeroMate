#pragma once

#include <imgui.h>
#include <zero_mate/external_peripheral.hpp>

class CDIP_Switch : public zero_mate::IExternal_Peripheral
{
public:
    explicit CDIP_Switch(std::string name,
                         std::uint32_t pin_idx,
                         zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin);

    void Render() override;
    void Set_ImGui_Context(void* context) override;

private:
    inline void Render_Pin_Idx() const;
    inline void Render_DIP_Switch();

private:
    std::string m_name;
    std::uint32_t m_pin_idx;
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin;
    ImGuiContext* m_context;
    bool m_output;
};