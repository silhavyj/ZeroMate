#include "logic_analyzer.hpp"

CLogic_Analyzer::CLogic_Analyzer(const std::string& name,
                                 const std::vector<std::uint32_t>& pins,
                                 zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
: m_name{ std::move(name) }
, m_ImGui_context{ nullptr }
, m_ImPlot_context{ nullptr }
, m_read_pin{ read_pin }
{
    Init_GPIO_Subscription(pins);
}

void CLogic_Analyzer::Set_ImGui_Context(void* context)
{
    m_ImGui_context = static_cast<ImGuiContext*>(context);
}

void CLogic_Analyzer::Set_ImPlot_Context(void* context)
{
    m_ImPlot_context = static_cast<ImPlotContext*>(context);
}

void CLogic_Analyzer::Render()
{
    assert(m_ImGui_context != nullptr);
    assert(m_ImPlot_context != nullptr);

    ImGui::SetCurrentContext(m_ImGui_context);
    ImPlot::SetCurrentContext(m_ImPlot_context);

    if (ImGui::Begin(m_name.c_str()))
    {
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