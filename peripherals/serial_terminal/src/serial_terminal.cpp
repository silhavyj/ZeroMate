#include "serial_terminal.hpp"

CSerial_Terminal::CSerial_Terminal(const std::string& name, std::uint32_t pin_idx, zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin)
: m_name{ std::move(name )}
, m_pin_idx{ pin_idx }
, m_read_pin{ read_pin }
, m_context{ nullptr }
{
    Init_GPIO_Subscription();
}

void CSerial_Terminal::Init_GPIO_Subscription()
{
    m_gpio_subscription.insert(m_pin_idx);
}

void CSerial_Terminal::GPIO_Subscription_Callback(std::uint32_t pin_idx)
{
    static std::uint32_t len{ 0 };

    m_data += std::to_string(m_read_pin(pin_idx));
    ++len;

    if (len == 1 || len == 10)
    {
        m_data += " ";
        ++len;
    }

    if (len == 12U)
    {
        std::string buffer = m_data.substr(m_data.size() - 10, 8);
        std::reverse(buffer.begin(), buffer.end());
        const char character = static_cast<char>(stoi(buffer, 0, 2));

        m_data += "...'";
        if (character == '\0')
        {
            m_data += "\\0";
        }
        else if (character == '\r')
        {
            m_data += "\\r";
        }
        else if (character == '\n')
        {
            m_data += "\\n";
        }
        else
        {
            m_data += character;
        }
        m_data += "'\n";

        len = 0;
    }
}

void CSerial_Terminal::Render()
{
    assert(m_context != nullptr);
    ImGui::SetCurrentContext(m_context);

    if (ImGui::Begin(m_name.c_str()))
    {
        ImGui::Text("%s", m_data.c_str());
    }

    ImGui::End();
}

void CSerial_Terminal::Set_ImGui_Context(void* context)
{
    m_context = static_cast<ImGuiContext*>(context);
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
        if (pin_count != 1)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        *peripheral = new (std::nothrow) CSerial_Terminal(name, gpio_pins[0], read_pin);

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}