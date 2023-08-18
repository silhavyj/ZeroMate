#include <sstream>

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
{
    Init_GPIO_Subscription();
}

void CSSD1036_OLED::Set_ImGui_Context(void* context)
{
    m_ImGui_context = static_cast<ImGuiContext *>(context);
}

void CSSD1036_OLED::Init_GPIO_Subscription()
{
    m_gpio_subscription.insert(m_sda_pin_idx);
    m_gpio_subscription.insert(m_scl_pin_idx);
}

void CSSD1036_OLED::Render()
{
    assert(m_ImGui_context != nullptr);
    ImGui::SetCurrentContext(m_ImGui_context);

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
    ImDrawList* draw_list = ImGui::GetWindowDrawList();

    // Get the region boundaries.
    ImVec2 v_min = ImGui::GetWindowContentRegionMin();

    // Offset from the top of the window.
    static constexpr int OFFSET_Y = 50;

    // Move it relatively to the window position.
    v_min.x += ImGui::GetWindowPos().x;
    v_min.y += ImGui::GetWindowPos().y + OFFSET_Y;

    for (std::uint32_t i = 0; i < Height; ++i)
    {
        for (std::uint32_t j = 0; j < Width; ++j)
        {
            draw_list->AddRectFilled({ v_min.x, v_min.y }, { v_min.x + Pixel_Size, v_min.y + Pixel_Size }, ImColor(j % 2 == 0 ? Color_Pixel_OFF : Color_Pixel_ON));
            v_min.x += Pixel_Size;
        }

        v_min.y += Pixel_Size;
        v_min.x -= Width * Pixel_Size;
    }
}

void CSSD1036_OLED::GPIO_Subscription_Callback(std::uint32_t pin_idx)
{
    ++m_clock;

    const bool curr_pin_state = m_read_pin(pin_idx);

    if (pin_idx == m_sda_pin_idx)
    {
        SDA_Pin_Change_Callback(curr_pin_state);
    }
    else if (pin_idx == m_scl_pin_idx)
    {
        SCL_Pin_Change_Callback(curr_pin_state);
    }

    const bool stop_bit_detected = m_sda_rising_edge && m_scl_rising_edge &&
                                   (m_sda_rising_edge_timestamp - m_scl_rising_edge_timestamp) == 1 &&
                                   m_transaction.state == NState_Machine::Data;

    if (stop_bit_detected)
    {
        m_transaction.state = NState_Machine::Start_Bit;
        Received_Transaction_Callback();
    }
}

void CSSD1036_OLED::SCL_Pin_Change_Callback(bool curr_pin_state)
{
    m_scl_rising_edge = false;

    if (m_scl_prev_state && !curr_pin_state && m_transaction.state == NState_Machine::Start_Bit)
    {
        Update();
    }
    else if (!m_scl_prev_state && curr_pin_state)
    {
        m_scl_rising_edge = true;
        m_scl_rising_edge_timestamp = m_clock;

        Update();
    }

    m_scl_prev_state = curr_pin_state;
}

void CSSD1036_OLED::SDA_Pin_Change_Callback(bool curr_pin_state)
{
    m_sda_rising_edge = false;

    if (!m_sda_prev_state && curr_pin_state)
    {
        m_sda_rising_edge = true;
        m_sda_rising_edge_timestamp = m_clock;
    }

    m_sda_prev_state = curr_pin_state;
}

void CSSD1036_OLED::Update()
{
    switch (m_transaction.state)
    {
        case NState_Machine::Start_Bit:
            I2C_Receive_Start_Bit();
            break;

        case NState_Machine::Address:
            I2C_Receive_Address();
            break;

        case NState_Machine::RW:
            I2C_Receive_RW_Bit();
            break;

        case NState_Machine::ACK_1:
            m_transaction.state = NState_Machine::Data;
            break;

        case NState_Machine::Data:
            I2C_Receive_Data();
            break;

        case NState_Machine::ACK_2:
            m_transaction.data = 0;
            m_transaction.data_idx = Data_Length;
            m_transaction.state = NState_Machine::Data;
            break;
    }
}

void CSSD1036_OLED::Received_Transaction_Callback()
{
    std::stringstream ss{};

    ss << "Received data: ";

    for (const auto& value : m_fifo)
    {
        ss << static_cast<std::uint32_t>(value) << " ";
    }

    m_logging_system->Debug(ss.str().c_str());

    // TODO
    /*for (const auto& value : m_fifo)
    {
        Process_CMD(static_cast<NCMD>(value));
    }*/
}

void CSSD1036_OLED::Process_CMD(CSSD1036_OLED::NCMD cmd)
{
    switch (cmd)
    {
        case NCMD::Command_Start:
            [[fallthrough]];
        case NCMD::Data_Start:
        case NCMD::Data_Continue:
        case NCMD::Set_Contrast:
        case NCMD::Display_All_On_Resume:
        case NCMD::Display_All_On:
        case NCMD::Normal_Display:
        case NCMD::Inverted_Display:
        case NCMD::Display_Off:
        case NCMD::Display_On:
        case NCMD::Nop:
        case NCMD::Horizontal_Scroll_Right:
        case NCMD::Horizontal_Scroll_Left:
        case NCMD::Horizontal_Scroll_Vrt_Right:
        case NCMD::Horizontal_Scroll_Vrt_Left:
        case NCMD::Deactivate_Scroll:
        case NCMD::Activate_Scroll:
        case NCMD::Set_Vrt_Scroll_Area:
        case NCMD::Set_Upper_Column:
        case NCMD::Memory_Addr_Mode:
        case NCMD::Set_Column_Addr:
        case NCMD::Set_Page_Addr:
        case NCMD::Set_Segment_Remap:
        case NCMD::Set_Multiplex_Ratio:
        case NCMD::Com_Scan_Dir_Dec:
        case NCMD::Set_Display_Offset:
        case NCMD::Set_Com_Pins:
        case NCMD::Charge_Pump:
        case NCMD::Set_Display_Clock_Div_Ratio:
        case NCMD::Set_Precharge_Period:
        case NCMD::Set_VCOM_Detect:
            break;
    }
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

    if (m_read_pin(m_sda_pin_idx))
    {
        m_transaction.address |= (0b1U << m_transaction.addr_idx);
    }

    if (m_transaction.addr_idx == 0)
    {
        m_transaction.state = NState_Machine::RW;
    }
}

void CSSD1036_OLED::I2C_Receive_RW_Bit()
{
    m_transaction.read = m_read_pin(m_sda_pin_idx);
    Send_ACK();
    m_transaction.state = NState_Machine::ACK_1;
}

void CSSD1036_OLED::I2C_Receive_Data()
{
    --m_transaction.data_idx;

    if (m_read_pin(m_sda_pin_idx))
    {
        m_transaction.data |= (0b1U << m_transaction.data_idx);
    }

    if (m_transaction.data_idx == 0)
    {
        if (m_address == m_transaction.address)
        {
            m_fifo.push_back(m_transaction.data);
        }

        Send_ACK();
        m_transaction.state = NState_Machine::ACK_2;
    }
}

void CSSD1036_OLED::Send_ACK()
{
    const int status = m_set_pin(m_sda_pin_idx, false);

    if (status != 0)
    {
        m_logging_system->Error("Failed to set the value of the SDA pin (ACK)");
    }
}

extern "C"
{
    int Create_Peripheral(zero_mate::IExternal_Peripheral** peripheral,
                          const char* const name,
                          const std::uint32_t* const gpio_pins,
                          std::size_t pin_count,
                          zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                          zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                          zero_mate::utils::CLogging_System* logging_system)
    {
        if (pin_count != 3)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        // TODO change gpio_pins[2] to address
        // clang-format off
        *peripheral = new (std::nothrow) CSSD1036_OLED(name,
                                                       gpio_pins[2],
                                                       gpio_pins[1],
                                                       gpio_pins[0],
                                                       read_pin,
                                                       set_pin,
                                                       logging_system);
        // clang-format on

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}