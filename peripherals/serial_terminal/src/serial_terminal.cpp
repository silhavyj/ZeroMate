// ---------------------------------------------------------------------------------------------------------------------
/// \file serial_terminal.cpp
/// \date 25. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a serial terminal that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#include <chrono>
#include <cassert>

#include "serial_terminal.hpp"

CTerminal::CTerminal(std::uint32_t width, std::uint32_t height)
: m_width{ width }
, m_height{ height }
, m_curr_line{ 0 }
, m_data(height)
{
    Clear();
}

void CTerminal::Add_Character(char c)
{
    // Check if the character should be places on a new line.
    if (m_data[m_curr_line].length() >= m_width)
    {
        ++m_curr_line;

        // Make sure we do get out of the screen.
        Scroll_If_Needed();
    }

    // Account for special characters.
    switch (c)
    {
        // New line
        case '\n':
            ++m_curr_line;
            Scroll_If_Needed();
            break;

        // This is currently being ignored.
        case '\r':
            break;

        // A regular symbol (character)
        default:
            m_data[m_curr_line] += c;
            break;
    }
}

void CTerminal::Scroll_If_Needed()
{
    // Have we exceeded the height of the screen?
    if (m_curr_line >= m_height)
    {
        // Remove the very first line.
        m_data.erase(m_data.begin());

        // Append an empty new line.
        m_data.emplace_back();

        // Start putting characters to the very last line.
        m_curr_line = m_height - 1;
    }
}

void CTerminal::Render()
{
    // General information about the terminal.
    ImGui::Text("Serial terminal: %dx%d 8-bit characters", m_width, m_height);
    ImGui::Separator();

    // Render individual rows one by one.
    for (std::uint32_t row = 0; row < m_height; ++row)
    {
        // Render the index of the current row.
        ImGui::PushStyleColor(ImGuiCol_Text, Gray);
        ImGui::Text("%2d:", row + 1);
        ImGui::SameLine();

        /// Render the line itself.
        ImGui::PushStyleColor(ImGuiCol_Text, Yellow);
        ImGui::Text("%s", m_data[row].c_str());

        // Do not forget to pop the custom style (colors).
        ImGui::PopStyleColor(2);
    }

    ImGui::Separator();
}

void CTerminal::Clear()
{
    m_curr_line = 0;

    for (auto& line : m_data)
    {
        line = "";
    }
}

// clang-format off
const std::array<const char* const, CSerial_Terminal::Number_Of_Baud_Rate_Options> CSerial_Terminal::s_baud_rates = {
    "1200",  // 0
    "2400",  // 1
    "4800",  // 2
    "9600",  // 3
    "19200", // 4
    "38400", // 5
    "57600", // 6
    "115200" // 7
};

const std::array<const char* const, CSerial_Terminal::Number_Of_Data_Length_Options> CSerial_Terminal::s_data_lengths = {
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
, m_baud_rate{ ((Clock_Rate / static_cast<unsigned int>(std::stoi(s_baud_rates[m_baud_rate_idx]))) / 8U) - 1 }
, m_data_length{ 8 }
, m_data_length_idx{ 1 }
, m_logging_system{ logging_system }
, m_cpu_cycles{ 0 }
, m_RX_state{ NState_Machine::Start_Bit }
, m_RX_bit_idx{ 0 }
, m_terminal{ Terminal_Width, Terminal_Height }
{
}

void CSerial_Terminal::Render()
{
    // Make sure an ImGui context has been set.
    assert(m_context != nullptr);
    ImGui::SetCurrentContext(m_context);

    // Render the window.
    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Settings();
        m_terminal.Render();
    }

    ImGui::End();
}

void CSerial_Terminal::Update()
{
    // UART TX state machine
    switch (m_RX_state)
    {
        // Start bit
        case NState_Machine::Start_Bit:
            Receive_Start_Bit();
            break;

        // Payload
        case NState_Machine::Payload:
            Receive_Payload();
            break;

        // Stop bit
        case NState_Machine::Stop_Bit:
            Receive_Stop_Bit();
            break;
    }
}

void CSerial_Terminal::Receive_Start_Bit()
{
    // A start bit is signalized by the voltage level being pulled down.
    if (!m_read_pin(m_pin_idx))
    {
        m_RX_state = NState_Machine::Payload;
    }
}

void CSerial_Terminal::Receive_Payload()
{
    // Read the state of the RX pin.
    m_buffer += std::to_string(static_cast<int>(m_read_pin(m_pin_idx)));

    // Increment the number of received bits of the payload.
    ++m_RX_bit_idx;

    // Have we read all bits we were supposed to?
    if (m_RX_bit_idx >= m_data_length)
    {
        // Reverse the bits and print the character to the terminal.
        std::reverse(m_buffer.begin(), m_buffer.end());
        m_terminal.Add_Character(static_cast<char>(stoi(m_buffer, 0, 2)));

        // Get ready for receiving another piece of data.
        m_buffer = "";
        m_RX_bit_idx = 0;

        // Move on to the next state.
        m_RX_state = NState_Machine::Stop_Bit;
    }
}

void CSerial_Terminal::Receive_Stop_Bit()
{
    // Stop bit is signalized as high level of voltage.
    if (!m_read_pin(m_pin_idx))
    {
        m_logging_system->Error("Stop bit was not received correctly");
    }
    else
    {
        m_RX_state = NState_Machine::Start_Bit;
    }
}

void CSerial_Terminal::Set_ImGui_Context(void* context)
{
    m_context = static_cast<ImGuiContext*>(context);
}

void CSerial_Terminal::Render_Settings()
{
    Render_Baud_Rate();
    Render_Data_Lengths();
    ImGui::Separator();
    Render_Buttons();
    ImGui::Separator();
    ImGui::Separator();
}

void CSerial_Terminal::Render_Baud_Rate()
{
    if (ImGui::Combo("Baudrate", &m_baud_rate_idx, s_baud_rates.data(), s_baud_rates.size()))
    {
        m_baud_rate = ((Clock_Rate / static_cast<unsigned int>(std::stoi(s_baud_rates[m_baud_rate_idx]))) / 8) - 1;
    }
}

void CSerial_Terminal::Render_Data_Lengths()
{
    if (ImGui::Combo("Data length", &m_data_length_idx, s_data_lengths.data(), s_data_lengths.size()))
    {
        m_data_length = std::stoi(s_data_lengths[m_data_length_idx]);
    }
}

void CSerial_Terminal::Render_Buttons()
{
    if (ImGui::Button("Reset settings"))
    {
        m_cpu_cycles = 0;
        m_RX_state = NState_Machine::Start_Bit;
        m_RX_bit_idx = 0;
        m_buffer = "";
    }

    ImGui::SameLine();

    if (ImGui::Button("Clear screen"))
    {
        m_terminal.Clear();
    }
}

void CSerial_Terminal::Increment_Passed_Cycles(std::uint32_t count)
{
    m_cpu_cycles += count;

    // Should we update the UART RX state machine.
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
        // Only one pin shall be passed to the peripheral.
        if (pin_count != 1)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        // Create an instance of a serial monitor.
        *peripheral = new (std::nothrow) CSerial_Terminal(name, gpio_pins[0], read_pin, logging_system);

        // Make sure the creation was successful.
        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        // All went well.
        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}