#pragma once

#include <imgui.h>
#include <zero_mate/external_peripheral.hpp>

class CLED final : public zero_mate::IExternal_Peripheral
{
public:
    explicit CLED(const std::string& name,
                  std::uint32_t pin_idx,
                  zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);

    void Render() override;
    void Set_ImGui_Context(void *context) override;
    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override;

private:
    inline void Init_GPIO_Subscription();
    inline void Render_Pin_Idx() const;
    inline void Render_Color_Picker();
    inline void Render_LED();
    inline ImU32 Get_Current_Color() const;

private:
    std::string m_name;
    std::uint32_t m_pin_idx;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    ImGuiContext* m_context;
    bool m_pin_high;
    ImVec4 m_color;
};