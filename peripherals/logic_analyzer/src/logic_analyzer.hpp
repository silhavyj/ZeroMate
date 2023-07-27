#pragma once

#include <map>
#include <vector>

#include <imgui.h>
#include <implot/implot.h>
#include <zero_mate/external_peripheral.hpp>

class CLogic_Analyzer final : public zero_mate::IExternal_Peripheral
{
public:
    explicit CLogic_Analyzer(const std::string& name,
                             const std::vector<std::uint32_t>& pins,
                             zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);

    void Render() override;
    void Set_ImGui_Context(void* context) override;
    void Set_ImPlot_Context(void* context) override;

private:
    inline void Init_GPIO_Subscription(const std::vector<std::uint32_t>& pins);

private:
    std::string m_name;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    ImGuiContext* m_ImGui_context;
    ImPlotContext* m_ImPlot_context;
    std::map<std::uint32_t, std::vector<bool>> m_data;
};
