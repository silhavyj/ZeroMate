// ---------------------------------------------------------------------------------------------------------------------
/// \file serial_terminal.cpp
/// \date 25. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a serial terminal that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#include <chrono>
#include <cassert>
#include <algorithm>

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
                                   std::uint32_t RX_pin_idx,
                                   std::uint32_t TX_pin_idx,
                                   zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                                   zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                                   zero_mate::utils::CLogging_System* logging_system)
: m_name{ std::move(name) }
, m_RX_pin_idx{ RX_pin_idx }
, m_TX_pin_idx{ TX_pin_idx }
, m_read_pin{ read_pin }
, m_set_pin{ set_pin }
, m_context{ nullptr }
, m_baud_rate_idx{ 7 }
, m_baud_rate{ ((Clock_Rate / static_cast<unsigned int>(std::stoi(s_baud_rates[m_baud_rate_idx]))) / 8U) - 1 }
, m_data_length{ 8 }
, m_data_length_idx{ 1 }
, m_logging_system{ logging_system }
, m_use_cr_lf{ false }
, m_cpu_cycles{ 0 }
, m_RX_state{ NState_Machine::Bus_Idle }
, m_RX_bit_idx{ 0 }
, m_terminal{ Terminal_Width, Terminal_Height }
, m_user_input{}
, m_TX_state{ NState_Machine::Start_Bit }
, m_TX_bit_idx{ 0 }
, m_TX_curr_data{ 0 }
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
        Render_User_Input();
        m_terminal.Render();
    }

    ImGui::End();
}

void CSerial_Terminal::Update_RX()
{
    // UART TX state machine
    switch (m_RX_state)
    {
        // Bus in an idle state
        case NState_Machine::Bus_Idle:
            Check_Bus_Idle_State();
            break;

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

        case NState_Machine::End_Of_Frame:
            break;
    }
}

void CSerial_Terminal::Check_Bus_Idle_State()
{
    // Check if the bus is currently in an idle state.
    if (m_read_pin(m_RX_pin_idx))
    {
        m_RX_state = NState_Machine::Start_Bit;
    }
}

void CSerial_Terminal::Receive_Start_Bit()
{
    // A start bit is signalized by the voltage level being pulled down.
    if (!m_read_pin(m_RX_pin_idx))
    {
        m_RX_state = NState_Machine::Payload;
    }
}

void CSerial_Terminal::Receive_Payload()
{
    // Read the state of the RX pin.
    m_buffer += std::to_string(static_cast<int>(m_read_pin(m_RX_pin_idx)));

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
    if (!m_read_pin(m_RX_pin_idx))
    {
        m_logging_system->Error("Stop bit was not received correctly");

        // Wait until the RX line goes high again before attempting to detect the next start bit.
        m_RX_state = NState_Machine::Bus_Idle;
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
    Render_Control_Buttons();
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

void CSerial_Terminal::Render_Control_Buttons()
{
    if (ImGui::Button("Reset settings"))
    {
        m_cpu_cycles = 0;
        m_RX_state = NState_Machine::Start_Bit;
        m_RX_bit_idx = 0;
        m_buffer = "";
        std::fill(m_user_input.begin(), m_user_input.end(), 0);
    }

    ImGui::SameLine();

    if (ImGui::Button("Clear screen"))
    {
        m_terminal.Clear();
    }

    ImGui::SameLine();

    if (ImGui::RadioButton("CR+LF", m_use_cr_lf))
    {
        m_use_cr_lf = true;
    }

    ImGui::SameLine();

    if (ImGui::RadioButton("LF", !m_use_cr_lf))
    {
        m_use_cr_lf = false;
    }
}

void CSerial_Terminal::Render_User_Input()
{
    // Render the input text.
    ImGui::InputText("##User input", m_user_input.data(), User_Input_Buffer_Size);
    ImGui::SameLine();

    // Render the send button.
    if (ImGui::Button("Send"))
    {
        Add_User_Input_Into_TX_Queue();
    }

    ImGui::Separator();
}

void CSerial_Terminal::Add_User_Input_Into_TX_Queue()
{
    // Add the text user has entered into the TX FIFO.
    for (const char& c : m_user_input)
    {
        // Stop when we reach '\0'
        if (c == 0)
        {
            break;
        }

        // Print the current character to the terminal and add it to the TX queue.
        m_terminal.Add_Character(c);
        m_TX_queue.push(c);
    }

    // Append an enter character crlf
    if (m_use_cr_lf)
    {
        m_TX_queue.push('\r');
        m_TX_queue.push('\n');
    }
    else
    {
        m_TX_queue.push('\n');
    }

    // Add a new line to the terminal (enter).
    m_terminal.Add_Character('\n');

    // Clear the user input.
    std::fill(m_user_input.begin(), m_user_input.end(), 0);
}

void CSerial_Terminal::Update_TX()
{
    // UART TX state machine
    switch (m_TX_state)
    {
        // Start bit
        case NState_Machine::Start_Bit:
            Send_Start_Bit();
            break;

        // Payload
        case NState_Machine::Payload:
            Send_Payload();
            break;

        // Stop bit
        case NState_Machine::Stop_Bit:
            Send_Stop_Bit();
            break;

        case NState_Machine::End_Of_Frame:
            Reset_Transaction();
            break;

        // Not used for TX
        case NState_Machine::Bus_Idle:
            break;
    }
}

void CSerial_Terminal::Send_Start_Bit()
{
    // Make sure there is data to be sent.
    if (m_TX_queue.empty())
    {
        return;
    }

    // Pop the next byte out of the FIFO.
    m_TX_curr_data = m_TX_queue.front();
    m_TX_queue.pop();
    m_TX_state = NState_Machine::Payload;

    // Send a start bit.
    Set_TX_Pin(false);
}

void CSerial_Terminal::Send_Payload()
{
    // Send another bit of the payload.
    Set_TX_Pin(static_cast<bool>(m_TX_curr_data & 0b1U));

    // Update the fifo (prepare the next bit to be sent).
    m_TX_curr_data >>= 1U;
    ++m_TX_bit_idx;

    // Have all the bits been sent yet?
    if (m_TX_bit_idx >= m_data_length)
    {
        m_TX_state = NState_Machine::Stop_Bit;
    }
}

void CSerial_Terminal::Send_Stop_Bit()
{
    // Send a stop bit.
    Set_TX_Pin(true);
    m_TX_state = NState_Machine::End_Of_Frame;
}

void CSerial_Terminal::Reset_Transaction()
{
    m_TX_bit_idx = 0;
    m_TX_state = NState_Machine::Start_Bit;
}

void CSerial_Terminal::Set_TX_Pin(bool set)
{
    // Make sure the pin state was set successfully.
    if (m_set_pin(m_TX_pin_idx, set) != 0)
    {
        m_logging_system->Error("Failed to set the state of the UART TX pin");
    }
}

void CSerial_Terminal::Increment_Passed_Cycles(std::uint32_t count)
{
    m_cpu_cycles += count;

    // Should we update the UART RX state machine?
    if (m_cpu_cycles >= m_baud_rate)
    {
        m_cpu_cycles = 0;

        Update_RX();
        Update_TX();
    }
}

extern "C"
{
    zero_mate::IExternal_Peripheral::NInit_Status
    Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                      const char* const name,
                      const std::uint32_t* const connection,
                      std::size_t pin_count,
                      zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                      zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                      zero_mate::utils::CLogging_System* logging_system)
    {
        // Only one pin shall be passed to the peripheral.
        if (pin_count != 2)
        {
            return zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch;
        }

        // Create an instance of a serial monitor.
        // clang-format off
        *peripheral = new (std::nothrow) CSerial_Terminal(name,
                                                          connection[0],
                                                          connection[1],
                                                          read_pin,
                                                          set_pin,
                                                          logging_system);
        // clang-format on

        // Make sure the creation was successful.
        if (*peripheral == nullptr)
        {
            return zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error;
        }

        // All went well.
        return zero_mate::IExternal_Peripheral::NInit_Status::OK;
    }
}