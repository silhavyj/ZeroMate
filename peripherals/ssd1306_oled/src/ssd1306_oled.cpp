// ---------------------------------------------------------------------------------------------------------------------
/// \file ssd1306_oled.cpp
/// \date 20. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements an SSD1306 OLED display that can be connected to I2C pins at runtime as a shared lib.
///
/// You can find more information about the display itself over at https://cdn-shop.adafruit.com/datasheets/SSD1306.pdf
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <limits>
#include <sstream>
/// \endcond

// Project file imports

#include "ssd1306_oled.hpp"

CSSD1036_OLED::CSSD1036_OLED(const std::string& name,
                             std::uint32_t address,
                             std::uint32_t sda_pin_idx,
                             std::uint32_t scl_pin_idx,
                             zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                             zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                             zero_mate::utils::CLogging_System* logging_system)
: m_name{ std::move(name) }
, m_address{ address }
, m_sda_pin_idx{ sda_pin_idx }
, m_scl_pin_idx{ scl_pin_idx }
, m_read_pin{ read_pin }
, m_set_pin{ set_pin }
, m_transaction{}
, m_clock{ 0 }
, m_sda_rising_edge_timestamp{ 0 }
, m_scl_rising_edge_timestamp{ 0 }
, m_sda_prev_state{ false }
, m_scl_prev_state{ false }
, m_sda_rising_edge{ false }
, m_scl_rising_edge{ false }
, m_logging_system{ logging_system }
, m_ImGui_context{ nullptr }
, m_display_on{ false }
, m_processing_cmd{ true }
, m_lock_incoming_data{ false }
, m_y{ 0 }
, m_x{ 0 }
, m_y_ref{ 0 }
{
    Init_Pixels();
    Init_GPIO_Subscription();
}

void CSSD1036_OLED::Set_ImGui_Context(void* context)
{
    m_ImGui_context = static_cast<ImGuiContext*>(context);
}

void CSSD1036_OLED::Init_GPIO_Subscription()
{
    m_gpio_subscription.insert(m_sda_pin_idx);
    m_gpio_subscription.insert(m_scl_pin_idx);
}

void CSSD1036_OLED::Init_Pixels()
{
    // Create the pixels.
    for (std::uint32_t i = 0; i < Width * Height; ++i)
    {
        m_pixels.push_back(false);
    }
}

void CSSD1036_OLED::Render()
{
    // Make sure ImGuiContext has been set correctly.
    assert(m_ImGui_context != nullptr);

    // Switch the context.
    ImGui::SetCurrentContext(m_ImGui_context);

    // Render the window.
    if (ImGui::Begin(m_name.c_str()))
    {
        Render_Information();
        Render_Display();
    }

    ImGui::End();
}

void CSSD1036_OLED::Render_Information() const
{
    ImGui::Text("SSD1306 OLED display (%dx%d pxls)", Width, Height);
    ImGui::Text("I2C addr = 0x%X (%d dec)", m_address, m_address);
    ImGui::Separator();
}

void CSSD1036_OLED::Render_Display()
{
    // Create a new ImDrawList to draw the pixels.
    ImDrawList* draw_list = ImGui::GetWindowDrawList();

    // Get the region boundaries.
    ImVec2 v_min = ImGui::GetWindowContentRegionMin();

    // Offset from the top of the window.
    static constexpr int OFFSET_Y = 50;

    // Move it relatively to the window position.
    v_min.x += ImGui::GetWindowPos().x;
    v_min.y += ImGui::GetWindowPos().y + OFFSET_Y;

    // Render all pixels.
    for (std::uint32_t y = 0; y < Height; ++y)
    {
        for (std::uint32_t x = 0; x < Width; ++x)
        {
            // Render the current pixel.
            draw_list->AddRectFilled({ v_min.x, v_min.y },
                                     { v_min.x + Pixel_Size, v_min.y + Pixel_Size },
                                     Get_Pixel_Color(y, x));

            // Move on to the next column.
            v_min.x += Pixel_Size;
        }

        v_min.y += Pixel_Size;         // Move on to the next row
        v_min.x -= Width * Pixel_Size; // Move back to the beginning of the row (0th column)
    }
}

ImColor CSSD1036_OLED::Get_Pixel_Color(std::uint32_t y, std::uint32_t x) const
{
    // If the display is off or the addressed pixel is not turned on, return Color_Pixel_OFF.
    if (!m_display_on || !m_pixels[y * Width + x])
    {
        return ImColor{ Color_Pixel_OFF };
    }

    // Return Color_Pixel_ON.
    return ImColor{ Color_Pixel_ON };
}

void CSSD1036_OLED::GPIO_Subscription_Callback(std::uint32_t pin_idx)
{
    // Increment the clock and read the current state of the pin.
    ++m_clock;
    const bool curr_pin_state = m_read_pin(pin_idx);

    // Call the corresponding callback function.
    if (pin_idx == m_sda_pin_idx)
    {
        // Call SDA callback.
        SDA_Pin_Change_Callback(curr_pin_state);
    }
    else if (pin_idx == m_scl_pin_idx)
    {
        // Call SCL callback.
        SCL_Pin_Change_Callback(curr_pin_state);
    }

    // Check if the master has just sent a stop bit.
    // Definition of a stop bit: SDA goes high after SCL
    const bool stop_bit_detected = m_sda_rising_edge && m_scl_rising_edge &&
                                   (m_sda_rising_edge_timestamp - m_scl_rising_edge_timestamp) == 1 &&
                                   m_transaction.state == NState_Machine::Data;

    // If a stop bit has just been detected, terminate the current transaction.
    if (stop_bit_detected)
    {
        m_transaction.state = NState_Machine::Start_Bit;
        Received_Transaction_Callback();
    }
}

void CSSD1036_OLED::SCL_Pin_Change_Callback(bool curr_pin_state)
{
    m_scl_rising_edge = false;

    // Check if SCL just went from HIGH to LOW and the device is awaiting a start bit.
    if (m_scl_prev_state && !curr_pin_state && m_transaction.state == NState_Machine::Start_Bit)
    {
        // Start of a new transaction.
        I2C_Update();
    }
    // Check is there is a rising edge on the SCL pin.
    else if (!m_scl_prev_state && curr_pin_state)
    {
        // Update the timestamp.
        m_scl_rising_edge = true;
        m_scl_rising_edge_timestamp = m_clock;

        // Update the state machine with every rising edge.
        I2C_Update();
    }

    // Update the previous state of the SCL pin.
    m_scl_prev_state = curr_pin_state;
}

void CSSD1036_OLED::SDA_Pin_Change_Callback(bool curr_pin_state)
{
    m_sda_rising_edge = false;

    // Check if there is a rising edge on the SDA pin.
    if (!m_sda_prev_state && curr_pin_state)
    {
        // Update the timestamp.
        m_sda_rising_edge = true;
        m_sda_rising_edge_timestamp = m_clock;
    }

    // Update the previous state of the SDA pin.
    m_sda_prev_state = curr_pin_state;
}

void CSSD1036_OLED::I2C_Update()
{
    // I2C state machine
    switch (m_transaction.state)
    {
        // Receive the start bit.
        case NState_Machine::Start_Bit:
            I2C_Receive_Start_Bit();
            break;

        // Receive the slave's address.
        case NState_Machine::Address:
            I2C_Receive_Address();
            break;

        // Receive the RW bit.
        case NState_Machine::RW:
            I2C_Receive_RW_Bit();
            break;

        // Send the ACK_1 bit.
        case NState_Machine::ACK_1:
            m_transaction.state = NState_Machine::Data;
            break;

        // Receive data (payload).
        case NState_Machine::Data:
            I2C_Receive_Data();
            break;

        // Send the ACK_2 bit.
        case NState_Machine::ACK_2:
            // Move on to receiving another byte.
            m_transaction.data = 0;
            m_transaction.data_idx = Data_Length;
            m_transaction.state = NState_Machine::Data;
            break;
    }
}

void CSSD1036_OLED::Log_Received_Data()
{
    std::stringstream ss{};

    ss << "Received data: ";

    for (const auto& value : m_fifo)
    {
        ss << static_cast<std::uint32_t>(value) << " ";
    }

    m_logging_system->Debug(ss.str().c_str());
}

void CSSD1036_OLED::Updated_Type_Of_Processing_Data(std::uint8_t data)
{
    // Check the type of data that has been received.
    const auto cmd = static_cast<NCMD>(data);

    // Are we going to be processing data?
    if (cmd == NCMD::Data_Start || cmd == NCMD::Data_Continue)
    {
        m_processing_cmd = false;
    }
    // Are we going to be processing commands?
    else if (cmd == NCMD::Command_Start)
    {
        m_processing_cmd = true;
    }
}

void CSSD1036_OLED::Received_Transaction_Callback()
{
    // Log_Received_Data();

    // If the FIFO is empty, there is nothing to do.
    if (m_fifo.empty())
    {
        return;
    }

    // Check what kind of that we will be processing.
    Updated_Type_Of_Processing_Data(m_fifo[0]);

    // Process all data received in the FIFO.
    for (std::size_t idx = 1; idx < m_fifo.size(); ++idx)
    {
        if (m_processing_cmd)
        {
            // Process a command.
            Process_CMD(m_fifo[idx]);
        }
        else
        {
            // Process data (pixel values).
            Process_Data(m_fifo[idx]);
        }
    }
}

void CSSD1036_OLED::Process_Data(std::uint8_t data)
{
    // Go through individual bits of the received byte of data.
    for (std::int8_t i = 0U; i < std::numeric_limits<std::uint8_t>::digits; ++i)
    {
        // Should the pixel be set?
        const auto set = static_cast<bool>(static_cast<std::uint8_t>(data >> static_cast<std::uint8_t>(i)) & 0b1U);

        // Set the pixel and move on to the next row.
        Set_Pixel(m_y, m_x, set);
        ++m_y;
    }

    // Move on to the next column.
    ++m_x;

    // Check if we are passed the width of the screen.
    if (m_x >= Width)
    {
        // Go back to the first column and move on to the next row (+8 bits)
        m_x = 0;
        m_y_ref += std::numeric_limits<std::uint8_t>::digits;

        // Check if we are passed the height of the screen.
        if (m_y_ref >= Height)
        {
            // Go back to the top left corner.
            m_y_ref = 0;
        }
    }

    m_y = m_y_ref;
}

void CSSD1036_OLED::Process_CMD(std::uint8_t data)
{
    // If the previous command locked the data, do not interpret the is as a command.
    // The command is supposed to unlock it once it has processed all data it required.
    if (!m_lock_incoming_data)
    {
        m_curr_cmd = static_cast<NCMD>(data);
    }

    // Process the current command.
    switch (m_curr_cmd)
    {
        // Display off
        case NCMD::Display_Off:
            Display_Off_Callback();
            break;

        // Display on
        case NCMD::Display_On:
            Display_On_Callback();
            break;

        // Set display clock div ratio
        case NCMD::Set_Display_Clock_Div_Ratio:
            Set_Display_Clock_Div_Ratio_Callback(data);
            break;

        // Set multiplex ratio
        case NCMD::Set_Multiplex_Ratio:
            Set_Multiplex_Ratio(data);
            break;

        // Set display offset
        case NCMD::Set_Display_Offset:
            Set_Display_Offset(data);
            break;

        // Charge pump
        case NCMD::Charge_Pump:
            Charge_Pump_Callback(data);
            break;

        // Memory address mode
        case NCMD::Memory_Addr_Mode:
            Memory_Addr_Mode_Callback(data);
            break;

        // Com scan dir deccrement
        case NCMD::Com_Scan_Dir_Dec:
            Com_Scan_Dir_Dec_Callback();
            break;

        // Set com pins
        case NCMD::Set_Com_Pins:
            Set_Com_Pins_Callback(data);
            break;

        // Set contrast
        case NCMD::Set_Contrast:
            Set_Contrast_Callback(data);
            break;

        // Set precharge period
        case NCMD::Set_Precharge_Period:
            Set_Precharge_Period_Callback(data);
            break;

        // Set VCOM detect
        case NCMD::Set_VCOM_Detect:
            Set_VCOM_Detect_Callback(data);
            break;

        // Display all on resume
        case NCMD::Display_All_On_Resume:
            Display_All_On_Resume_Callback();
            break;

        // Normal display
        case NCMD::Normal_Display:
            Normal_Display_Callback();
            break;

        // Deactivate scroll
        case NCMD::Deactivate_Scroll:
            Deactivate_Scroll_Callback();
            break;

        // Set page address
        case NCMD::Set_Page_Addr:
            Set_Page_Addr_Callback(data);
            break;

        // Set column address
        case NCMD::Set_Column_Addr:
            Set_Column_Addr_Callback(data);
            break;

        case NCMD::Display_All_On:
        case NCMD::Inverted_Display:
        case NCMD::Nop:
        case NCMD::Horizontal_Scroll_Right:
        case NCMD::Horizontal_Scroll_Left:
        case NCMD::Horizontal_Scroll_Vrt_Right:
        case NCMD::Horizontal_Scroll_Vrt_Left:
        case NCMD::Activate_Scroll:
        case NCMD::Set_Vrt_Scroll_Area:
        case NCMD::Set_Upper_Column:
        case NCMD::Set_Segment_Remap:
            break;

        case NCMD::Command_Start:
            [[fallthrough]];
        case NCMD::Data_Start:
        case NCMD::Data_Continue:
            break;
    }
}

void CSSD1036_OLED::Display_Off_Callback()
{
    m_display_on = false;
    m_logging_system->Debug("Display OFF");
}

void CSSD1036_OLED::Display_On_Callback()
{
    m_display_on = true;
    m_logging_system->Debug("Display ON");
}

void CSSD1036_OLED::Set_Display_Clock_Div_Ratio_Callback(std::uint8_t data)
{
    if (m_lock_incoming_data)
    {
        // Unlock incoming data.
        m_lock_incoming_data = false;
        const std::string msg = "Display_Clock_Div_Ratio = " + std::to_string(static_cast<std::uint32_t>(data));
        m_logging_system->Debug(msg.c_str());
        return;
    }

    // Lock incoming data.
    m_lock_incoming_data = true;
}

void CSSD1036_OLED::Set_Multiplex_Ratio(std::uint8_t data)
{
    if (m_lock_incoming_data)
    {
        // Unlock incoming data.
        m_lock_incoming_data = false;
        const std::string msg = "Multiplex_Ratio = " + std::to_string(static_cast<std::uint32_t>(data));
        m_logging_system->Debug(msg.c_str());
        return;
    }

    // Lock incoming data.
    m_lock_incoming_data = true;
}

void CSSD1036_OLED::Set_Display_Offset(std::uint8_t data)
{
    static int state{ 0 };
    std::string msg;

    switch (state)
    {
        // Lock incoming data.
        case 0:
            m_lock_incoming_data = true;
            state = 1;
            break;

        // Display offset 0.
        case 1:
            state = 2;
            msg = "Display_Offset[0] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());
            break;

        // Unlock incoming data.
        // Display offset 1.
        case 2:
            m_lock_incoming_data = false;
            state = 0;
            msg = "Display_Offset[1] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());
            break;

        default:
            m_logging_system->Error("Error when setting Display_Offset");
            break;
    }
}

void CSSD1036_OLED::Charge_Pump_Callback(std::uint8_t data)
{
    if (m_lock_incoming_data)
    {
        // Unlock incoming data.
        m_lock_incoming_data = false;
        const std::string msg = "Charge_Pump = " + std::to_string(static_cast<std::uint32_t>(data));
        m_logging_system->Debug(msg.c_str());
        return;
    }

    // Lock incoming data.
    m_lock_incoming_data = true;
}

void CSSD1036_OLED::Memory_Addr_Mode_Callback(std::uint8_t data)
{
    static int state{ 0 };
    std::string msg;

    switch (state)
    {
        // Lock incoming data.
        case 0:
            m_lock_incoming_data = true;
            state = 1;
            break;

        // Memory_Addr_Mode 0.
        case 1:
            state = 2;
            msg = "Memory_Addr_Mode[0] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());
            break;

        // Unlock incoming data.
        // Memory_Addr_Mode 1.
        case 2:
            m_lock_incoming_data = false;
            state = 0;
            msg = "Memory_Addr_Mode[1] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());
            break;

        default:
            m_logging_system->Error("Error when setting Memory_Addr_Mode");
            break;
    }
}

void CSSD1036_OLED::Com_Scan_Dir_Dec_Callback()
{
    m_logging_system->Debug("Com_Scan_Dir_Dec");
}

void CSSD1036_OLED::Set_Com_Pins_Callback(std::uint8_t data)
{
    if (m_lock_incoming_data)
    {
        // Unlock incoming data.
        m_lock_incoming_data = false;
        const std::string msg = "Com_Pins = " + std::to_string(static_cast<std::uint32_t>(data));
        m_logging_system->Debug(msg.c_str());
        return;
    }

    // Lock incoming data.
    m_lock_incoming_data = true;
}

void CSSD1036_OLED::Set_Contrast_Callback(std::uint8_t data)
{
    if (m_lock_incoming_data)
    {
        // Unlock incoming data.
        m_lock_incoming_data = false;
        const std::string msg = "Contrast = " + std::to_string(static_cast<std::uint32_t>(data));
        m_logging_system->Debug(msg.c_str());
        return;
    }

    // Lock incoming data.
    m_lock_incoming_data = true;
}

void CSSD1036_OLED::Set_Precharge_Period_Callback(std::uint8_t data)
{
    if (m_lock_incoming_data)
    {
        // Unlock incoming data.
        m_lock_incoming_data = false;
        const std::string msg = "Precharge_Period = " + std::to_string(static_cast<std::uint32_t>(data));
        m_logging_system->Debug(msg.c_str());
        return;
    }

    // Lock incoming data.
    m_lock_incoming_data = true;
}

void CSSD1036_OLED::Set_VCOM_Detect_Callback(std::uint8_t data)
{
    if (m_lock_incoming_data)
    {
        // Unlock incoming data.
        m_lock_incoming_data = false;
        const std::string msg = "VCOM_Detect = " + std::to_string(static_cast<std::uint32_t>(data));
        m_logging_system->Debug(msg.c_str());
        return;
    }

    // Lock incoming data.
    m_lock_incoming_data = true;
}

void CSSD1036_OLED::Display_All_On_Resume_Callback()
{
    m_logging_system->Debug("Display_All_On");
}

void CSSD1036_OLED::Normal_Display_Callback()
{
    m_logging_system->Debug("Normal_Display");
}

void CSSD1036_OLED::Deactivate_Scroll_Callback()
{
    m_logging_system->Debug("Deactivate_Scroll");
}

void CSSD1036_OLED::Set_Page_Addr_Callback(std::uint8_t data)
{
    static int state{ 0 };
    std::string msg;

    switch (state)
    {
        // Lock incoming data.
        case 0:
            m_lock_incoming_data = true;
            state = 1;
            break;

        // Page address 0.
        case 1:
            state = 2;
            msg = "Page_Addr[0] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());
            break;

        // Unlock incoming data.
        // Page address 1.
        case 2:
            m_lock_incoming_data = false;
            state = 0;
            msg = "Page_Addr[1] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());
            break;

        default:
            m_logging_system->Error("Error when setting Memory_Addr_Mode");
            break;
    }
}

void CSSD1036_OLED::Set_Column_Addr_Callback(std::uint8_t data)
{
    static int state{ 0 };
    std::string msg;

    switch (state)
    {
        // Lock incoming data.
        case 0:
            m_lock_incoming_data = true;
            state = 1;
            break;

        // Column address 0.
        case 1:
            state = 2;
            msg = "Column_Addr[0] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());

            // TODO use actual data received over I2C
            m_y = 0;
            m_x = 0;
            m_y_ref = 0;

            break;

        // Unlock incoming data.
        // Column address 1.
        case 2:
            m_lock_incoming_data = false;
            state = 0;
            msg = "Column_Addr[1] = " + std::to_string(static_cast<std::uint32_t>(data));
            m_logging_system->Debug(msg.c_str());
            break;

        default:
            m_logging_system->Error("Error when setting Memory_Addr_Mode");
            break;
    }
}

void CSSD1036_OLED::Set_Pixel(std::uint32_t y, std::uint32_t x, bool set)
{
    m_pixels[y * Width + x] = set;
}

void CSSD1036_OLED::I2C_Receive_Start_Bit()
{
    if (!m_read_pin(m_sda_pin_idx))
    {
        Init_Transaction();
        m_transaction.state = NState_Machine::Address;
    }
}

void CSSD1036_OLED::Init_Transaction()
{
    m_fifo.clear();

    m_transaction.address = 0x0;
    m_transaction.data = 0;
    m_transaction.data_idx = Data_Length;
    m_transaction.addr_idx = Slave_Addr_Length;
    m_transaction.read = false;
}

void CSSD1036_OLED::I2C_Receive_Address()
{
    --m_transaction.addr_idx;

    // Read the state of the SDA pin and update the address.
    if (m_read_pin(m_sda_pin_idx))
    {
        m_transaction.address |= (0b1U << m_transaction.addr_idx);
    }

    // Have we read all bits of the address yet?
    if (m_transaction.addr_idx == 0)
    {
        // Move on to receiving the RW bit.
        m_transaction.state = NState_Machine::RW;
    }
}

void CSSD1036_OLED::I2C_Receive_RW_Bit()
{
    // Read the RW bit.
    m_transaction.read = m_read_pin(m_sda_pin_idx);

    // Send an ACK bit to the master device.
    Send_ACK();
    m_transaction.state = NState_Machine::ACK_1;
}

void CSSD1036_OLED::I2C_Receive_Data()
{
    --m_transaction.data_idx;

    // Read the state of the SDA pin and update the data (receiving byte).
    if (m_read_pin(m_sda_pin_idx))
    {
        m_transaction.data |= (0b1U << m_transaction.data_idx);
    }

    // Have we read all 8 bits of the data yet?
    if (m_transaction.data_idx == 0)
    {
        // Store the data into the FIFO only if it is meant to be for us.
        if (m_address == m_transaction.address)
        {
            m_fifo.push_back(m_transaction.data);
        }

        // Send an ACK bit to the master device.
        Send_ACK();
        m_transaction.state = NState_Machine::ACK_2;
    }
}

void CSSD1036_OLED::Send_ACK()
{
    // Do NOT send an ACK bit to the master devices, unless they are talking to us.
    if (m_transaction.address != m_address)
    {
        return;
    }

    // Send an ACK bit.
    const int status = m_set_pin(m_sda_pin_idx, false);

    // Check for any possible errors.
    if (status != 0)
    {
        m_logging_system->Error("Failed to set the value of the SDA pin (ACK)");
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
        // SDA, SCL, and address
        if (pin_count != 3)
        {
            return zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch;
        }

        // Create an instance of an SSD1306 OLED display.
        // clang-format off
        *peripheral = new (std::nothrow) CSSD1036_OLED(name,
                                                       connection[2], // Address
                                                       connection[1], // SDA
                                                       connection[0], // SCL
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