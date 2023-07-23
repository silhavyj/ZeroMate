#include <chrono>

#include "serial_terminal.hpp"

// clang-format off
std::array<const char* const, CSerial_Terminal::Number_Of_Baud_Rate_Options> CSerial_Terminal::s_baud_rates = {
    "1200",
    "2400",
    "4800",
    "9600",
    "19200",
    "38400",
    "57600",
    "115200"
};

std::array<const char* const, CSerial_Terminal::Number_Of_Stop_Bit_Options> CSerial_Terminal::s_stop_bits = {
    "1",
    "2"
};

std::array<const char* const, CSerial_Terminal::Number_Of_Data_Length_Options> CSerial_Terminal::s_data_lengths = {
    "7",
    "8"
};
// clang-format on

CSerial_Terminal::CSerial_Terminal(const std::string& name,
                                   std::uint32_t pin_idx,
                                   zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                                   zero_mate::utils::CLogging_System* logging_system)
: m_name{ std::move(name) }
, m_pin_idx{ pin_idx }
, m_read_pin{ read_pin }
, m_context{ nullptr }
, m_baud_rate_idx{ 0 }
, m_stop_bits_idx{ 0 }
, m_baud_rate{ 0 }
, m_stop_bits{ 0 }
, m_data_length{ 0 }
, m_data_length_idx{ 0 }
, m_RX_thread_has_stopped{ true }
, m_logging_system{ logging_system }
{
    Init_GPIO_Subscription();
}

CSerial_Terminal::~CSerial_Terminal()
{
    while (!m_RX_thread_has_stopped)
    {
    }
}

void CSerial_Terminal::Init_GPIO_Subscription()
{
    m_gpio_subscription.insert(m_pin_idx);
}

void CSerial_Terminal::GPIO_Subscription_Callback(std::uint32_t pin_idx)
{
    /*if (m_RX_thread_has_stopped && !m_read_pin(m_pin_idx))
    {
        m_logging_system->Debug("Start bit detected");

        m_baud_rate = ((Clock_Rate / static_cast<unsigned int>(std::stoi(s_baud_rates[m_baud_rate_idx]))) / 8) - 1;
        m_stop_bits = std::stoi(s_stop_bits[m_stop_bits_idx]);
        m_data_length = std::stoi(s_data_lengths[m_data_length_idx]);

        m_RX_thread_has_stopped = false;
        m_RX_thread = std::thread{ &CSerial_Terminal::Run_RX, this };
        m_RX_thread.detach();
    }*/

    static std::uint32_t len{ 0 };
    static bool start_bit = false;

    if (!m_read_pin(pin_idx))
    {
        start_bit = true;
    }

    if (start_bit)
    {
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
            start_bit = false;
        }
    }
}

void CSerial_Terminal::Render()
{
    assert(m_context != nullptr);
    ImGui::SetCurrentContext(m_context);

    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Settings();
        Render_Data();
    }

    ImGui::End();
}

void CSerial_Terminal::Run_RX()
{
    NState_Machine state{ NState_Machine::Start_Bit };
    std::uint8_t bit_idx{ 0 };
    std::string buffer;
    char character{};
    bool value;
    std::string x;

    while (true)
    {
        switch (state)
        {
            case NState_Machine::Start_Bit:
                state = NState_Machine::Payload;
                break;

            case NState_Machine::Payload:
                value = m_read_pin(m_pin_idx);
                x = "Receiving " + std::to_string(value);
                m_logging_system->Debug(x.c_str());
                buffer += std::to_string(value);

                ++bit_idx;
                if (bit_idx >= m_data_length)
                {
                    state = NState_Machine::Stop_Bit;
                    std::reverse(buffer.begin(), buffer.end());
                    character = static_cast<char>(stoi(buffer, 0, 2));
                    m_data += character;

                    m_logging_system->Debug(buffer.c_str());
                }
                break;

            case NState_Machine::Stop_Bit:
                state = NState_Machine::End_Of_Frame;
                break;

            case NState_Machine::End_Of_Frame:
                break;
        }

        // std::this_thread::sleep_for(std::chrono::nanoseconds(m_baud_rate));
        m_logging_system->Debug("Waiting...");
        std::this_thread::sleep_for(std::chrono::seconds(2));

        if (state == NState_Machine::End_Of_Frame)
        {
            break;
        }
    }

    m_RX_thread_has_stopped = true;
}

void CSerial_Terminal::Set_ImGui_Context(void* context)
{
    m_context = static_cast<ImGuiContext*>(context);
}

void CSerial_Terminal::Render_Settings()
{
    Render_Baud_Rate();
    Render_Stop_Bits();
    Render_Data_Lengths();
    ImGui::Separator();
}

void CSerial_Terminal::Render_Baud_Rate()
{
    ImGui::Combo("Baudrate", &m_baud_rate_idx, s_baud_rates.data(), s_baud_rates.size());
}

void CSerial_Terminal::Render_Stop_Bits()
{
    ImGui::Combo("Stop bits", &m_stop_bits_idx, s_stop_bits.data(), s_stop_bits.size());
}

void CSerial_Terminal::Render_Data_Lengths()
{
    ImGui::Combo("Data length", &m_data_length_idx, s_data_lengths.data(), s_data_lengths.size());
}

void CSerial_Terminal::Render_Data()
{
    ImGui::Text("%s", m_data.c_str());
}

extern "C"
{
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const char* const name,
                          const std::uint32_t* const gpio_pins,
                          std::size_t pin_count,
                          [[maybe_unused]] zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                          zero_mate::utils::CLogging_System* logging_system)
    {
        if (pin_count != 1)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        *peripheral = new (std::nothrow) CSerial_Terminal(name, gpio_pins[0], read_pin, logging_system);

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}