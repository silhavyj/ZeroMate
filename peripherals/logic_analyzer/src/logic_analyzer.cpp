#include "logic_analyzer.hpp"

CLogic_Analyzer::CLogic_Analyzer(const std::string& name,
                                 const std::vector<std::uint32_t>& pins,
                                 zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
: m_name{ std::move(name) }
, m_pins{ std::move(pins) }
, m_timestamp{ 0 }
, m_ImGui_context{ nullptr }
, m_ImPlot_context{ nullptr }
, m_read_pin{ read_pin }
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

        if (m_timestamp > 1 && state != m_data[pin].back())
        {
            return true;
        }
    }

    return false;
}

void CLogic_Analyzer::GPIO_Subscription_Callback([[maybe_unused]] std::uint32_t pin_idx)
{
    m_time.emplace_back(m_timestamp);
    ++m_timestamp;

    if (Is_There_Transition())
    {
        for (const auto& pin : m_pins)
        {
            m_data[pin].emplace_back(m_data[pin].back());
        }

        m_time.emplace_back(m_timestamp - 1);
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

    static bool clamp = false;
    static double y1 = 1.0;

    if (ImGui::Begin(m_name.c_str()))
    {
        for (const auto& pin : m_pins)
        {
            const std::string name = "GPIO pin " + std::to_string(pin);

            if (ImPlot::BeginPlot(name.c_str()))
            {
                ImPlot::PlotLine(name.c_str(), m_time.data(), m_data[pin].data(), m_time.size());

                std::uint32_t i = 0;

                while (i < m_time.size())
                {
                    if (i > 1 && i < (m_time.size() - 1) && m_time[i] == m_time[i + 1])
                    {
                        ++i;
                    }
                    ImPlot::Annotation(m_time[i] + 0.5f, m_data[pin][i], ImVec4(0, 0, 0, 0), ImVec2(0, -5), clamp, "%d", m_data[pin][i]);
                    ++i;
                }

                ImPlot::EndPlot();
            }
        }
    }

    ImGui::End();
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