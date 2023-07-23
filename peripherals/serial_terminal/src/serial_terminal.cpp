#include <chrono>
#include <cassert>

#include "serial_terminal.hpp"

// clang-format off
std::array<const char* const, CSerial_Terminal::Number_Of_Baud_Rate_Options> CSerial_Terminal::s_baud_rates = {
    "1200",  // 0
    "2400",  // 1
    "4800",  // 2
    "9600",  // 3
    "19200", // 4
    "38400", // 5
    "57600", // 6
    "115200" // 7
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
, m_baud_rate_idx{ 7 }
, m_stop_bits_idx{ 0 }
, m_baud_rate{ ((Clock_Rate / static_cast<unsigned int>(std::stoi(s_baud_rates[m_baud_rate_idx]))) / 8) - 1 }
, m_stop_bits{ 1 }
, m_data_length{ 8 }
, m_data_length_idx{ 1 }
, m_logging_system{ logging_system }
, m_cpu_cycles{ 0 }
, m_RX_state{ NState_Machine::Start_Bit }
, m_RX_bit_idx{ 0 }
, m_start_bit_detected{ false }
{
    Init_GPIO_Subscription();
}

void CSerial_Terminal::Init_GPIO_Subscription()
{
    m_gpio_subscription.insert(m_pin_idx);
}

void CSerial_Terminal::GPIO_Subscription_Callback(std::uint32_t pin_idx)
{
    assert(pin_idx == m_pin_idx);

    if (!m_start_bit_detected && !m_read_pin(m_pin_idx))
    {
        m_start_bit_detected = true;
        // m_logging_system->Debug("Start bit detected");
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

void CSerial_Terminal::Update()
{
    if (!m_start_bit_detected)
    {
        return;
    }

    switch (m_RX_state)
    {
        case NState_Machine::Start_Bit:
            m_RX_state = NState_Machine::Payload;
            break;

        case NState_Machine::Payload:
            Read_Payload();
            break;

        // TODO make sure the stop bit is received correctly.
        case NState_Machine::Stop_Bit:
            m_RX_state = NState_Machine::Start_Bit;
            m_start_bit_detected = false;
            break;

        case NState_Machine::End_Of_Frame:
            break;
    }
}

void CSerial_Terminal::Read_Payload()
{
    m_buffer += std::to_string(static_cast<int>(m_read_pin(m_pin_idx)));
    ++m_RX_bit_idx;

    if (m_RX_bit_idx >= m_data_length)
    {
        std::reverse(m_buffer.begin(), m_buffer.end());
        // m_logging_system->Debug(m_buffer.c_str());
        m_data += static_cast<char>(stoi(m_buffer, 0, 2));

        m_buffer = "";
        m_RX_bit_idx = 0;
        m_RX_state = NState_Machine::Stop_Bit;
    }
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
    Render_Buttons();
    ImGui::Separator();
    ImGui::Text("Number of printed characters: %d", static_cast<std::uint32_t>(m_data.size()));
    ImGui::Separator();
}

void CSerial_Terminal::Render_Baud_Rate()
{
    if (ImGui::Combo("Baudrate", &m_baud_rate_idx, s_baud_rates.data(), s_baud_rates.size()))
    {
        m_baud_rate = ((Clock_Rate / static_cast<unsigned int>(std::stoi(s_baud_rates[m_baud_rate_idx]))) / 8) - 1;
    }
}

void CSerial_Terminal::Render_Stop_Bits()
{
    if (ImGui::Combo("Stop bits", &m_stop_bits_idx, s_stop_bits.data(), s_stop_bits.size()))
    {
        m_stop_bits = std::stoi(s_stop_bits[m_stop_bits_idx]);
    }
}

void CSerial_Terminal::Render_Data_Lengths()
{
    if (ImGui::Combo("Data length", &m_data_length_idx, s_data_lengths.data(), s_data_lengths.size()))
    {
        m_data_length = std::stoi(s_data_lengths[m_data_length_idx]);
    }
}

void CSerial_Terminal::Render_Data()
{
    ImGui::Text("%s", m_data.c_str());
}

void CSerial_Terminal::Render_Buttons()
{
    if (ImGui::Button("Reset settings"))
    {
        m_cpu_cycles = 0;
        m_RX_state = NState_Machine::Start_Bit;
        m_RX_bit_idx = 0;
        m_start_bit_detected = false;
        m_buffer = "";
    }

    ImGui::SameLine();

    if (ImGui::Button("Clear screen"))
    {
        m_data = "";
    }
}

void CSerial_Terminal::Increment_Passed_Cycles(std::uint32_t count)
{
    m_cpu_cycles += count;

    if (m_cpu_cycles >= m_baud_rate)
    {
        m_cpu_cycles = 0;
        Update();
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