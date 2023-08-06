// ---------------------------------------------------------------------------------------------------------------------
/// \file logic_analyzer.cpp
/// \date 29. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a logic analyzer that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <limits>
#include <algorithm>
/// \endcond

#include "logic_analyzer.hpp"

CLogic_Analyzer::CLogic_Analyzer(const std::string& name,
                                 const std::vector<std::uint32_t>& pins,
                                 zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
: m_name{ std::move(name) }
, m_pins{ std::move(pins) }
, m_curr_time{ 0 }
, m_ImGui_context{ nullptr }
, m_ImPlot_context{ nullptr }
, m_read_pin{ read_pin }
, m_max_number_of_samples{ 20 }
, m_number_of_collected_samples{ 0 }
, m_sampling_frequency{ Max_Sampling_Frequency_CPI }
, m_running{ false }
, m_cpu_cycles{ 0 }
{
    Init_Offsets();
}

void CLogic_Analyzer::Init_Offsets()
{
    std::uint32_t offset{ 0 };

    // Spread individual data channels out by Offset_Step.
    for (const auto& pin : m_pins)
    {
        m_offsets[pin] = offset;
        offset += Offset_Step;
    }
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
        // Read the current state of the pin and add the offset to it.
        const auto state = static_cast<std::uint32_t>(m_read_pin(pin)) + m_offsets[pin];

        // Check if the state has changes compared to the last sample.
        if (m_curr_time > 1 && state != m_data[pin].back())
        {
            return true;
        }
    }

    return false;
}

void CLogic_Analyzer::Sample()
{
    // Have we reached the maximum number of samples.
    if (m_number_of_collected_samples >= m_max_number_of_samples)
    {
        return;
    }

    // Increment the number of collected samples.
    ++m_number_of_collected_samples;

    // Add the current timestamp.
    m_time.emplace_back(m_curr_time);
    ++m_curr_time;

    // Check if we have to manually add an extra point to ensure a discrete transition.
    if (Is_There_Transition())
    {
        // Add a "dummy" sample (same as the last one).
        for (const auto& pin : m_pins)
        {
            m_data[pin].emplace_back(m_data[pin].back());
        }

        // We also need to add the timestamp again since we have two points at the same time.
        m_time.emplace_back(m_curr_time - 1);
    }

    // Read the current state of the pin and add it to the dataset.
    for (const auto& pin : m_pins)
    {
        m_data[pin].emplace_back(static_cast<std::uint32_t>(m_read_pin(pin)) + m_offsets[pin]);
    }
}

void CLogic_Analyzer::Render()
{
    // Make sure both contexts have been set.
    assert(m_ImGui_context != nullptr);
    assert(m_ImPlot_context != nullptr);

    // Switch the current context.
    ImGui::SetCurrentContext(m_ImGui_context);
    ImPlot::SetCurrentContext(m_ImPlot_context);

    // Render the window.
    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Settings();
        Render_Buttons();
        Render_State();
        Render_Line_Charts();
    }

    ImGui::End();
}

void CLogic_Analyzer::Render_Settings()
{
    // Maximum number of samples.
    ImGui::InputInt("Max number of samples", &m_max_number_of_samples);
    m_max_number_of_samples = std::clamp(m_max_number_of_samples, Min_Number_Of_Samples, Max_Number_Of_Samples);

    // Sampling frequency.
    ImGui::InputInt("Sampling frequency (CPI)", &m_sampling_frequency);
    m_sampling_frequency = std::clamp(m_sampling_frequency, Min_Sampling_Frequency_CPI, Max_Sampling_Frequency_CPI);

    ImGui::Separator();
}

void CLogic_Analyzer::Render_Buttons()
{
    // Start button
    Render_Start_Button();
    ImGui::SameLine();

    // Stop button
    Render_Stop_Button();
    ImGui::SameLine();

    // Rest button
    Render_Reset_Button();

    ImGui::Separator();
}

void CLogic_Analyzer::Render_Reset_Button()
{
    if (ImGui::Button("Reset"))
    {
        m_time.clear();
        m_data.clear();
        m_curr_time = 0;
        m_number_of_collected_samples = 0;
        m_cpu_cycles = 0;
    }
}

void CLogic_Analyzer::Render_Start_Button()
{
    if (ImGui::Button("Start"))
    {
        m_running = true; // Start sampling
    }
}

void CLogic_Analyzer::Render_Stop_Button()
{
    if (ImGui::Button("Stop"))
    {
        m_running = false; // Stop sampling
    }
}

void CLogic_Analyzer::Render_State() const
{
    // Indication of whether the logic analyzer is sampling or not
    ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(1.0F, 0.0F, 0.0F, 1.0F));
    ImGui::RadioButton("##logic_canalyzer", m_running);
    ImGui::PopStyleColor();

    // Separator
    ImGui::SameLine();
    ImGui::Text("|");
    ImGui::SameLine();

    // Number of collected samples so far
    ImGui::Text("Number of collected samples: %d", m_number_of_collected_samples);
    ImGui::Separator();
}

void CLogic_Analyzer::Render_Line_Charts()
{
    // Render the plot (ImVec2(-1, -1) tells the plot to take up as much of the screen as possible).
    if (ImPlot::BeginPlot("GPIO pins", ImVec2(-1, -1)))
    {
        // Axes labels.
        const std::string x_label = "Time [x * " + std::to_string(m_sampling_frequency) + "]";
        ImPlot::SetupAxis(ImAxis_X1, x_label.c_str());
        ImPlot::SetupAxis(ImAxis_Y1, "Logic level", ImPlotAxisFlags_NoTickLabels);

        // Render data channels.
        for (const auto& pin : m_pins)
        {
            Render_Line_Chart(pin);
        }

        // Add a drag line
        static double drag_tag = 0.25;
        ImPlot::DragLineX(0, &drag_tag, ImVec4(1, 1, 0, 0.7), 1, ImPlotDragToolFlags_NoFit);
        ImPlot::TagX(drag_tag, ImVec4(1, 1, 0, 0.7), " ");

        ImPlot::EndPlot();
    }
}

void CLogic_Analyzer::Render_Line_Chart(std::uint32_t pin_idx)
{
    // Name of the graph.
    const std::string name = "GPIO pin " + std::to_string(pin_idx);

    // Render the data itself.
    ImPlot::PlotLine(name.c_str(),
                     m_time.data(),
                     m_data[pin_idx].data(),
                     static_cast<int>(m_time.size()),
                     ImPlotFlags_Equal);

    // Render data annotation (1s and 0s)
    Render_Data_Annotation(pin_idx);
}

void CLogic_Analyzer::Render_Data_Annotation(std::uint32_t pin_idx)
{
    std::uint32_t i = 0;
    static bool clamp{ true };

    while (i < m_time.size())
    {
        // Check if there is a transition to a new voltage level.
        // If so, skip the mock value (enforce discrete transition).
        if (i > 0 && i < (m_time.size() - 1) && m_time[i] == m_time[i + 1])
        {
            ++i;
        }

        // Since the labels are shift to the right by a half a pulse, we do not want to render the very last one.
        if (i >= m_time.size() - 1)
        {
            break;
        }

        // Render the annotation in the middle of the pulse.
        ImPlot::Annotation(m_time[i] + 0.5f,
                           m_data[pin_idx][i],
                           ImVec4(0, 0, 0, 0),
                           ImVec2(0, -5),
                           clamp,
                           "%d",
                           m_data[pin_idx][i] - m_offsets[pin_idx]);

        // Move on to the next label
        ++i;
    }
}

void CLogic_Analyzer::Increment_Passed_Cycles(std::uint32_t count)
{
    // Make sure logic analyzer is in a sampling mode.
    if (!m_running)
    {
        return;
    }

    // Update the number of CPU cycles.
    m_cpu_cycles += count;

    // Is it time to sample the pins again?
    if (m_cpu_cycles >= m_sampling_frequency)
    {
        m_cpu_cycles = 0;
        Sample();
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
        // Converts the raw C-style array of GPIO pins to an std::vector.
        std::vector<std::uint32_t> pins(pin_count);

        for (std::uint32_t i = 0; i < pin_count; ++i)
        {
            pins[i] = gpio_pins[i];
        }

        // Create an instance of a logic analyzer.
        *peripheral = new (std::nothrow) CLogic_Analyzer(name, pins, read_pin);

        // Make sure the creation was successful.
        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        // All went well.
        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}