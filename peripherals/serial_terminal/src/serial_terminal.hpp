// ---------------------------------------------------------------------------------------------------------------------
/// \file serial_terminal.hpp
/// \date 25. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a serial terminal that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include <array>
#include <queue>

#include "imgui.h"

#include "zero_mate/external_peripheral.hpp"

// ---------------------------------------------------------------------------------------------------------------------
/// \class CTerminal
/// \brief This class represents a serial monitor as a scrollable component.
// ---------------------------------------------------------------------------------------------------------------------
class CTerminal final
{
public:
    /// Gray color used in the terminal
    static constexpr ImVec4 Gray{ 0.65F, 0.65F, 0.65F, 1.0F };

    /// Yellow color used in the terminal
    static constexpr ImVec4 Yellow{ 1.0F, 1.0F, 0.0F, 1.0F };

public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param width Width of the terminal in 8-bit characters
    /// \param height Height of the terminal in 8-bit characters
    // -----------------------------------------------------------------------------------------------------------------
    explicit CTerminal(std::uint32_t width, std::uint32_t height);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Prints a single 8-bit character out to the terminal.
    /// \param c Character to be printed to the terminal
    // -----------------------------------------------------------------------------------------------------------------
    void Add_Character(char c);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the terminal.
    // -----------------------------------------------------------------------------------------------------------------
    void Render();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Clears the terminal.
    // -----------------------------------------------------------------------------------------------------------------
    void Clear();

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Scroll the terminal by one line if the latest character if out of screen
    // -----------------------------------------------------------------------------------------------------------------
    void Scroll_If_Needed();

private:
    std::uint32_t m_width;           ///< Width of the terminal
    std::uint32_t m_height;          ///< Height of the terminal
    std::uint32_t m_curr_line;       ///< Index of the current line
    std::vector<std::string> m_data; ///< "Pixels" of the terminal
};

// ---------------------------------------------------------------------------------------------------------------------
/// \class CSerial_Terminal
/// \brief This class represents a serial terminal that can be connected to a GPIO pin at runtime as a shared library.
// ---------------------------------------------------------------------------------------------------------------------
class CSerial_Terminal final : public zero_mate::IExternal_Peripheral
{
public:
    /// Frequency the CPU (a bit of cheating here).
    static constexpr std::uint32_t Clock_Rate = 250000000;

    /// Number of different baud rates
    static constexpr std::uint32_t Number_Of_Baud_Rate_Options = 8;

    /// Number of different data lengths
    static constexpr std::uint32_t Number_Of_Data_Length_Options = 2;

    /// Collection of different baud rates the user can pick from
    static const std::array<const char* const, Number_Of_Baud_Rate_Options> s_baud_rates;

    /// Collection of different data lengths the user can pick from
    static const std::array<const char* const, Number_Of_Data_Length_Options> s_data_lengths;

    /// Default width of the terminal
    static constexpr std::uint32_t Terminal_Width = 80;

    /// Default height of the terminal
    static constexpr std::uint32_t Terminal_Height = 25;

    /// Maximum number of characters the user is allowed to send via UART at a time
    static constexpr std::uint32_t User_Input_Buffer_Size = 64;

    // -----------------------------------------------------------------------------------------------------------------
    /// \enum NState_Machine
    /// \brief States used in the RX state machine (a single UART frame).
    // -----------------------------------------------------------------------------------------------------------------
    enum class NState_Machine
    {
        Bus_Idle,  ///< Checks if the bus is in an idle state
        Start_Bit, ///< Receive a start bit
        Payload,   ///< Receive a payload (actual data)
        Stop_Bit,  ///< Receive a stop bit (end of frame)
        End_Of_Frame
    };

public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param name Unique name of the peripheral
    /// \param RX_pin_idx UART RX pin index
    /// \param TX_pin_idx UART TX pin index
    /// \param read_pin Function the peripheral can used to read the state of a desired GPIO pin
    /// \param set_pin Function the peripheral can used to set the state of a desired GPIO pin
    /// \param logging_system Pointer to the logging system used throughout the application
    // -----------------------------------------------------------------------------------------------------------------
    explicit CSerial_Terminal(const std::string& name,
                              std::uint32_t RX_pin_idx,
                              std::uint32_t TX_pin_idx,
                              zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                              zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                              zero_mate::utils::CLogging_System* logging_system);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the serial terminal (GUI).
    // -----------------------------------------------------------------------------------------------------------------
    void Render() override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets an ImGuiContext, so the serial terminal can render itself as a GUI window.
    /// \param context ImGuiContext the serial terminal uses to render itself
    // -----------------------------------------------------------------------------------------------------------------
    void Set_ImGui_Context(void* context) override;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Lets the peripheral know about how many CPU cycles have passed by.
    /// \param count Number of passed CPU cycles (after the last instruction)
    // -----------------------------------------------------------------------------------------------------------------
    void Increment_Passed_Cycles(std::uint32_t count) override;

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders a settings section.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Settings();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders a baud rate drop-down menu.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Baud_Rate();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders a data length drop-down menu.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Data_Lengths();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders control button.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Control_Buttons();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the user input.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_User_Input();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Adds whatever user enters to the TX queue (char by char).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Add_User_Input_Into_TX_Queue();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Updates the UART TX state machine.
    // -----------------------------------------------------------------------------------------------------------------
    void Update_TX();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Updates the UART RX state machine.
    // -----------------------------------------------------------------------------------------------------------------
    void Update_RX();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Waits for the bus to be in an idle state (non-blocking).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Check_Bus_Idle_State();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Receives a start bit.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Receive_Start_Bit();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Receives another bit of the current payload (data).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Receive_Payload();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Receives a stop bit.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Receive_Stop_Bit();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sends a start bit.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Send_Start_Bit();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sends another bit of the current payload (data).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Send_Payload();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sends a stop bit.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Send_Stop_Bit();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Resets the current TX transaction.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Reset_Transaction();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets the value of the UART TX pin.
    /// \param set Value the TX pin will be set to
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_TX_Pin(bool set);

private:
    std::string m_name;                                          ///< Unique name of the peripheral
    std::uint32_t m_RX_pin_idx;                                  ///< UART RX index
    std::uint32_t m_TX_pin_idx;                                  ///< UART TX index
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin; ///< Function used to read the state of a GPIO pin
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin;   ///< Function used to set the state of a GPIO pin
    ImGuiContext* m_context;                                     ///< ImGui context
    int m_baud_rate_idx;                                         ///< Index of the chosen baud rate
    std::uint32_t m_baud_rate;                                   ///< Value of the chosen baud rate
    int m_data_length_idx;                                       ///< Index of the chosen data length
    std::uint32_t m_data_length;                                 ///< Value of the chosen data length
    zero_mate::utils::CLogging_System* m_logging_system;         ///< Logging system
    bool m_use_cr_lf;                                            ///< Use CR+LF as the enter termination character

    std::uint32_t m_cpu_cycles;                            ///< Number of passed CPU cycles
    NState_Machine m_RX_state;                             ///< Current state of the UART RX state machine
    std::uint32_t m_RX_bit_idx;                            ///< Current bit index of the current payload (RX)
    std::string m_buffer;                                  ///< Reception FIFO
    CTerminal m_terminal;                                  ///< GUI element of the serial terminal
    std::array<char, User_Input_Buffer_Size> m_user_input; ///< User input (text area)
    std::queue<std::uint8_t> m_TX_queue;                   ///< TX FIFO (queue)
    NState_Machine m_TX_state;                             ///< Current state of the UART TX state machine
    std::uint32_t m_TX_bit_idx;                            ///< Current bit index of the current payload (TX)
    std::uint8_t m_TX_curr_data;                           ///< Current data being sent via UART (TX)
};