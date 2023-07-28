#pragma once

#include <map>
#include <vector>

#include <imgui.h>
#include <implot/implot.h>
#include <zero_mate/external_peripheral.hpp>

class CLogic_Analyzer final : public zero_mate::IExternal_Peripheral
{
public:
    static constexpr int Max_Number_Of_Samples = 1024;
    static constexpr int Min_Number_Of_Samples = 0;

public:
    explicit CLogic_Analyzer(const std::string& name,
                             const std::vector<std::uint32_t>& pins,
                             zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);

    void Render() override;
    void Set_ImGui_Context(void* context) override;
    void Set_ImPlot_Context(void* context) override;
    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override;

private:
    inline void Init_GPIO_Subscription(const std::vector<std::uint32_t>& pins);
    [[nodiscard]] inline bool Is_There_Transition();
    inline void Render_Line_Charts();
    inline void Render_Line_Chart(std::uint32_t pin_idx);
    inline void Render_Data_Annotation(std::uint32_t pin_idx);
    inline void Render_Max_Number_Of_Samples();
    inline void Render_Buttons();

private:
    std::string m_name;
    std::vector<std::uint32_t> m_pins;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    std::uint32_t m_curr_sample_idx;
    ImGuiContext* m_ImGui_context;
    ImPlotContext* m_ImPlot_context;
    std::map<std::uint32_t, std::vector<std::uint32_t>> m_data;
    std::vector<std::uint32_t> m_sample_idxs;
    int m_max_number_of_samples;
    std::uint32_t m_number_of_collected_samples;
};
