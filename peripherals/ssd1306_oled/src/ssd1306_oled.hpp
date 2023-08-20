// ---------------------------------------------------------------------------------------------------------------------
/// \file ssd1306_oled.hpp
/// \date 20. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an SSD1306 OLED display that can be connected to I2C pins at runtime as a shared library.
///
/// You can find more information about the display itself over at https://cdn-shop.adafruit.com/datasheets/SSD1306.pdf
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <vector>
/// \endcond

#include "imgui.h"

#define ZERO_MATE_EXPORT
#include "zero_mate/external_peripheral.hpp"

// ---------------------------------------------------------------------------------------------------------------------
/// \class CSSD1036_OLED
/// \brief This class represents an SSD1036 OLED display.
// ---------------------------------------------------------------------------------------------------------------------
class CSSD1036_OLED final : public zero_mate::IExternal_Peripheral
{
public:
    /// Length of the slave address
    static constexpr std::uint8_t Slave_Addr_Length = 7;

    /// Length of a data payload
    static constexpr std::uint8_t Data_Length = 8;

    /// Width of the display (in pixels)
    static constexpr std::uint32_t Width = 128;

    /// Height of the display (in pixels)
    static constexpr std::uint32_t Height = 32;

    /// Size of a single pixel
    static constexpr std::uint32_t Pixel_Size = 2;

    /// Pixel color ON
    static constexpr ImVec4 Color_Pixel_ON = { 0.6, 0.8, 1, 1 };

    /// Pixel color OFF
    static constexpr ImVec4 Color_Pixel_OFF = { 0.15, 0.15, 0.15, 1 };

    // -----------------------------------------------------------------------------------------------------------------
    /// \enum NCMD
    /// \brief Enumeration of different commands of the OLED display.
    // -----------------------------------------------------------------------------------------------------------------
    enum class NCMD : std::uint8_t
    {
        Command_Start = 0x00,               ///< Command start
        Data_Start = 0xC0,                  ///< Data start
        Data_Continue = 0x40,               ///< Data continue
        Set_Contrast = 0x81,                ///< Set contrast
        Display_All_On_Resume = 0xA4,       ///< Display all on resume
        Display_All_On = 0xA5,              ///< Display all on
        Normal_Display = 0xA6,              ///< Normal display
        Inverted_Display = 0xA7,            ///< Inverted display
        Display_Off = 0xAE,                 ///< Display off
        Display_On = 0xAF,                  ///< Display on
        Nop = 0xE3,                         ///< Nop
        Horizontal_Scroll_Right = 0x26,     ///< Horizontal scroll right
        Horizontal_Scroll_Left = 0x27,      ///< Horizontal scroll left
        Horizontal_Scroll_Vrt_Right = 0x29, ///< Horizontal scroll vertical right
        Horizontal_Scroll_Vrt_Left = 0x2A,  ///< Horizontal scroll vertical left
        Deactivate_Scroll = 0x2E,           ///< Deactivate scroll
        Activate_Scroll = 0x2F,             ///< Activate scroll
        Set_Vrt_Scroll_Area = 0xA3,         ///< Set vertical scroll area
        Set_Lower_Column = 0x00,            ///< Set lower column
        Set_Upper_Column = 0x10,            ///< Set upper column
        Memory_Addr_Mode = 0x20,            ///< Memory address mode
        Set_Column_Addr = 0x21,             ///< Set column address
        Set_Page_Addr = 0x22,               ///< Set page address
        Set_Start_Line = 0x40,              ///< Set start line
        Set_Segment_Remap = 0xA0,           ///< Set segment remap
        Set_Multiplex_Ratio = 0xA8,         ///< Set multiplex ratio
        Com_Scan_Dir_Inc = 0xC0,            ///< Com scan dir increment
        Com_Scan_Dir_Dec = 0xC8,            ///< Com scan dir decrement
        Set_Display_Offset = 0xD3,          ///< Set display offset
        Set_Com_Pins = 0xDA,                ///< Set com pins
        Charge_Pump = 0x8D,                 ///< Charge pump
        Set_Display_Clock_Div_Ratio = 0xD5, ///< Set display clock div ration
        Set_Precharge_Period = 0xD9,        ///< Set precharge period
        Set_VCOM_Detect = 0xD8,             ///< Set VCOM detect
    };

public:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Creates an instance of the class.
    /// \param name Unique name of the device
    /// \param address Address of the device
    /// \param sda_pin_idx SDA pin index
    /// \param scl_pin_idx SCL pin index
    /// \param read_pin Function the peripheral uses to read GPIO pins
    /// \param set_pin Function the peripheral uses to set GPIO pins
    /// \param logging_system Logging system
    // -----------------------------------------------------------------------------------------------------------------
    explicit CSSD1036_OLED(const std::string& name,
                           std::uint32_t address,
                           std::uint32_t sda_pin_idx,
                           std::uint32_t scl_pin_idx,
                           zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                           zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                           zero_mate::utils::CLogging_System* logging_system);

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
    /// \brief Notifies the peripheral that the state of one of the pins it subscribes to has changed.
    /// \param pin_idx Index of the GPIO pin whose state has been changed
    // -----------------------------------------------------------------------------------------------------------------
    void GPIO_Subscription_Callback([[maybe_unused]] std::uint32_t pin_idx) override;

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \enum NState_Machine
    /// \brief Enumeration of different states of the I2C state machine.
    // -----------------------------------------------------------------------------------------------------------------
    enum class NState_Machine : std::uint8_t
    {
        Start_Bit, ///< Receive the start bit
        Address,   ///< Receive the address of the target machine
        RW,        ///< Receive the RW bit
        ACK_1,     ///< Send the ACK_1 bit
        Data,      ///< Receive the data payload
        ACK_2      ///< Send the ACK_2 bit
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \enum TTransaction
    /// \brief  Representation of a single data transaction.
    // -----------------------------------------------------------------------------------------------------------------
    struct TTransaction
    {
        NState_Machine state{ NState_Machine::Start_Bit }; ///< Current state of the state machine
        std::uint32_t address{ 0x0 };                      ///< Slave address
        std::uint8_t data{ 0 };                            ///< Total number of bytes
        std::uint8_t addr_idx{ Slave_Addr_Length };        ///< Index of the current bit of the slave's address
        std::uint8_t data_idx{ Data_Length };              ///< Index of the current bit of the current data payload
        bool read{ false };                                ///< Is the device being written into?
    };

private:
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders information about the display (width, height, address, ...).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Information() const;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Renders the display itself.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Render_Display();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes GPIO subscription (what GPIO pins we want to be notified about).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Init_GPIO_Subscription();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes the pixes of the display.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Init_Pixels();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Updates the I2C state machine.
    // -----------------------------------------------------------------------------------------------------------------
    inline void I2C_Update();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Receives the start bit.
    // -----------------------------------------------------------------------------------------------------------------
    inline void I2C_Receive_Start_Bit();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Receives the address of the target device.
    // -----------------------------------------------------------------------------------------------------------------
    inline void I2C_Receive_Address();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Receives the RW bit.
    // -----------------------------------------------------------------------------------------------------------------
    inline void I2C_Receive_RW_Bit();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Receives a data payload.
    // -----------------------------------------------------------------------------------------------------------------
    inline void I2C_Receive_Data();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief SCL pin change callback.
    /// \param curr_pin_state Current state of the SCL pin
    // -----------------------------------------------------------------------------------------------------------------
    inline void SCL_Pin_Change_Callback(bool curr_pin_state);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief SDA pin change callback.
    /// \param curr_pin_state Current state of the SDA pin
    // -----------------------------------------------------------------------------------------------------------------
    inline void SDA_Pin_Change_Callback(bool curr_pin_state);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Callback of the end of an ongoing transactions (all data has been received).
    // -----------------------------------------------------------------------------------------------------------------
    inline void Received_Transaction_Callback();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Initializes a new transaction.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Init_Transaction();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sends an ACK bit back to the master device.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Send_ACK();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Processes a received command.
    /// \param data Raw data (command) that has been received
    // -----------------------------------------------------------------------------------------------------------------
    inline void Process_CMD(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Processes received data.
    /// \param data Raw data that has been received
    // -----------------------------------------------------------------------------------------------------------------
    inline void Process_Data(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Returns the color of a given pixel.
    /// \param y Y coordinate
    /// \param x X coordinate
    /// \return Current color of the addressed pixel
    // -----------------------------------------------------------------------------------------------------------------
    [[nodiscard]] inline ImColor Get_Pixel_Color(std::uint32_t y, std::uint32_t x) const;

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Logs received data within the last transaction.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Log_Received_Data();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Updates the type of processing data (Data vs Command).
    /// \param data Raw data (first byte) of the last payload
    // -----------------------------------------------------------------------------------------------------------------
    void Updated_Type_Of_Processing_Data(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Turns on/off a given pixel.
    /// \param y Y coordinate
    /// \param x X coordinate
    /// \param set Indication of whether the pixel should be turned on or off
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Pixel(std::uint32_t y, std::uint32_t x, bool set);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Display off command callback.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Display_Off_Callback();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Display on command callback.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Display_On_Callback();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set display clock div ratio callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Display_Clock_Div_Ratio_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set column addr command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Column_Addr_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set multiplex ratio callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Multiplex_Ratio(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set display offset command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Display_Offset(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Charge pump command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Charge_Pump_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Memory addr mode command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Memory_Addr_Mode_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Com scan dir decrement command callback.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Com_Scan_Dir_Dec_Callback();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set com pins command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Com_Pins_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set contrast command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Contrast_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set precharge period command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Precharge_Period_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set VCOM detect command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_VCOM_Detect_Callback(std::uint8_t data);

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Display all on resume command callback.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Display_All_On_Resume_Callback();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Normal display command callback.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Normal_Display_Callback();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Deactivate scroll callback.
    // -----------------------------------------------------------------------------------------------------------------
    inline void Deactivate_Scroll_Callback();

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Set page address command callback.
    /// \param data Data associated with the command
    // -----------------------------------------------------------------------------------------------------------------
    inline void Set_Page_Addr_Callback(std::uint8_t data);

private:
    std::string m_name;                                          ///< Unique name of the peripheral
    std::uint32_t m_address;                                     ///< Address of the device
    std::uint32_t m_sda_pin_idx;                                 ///< Index of the SDA pin
    std::uint32_t m_scl_pin_idx;                                 ///< Index of the SCL pin
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin; ///< Function to read the state of a GPIO pin
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin;   ///< Function to set the state of a GPIO pin
    TTransaction m_transaction;                                  ///< Ongoing transaction
    std::vector<std::uint8_t> m_fifo;                            ///< Data FIFO
    std::uint32_t m_clock;                                       ///< Emulation of the current time
    std::uint32_t m_sda_rising_edge_timestamp;                   ///< Timestamp of SDA going from LOW to HIGH
    std::uint32_t m_scl_rising_edge_timestamp;                   ///< Timestamp of SCL going from LOW to HIGH
    bool m_sda_prev_state;                                       ///< Previous tate of the SDA pin
    bool m_scl_prev_state;                                       ///< Previous tate of the SCL pin
    bool m_sda_rising_edge;                                      ///< Rising edge detected on SDA?
    bool m_scl_rising_edge;                                      ///< Rising edge detected on SCL?
    zero_mate::utils::CLogging_System* m_logging_system;         ///< Logging system
    ImGuiContext* m_ImGui_context;                               ///< ImGUI context
    bool m_display_on;                                           ///< Is the display on?
    std::vector<bool> m_pixels;                                  ///< Collection of all pixels.
    bool m_processing_cmd;                                       ///< Are we currently processing a command or data?
    NCMD m_curr_cmd;                                             ///< Current command being processed
    bool m_lock_incoming_data;                                   ///< Should not the next data be interpreted as a cmd?
    std::uint32_t m_y;                                           ///< Current Y cursor position
    std::uint32_t m_x;                                           ///< Current X cursor position
    std::uint32_t m_y_ref;                                       ///< Y offset (essentially a row)
};