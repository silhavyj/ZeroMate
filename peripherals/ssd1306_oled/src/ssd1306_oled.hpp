#pragma once

#include <vector>

#include "imgui.h"

#define ZERO_MATE_EXPORT
#include "zero_mate/external_peripheral.hpp"

class CSSD1036_OLED final : public zero_mate::IExternal_Peripheral
{
public:
    static constexpr std::uint8_t Slave_Addr_Length = 7;
    static constexpr std::uint8_t Data_Length = 8;
    static constexpr std::uint32_t Width = 128;
    static constexpr std::uint32_t Height = 32;
    static constexpr std::uint32_t Pixel_Size = 2;

    static constexpr ImVec4 Color_Pixel_ON = { 0, 0, 255, 255 };
    static constexpr ImVec4 Color_Pixel_OFF = { 0, 0, 0, 255 };

public:
    explicit CSSD1036_OLED(const std::string& name,
                           std::uint32_t address,
                           std::uint32_t sda_pin_idx,
                           std::uint32_t scl_pin_idx,
                           zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                           zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin,
                           zero_mate::utils::CLogging_System* logging_system);

    void Render() override;
    void Set_ImGui_Context(void* context) override;

    void GPIO_Subscription_Callback([[maybe_unused]] std::uint32_t pin_idx) override;

private:
    enum class NState_Machine : std::uint8_t
    {
        Start_Bit,
        Address,
        RW,
        ACK_1,
        Data,
        ACK_2
    };

    enum class NCMD : std::uint8_t
    {
        Command_Start = 0x00,
        Data_Start = 0xC0,
        Data_Continue = 0x40,
        Set_Contrast = 0x81,
        Display_All_On_Resume = 0xA4,
        Display_All_On = 0xA5,
        Normal_Display = 0xA6,
        Inverted_Display = 0xA7,
        Display_Off = 0xAE,
        Display_On = 0xAF,
        Nop = 0xE3,
        Horizontal_Scroll_Right = 0x26,
        Horizontal_Scroll_Left = 0x27,
        Horizontal_Scroll_Vrt_Right = 0x29,
        Horizontal_Scroll_Vrt_Left = 0x2A,
        Deactivate_Scroll = 0x2E,
        Activate_Scroll = 0x2F,
        Set_Vrt_Scroll_Area = 0xA3,
        Set_Lower_Column = 0x00,
        Set_Upper_Column = 0x10,
        Memory_Addr_Mode = 0x20,
        Set_Column_Addr = 0x21,
        Set_Page_Addr = 0x22,
        Set_Start_Line = 0x40,
        Set_Segment_Remap = 0xA0,
        Set_Multiplex_Ratio = 0xA8,
        Com_Scan_Dir_Inc = 0xC0,
        Com_Scan_Dir_Dec = 0xC8,
        Set_Display_Offset = 0xD3,
        Set_Com_Pins = 0xDA,
        Charge_Pump = 0x8D,
        Set_Display_Clock_Div_Ratio = 0xD5,
        Set_Precharge_Period = 0xD9,
        Set_VCOM_Detect = 0xD8,
    };

    struct TTransaction
    {
        NState_Machine state{ NState_Machine::Start_Bit };
        std::uint32_t address{ 0x0 };
        std::uint8_t data{ 0 };
        std::uint8_t addr_idx{ Slave_Addr_Length };
        std::uint8_t data_idx{ Data_Length };
        bool read{ false };
    };

private:
    inline void Render_Information() const;
    inline void Render_Display();

    inline void Init_GPIO_Subscription();
    inline void Update();
    inline void I2C_Receive_Start_Bit();
    inline void I2C_Receive_Address();
    inline void I2C_Receive_RW_Bit();
    inline void I2C_Receive_Data();
    inline void SCL_Pin_Change_Callback(bool curr_pin_state);
    inline void SDA_Pin_Change_Callback(bool curr_pin_state);
    inline void Received_Transaction_Callback();
    inline void Init_Transaction();
    inline void Send_ACK();
    inline void Process_CMD(NCMD cmd);

private:
    std::string m_name;
    std::uint32_t m_address;
    std::uint32_t m_sda_pin_idx;
    std::uint32_t m_scl_pin_idx;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin;
    TTransaction m_transaction;
    std::vector<std::uint8_t> m_fifo;
    std::uint32_t m_clock;
    std::uint32_t m_sda_rising_edge_timestamp;
    std::uint32_t m_scl_rising_edge_timestamp;
    bool m_sda_prev_state;
    bool m_scl_prev_state;
    bool m_sda_rising_edge;
    bool m_scl_rising_edge;
    zero_mate::utils::CLogging_System* m_logging_system;
    ImGuiContext* m_ImGui_context;
    bool m_display_on;
};