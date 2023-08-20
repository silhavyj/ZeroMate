// ---------------------------------------------------------------------------------------------------------------------
/// \file logic_analyzer.hpp
/// \date 29. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a logic analyzer that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <vector>
#include <unordered_map>
/// \endcond

#include "imgui.h"
#include "implot/implot.h"

#define ZERO_MATE_EXPORT
#include "zero_mate/external_peripheral.hpp"

// ---------------------------------------------------------------------------------------------------------------------
/// \class CLogic_Analyzer
/// \brief This class represents a logic analyzer.
// ---------------------------------------------------------------------------------------------------------------------
class CLogic_Analyzer final : public zero_mate::IExternal_Peripheral
{
public:
    /// Maximum number of samples the logic analyzer can capture
    static constexpr int Max_Number_Of_Samples = 4096;

    /// Minimum number of samples the logic analyzer can capture
    static constexpr int Min_Number_Of_Samples = 0;

    /// Minimum sampling frequency (prescaler of the CPU clock).
    static constexpr int Min_Sampling_Frequency_CPI = 100;

    /// Maximum sampling frequency (prescaler of the CPU clock).
    static constexpr int Max_Sampling_Frequency_CPI = std::numeric_limits<int>::max();

    /// Visual offset of individual channels.
    static constexpr std::uint32_t Offset_Step = 2;

public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param name Unique name of the peripherals
    /// \param pins Collection of GPIO pins the logic analyzer will be sampling
    /// \param read_pin Function used to read the state of a GPIO pin
    // -----------------------------------------------------------------------------------------------------------------
    explicit CLogic_Analyzer(const std::string& name,
                             const std::vector<std::uint32_t>& pins,
                             zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the LED (GUI).
    // -----------------------------------------------------------------------------------------------------------------
    void Render() override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets an ImGuiContext, so the logic analyzer can render itself as a GUI window.
    /// \param context ImGuiContext the logic analyzer uses to render itself
    // -----------------------------------------------------------------------------------------------------------------
    void Set_ImGui_Context(void* context) override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets an ImPlotContext, so the logic analyzer can draw individual plot lines.
    /// \param context ImPlotContext the logic analyzer uses to draw individual channels
    // -----------------------------------------------------------------------------------------------------------------
    void Set_ImPlot_Context(void* context) override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Lets the peripheral know about how many CPU cycles have passed by.
    /// \param count Number of passed CPU cycles (after the last instruction)
    // -----------------------------------------------------------------------------------------------------------------
    void Increment_Passed_Cycles(std::uint32_t count) override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Notifies the peripheral that the state of one of the pins it subscribes to has changed.
    /// \param pin_idx Index of the GPIO pin whose state has been changed
    // -----------------------------------------------------------------------------------------------------------------
    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override;

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes the subscription (list of GPIO pins the peripheral wants to listen to).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Init_GPIO_Subscription();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Samples all GPIO pins the logic analyzer is connected to.
    // -----------------------------------------------------------------------------------------------------------------
    void Sample();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Checks if there was a state transition on any of the GPIO pins.
    ///
    /// If so, we add another sample to ensure square transition between two adjacent points.
    ///
    /// \return true, if there was a transition. false otherwise.
    // -----------------------------------------------------------------------------------------------------------------
    [[nodiscard]] inline bool Is_There_Transition();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders all channels (plot lines).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Line_Charts();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders a single plot line (sampled GPIO pin channel).
    /// \param pin_idx Index of the GPIO pin
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Line_Chart(std::uint32_t pin_idx);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders an annotation of a single plot line (sampled GPIO pin channel).
    /// \param pin_idx Index of the GPIO pin
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Data_Annotation(std::uint32_t pin_idx);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders settings.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Settings();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the buttons.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Buttons();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the reset button.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Reset_Button();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the start button.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Start_Button();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the stop button.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Stop_Button();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the state of the logic analyzer (running/stopped).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_State() const;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes offsets of all data channels (sampled GPIO pins).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Init_Offsets();

private:
    std::string m_name;                                                   ///< Unique name of the peripheral
    std::vector<std::uint32_t> m_pins;                                    ///< Collection of sampled GPIO pins
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;          ///< Function to read the state of a GPIO pin
    std::uint32_t m_curr_time;                                            ///< Current time (CPI)
    ImGuiContext* m_ImGui_context;                                        ///< ImGuiContext
    ImPlotContext* m_ImPlot_context;                                      ///< ImPlotContext
    std::unordered_map<std::uint32_t, std::vector<std::uint32_t>> m_data; ///< Data channels
    std::vector<std::uint32_t> m_time;                                    ///< Collection of all timestamps
    int m_max_number_of_samples;                                          ///< Maximum number of samples
    int m_sampling_frequency;                                             ///< Sampling frequency (derived from CPI)
    std::uint32_t m_number_of_collected_samples;                          ///< Number of collected samples so far
    std::unordered_map<std::uint32_t, std::uint32_t> m_offsets;           ///< Offsets of different data channels
    bool m_running;                                                       ///< Is the logic analyzer running?
    std::uint32_t m_cpu_cycles;                                           ///< Current number of CPU cycles
    bool m_controlled_by_pin_change;                                      ///< Should it be updated with a pin change?
};
