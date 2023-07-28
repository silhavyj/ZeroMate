#include <algorithm>

#include "logic_analyzer.hpp"

CLogic_Analyzer::CLogic_Analyzer(const std::string& name,
                                 const std::vector<std::uint32_t>& pins,
                                 zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
: m_name{ std::move(name) }
, m_pins{ std::move(pins) }
, m_curr_sample_idx{ 0 }
, m_ImGui_context{ nullptr }
, m_ImPlot_context{ nullptr }
, m_read_pin{ read_pin }
, m_max_number_of_samples{ 20 }
, m_number_of_collected_samples{ 0 }
{
    Init_GPIO_Subscription(m_pins);
}

void CLogic_Analyzer::Set_ImGui_Context(void* context)
{
    m_ImGui_context = static_cast<ImGuiContext*>(context);
}

void CLogic_Analyzer::Set_ImPlot_Context(void* context)
{
    m_ImPlot_context = static_cast<ImPlotContext*>(context);
}

bool CLogic_Analyzer::Is_There_Transition()
{
    for (const auto& pin : m_pins)
    {
        const auto state = static_cast<std::uint32_t>(m_read_pin(pin));

        if (m_curr_sample_idx > 1 && state != m_data[pin].back())
        {
            return true;
        }
    }

    return false;
}

void CLogic_Analyzer::GPIO_Subscription_Callback([[maybe_unused]] std::uint32_t pin_idx)
{
    if (m_number_of_collected_samples >= m_max_number_of_samples)
    {
        return;
    }

    ++m_number_of_collected_samples;

    m_sample_idxs.emplace_back(m_curr_sample_idx);
    ++m_curr_sample_idx;

    if (Is_There_Transition())
    {
        for (const auto& pin : m_pins)
        {
            m_data[pin].emplace_back(m_data[pin].back());
        }

        m_sample_idxs.emplace_back(m_curr_sample_idx - 1);
    }

    for (const auto& pin : m_pins)
    {
        m_data[pin].emplace_back(static_cast<std::uint32_t>(m_read_pin(pin)));
    }
}

void CLogic_Analyzer::Render()
{
    assert(m_ImGui_context != nullptr);
    assert(m_ImPlot_context != nullptr);

    ImGui::SetCurrentContext(m_ImGui_context);
    ImPlot::SetCurrentContext(m_ImPlot_context);

    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Max_Number_Of_Samples();
        Render_Buttons();
        Render_Line_Charts();
    }

    ImGui::End();
}

void CLogic_Analyzer::Render_Max_Number_Of_Samples()
{
    ImGui::InputInt("Max number of samples", &m_max_number_of_samples);
    ImGui::Text("Number of collected samples: %d", m_number_of_collected_samples);

    m_max_number_of_samples = std::clamp(m_max_number_of_samples, Min_Number_Of_Samples, Max_Number_Of_Samples);
}

void CLogic_Analyzer::Render_Buttons()
{
    if (ImGui::Button("Reset"))
    {
        m_sample_idxs.clear();
        m_data.clear();
        m_curr_sample_idx = 0;
        m_number_of_collected_samples = 0;
    }

    ImGui::Separator();
}

void CLogic_Analyzer::Render_Line_Charts()
{
    for (const auto& pin : m_pins)
    {
        Render_Line_Chart(pin);
    }
}

void CLogic_Analyzer::Render_Line_Chart(std::uint32_t pin_idx)
{
    // Name of the graph.
    const std::string name = "GPIO pin " + std::to_string(pin_idx);

    if (ImPlot::BeginPlot(name.c_str()))
    {
        // Axes labels.
        ImPlot::SetupAxis(ImAxis_X1, "Samples [1]");
        ImPlot::SetupAxis(ImAxis_Y1, "Voltage (1 = 5V; 0 = 0V)");

        // Render the data itself.
        ImPlot::PlotLine(name.c_str(),
                         m_sample_idxs.data(),
                         m_data[pin_idx].data(),
                         static_cast<int>(m_sample_idxs.size()),
                         ImPlotFlags_Equal);

        // Render data annotation (1s and 0s)
        Render_Data_Annotation(pin_idx);

        ImPlot::EndPlot();
    }
}

void CLogic_Analyzer::Render_Data_Annotation(std::uint32_t pin_idx)
{
    std::uint32_t i = 0;
    static bool clamp{ true };

    while (i < m_sample_idxs.size())
    {
        // Check if there is a transition to a new voltage level.
        // If so, skip the mock value (enforce discrete transition).
        if (i > 0 && i < (m_sample_idxs.size() - 1) && m_sample_idxs[i] == m_sample_idxs[i + 1])
        {
            ++i;
        }

        // Render the annotation in the middle of the pulse.
        ImPlot::Annotation(m_sample_idxs[i] + 0.5f,
                           m_data[pin_idx][i],
                           ImVec4(0, 0, 0, 0),
                           ImVec2(0, -5),
                           clamp,
                           "%d",
                           m_data[pin_idx][i]);

        // Move on to the next label
        ++i;
    }
}

void CLogic_Analyzer::Init_GPIO_Subscription(const std::vector<std::uint32_t>& pins)
{
    for (const auto& pin : pins)
    {
        m_gpio_subscription.insert(pin);
    }
}

extern "C"
{
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const char* const name,
                          const std::uint32_t* const gpio_pins,
                          std::size_t pin_count,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                          [[maybe_unused]] zero_mate::utils::CLogging_System* logging_system)
    {

        std::vector<std::uint32_t> pins(pin_count);

        for (std::uint32_t i = 0; i < pin_count; ++i)
        {
            pins[i] = gpio_pins[i];
        }

        *peripheral = new (std::nothrow) CLogic_Analyzer(name, pins, read_pin);

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}