#pragma once

#include <vector>
#include <unordered_map>

#include <imgui.h>
#include <implot/implot.h>
#include <zero_mate/external_peripheral.hpp>

class CLogic_Analyzer final : public zero_mate::IExternal_Peripheral
{
public:
    static constexpr int Max_Number_Of_Samples = 1024;
    static constexpr int Min_Number_Of_Samples = 0;

    static constexpr int Min_Sampling_Frequency_CPI = 100;
    static constexpr int Max_Sampling_Frequency_CPI = std::numeric_limits<int>::max();

    static constexpr std::uint32_t Offset_Step = 2;

public:
    explicit CLogic_Analyzer(const std::string& name,
                             const std::vector<std::uint32_t>& pins,
                             zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);

    void Render() override;
    void Set_ImGui_Context(void* context) override;
    void Set_ImPlot_Context(void* context) override;
    void Increment_Passed_Cycles(std::uint32_t count) override;

private:
    void Sample();
    inline void Init_GPIO_Subscription(const std::vector<std::uint32_t>& pins);
    [[nodiscard]] inline bool Is_There_Transition();
    inline void Render_Line_Charts();
    inline void Render_Line_Chart(std::uint32_t pin_idx);
    inline void Render_Data_Annotation(std::uint32_t pin_idx);
    inline void Render_Settings();
    inline void Render_Buttons();
    inline void Render_Reset_Button();
    inline void Render_Start_Button();
    inline void Render_Stop_Button();
    inline void Render_State() const;
    inline void Init_Offsets();

private:
    std::string m_name;
    std::vector<std::uint32_t> m_pins;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    std::uint32_t m_curr_time;
    ImGuiContext* m_ImGui_context;
    ImPlotContext* m_ImPlot_context;
    std::unordered_map<std::uint32_t, std::vector<std::uint32_t>> m_data;
    std::vector<std::uint32_t> m_time;
    int m_max_number_of_samples;
    int m_sampling_frequency;
    std::uint32_t m_number_of_collected_samples;
    std::unordered_map<std::uint32_t, std::uint32_t> m_offsets;
    bool m_running;
    std::uint32_t m_cpu_cycles;
};
