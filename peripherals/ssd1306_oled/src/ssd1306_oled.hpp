#pragma once

#define ZERO_MATE_EXPORT
#include "zero_mate/external_peripheral.hpp"

class CSSD1036_OLED final : public zero_mate::IExternal_Peripheral
{
public:
    static constexpr std::uint8_t Slave_Addr_Length = 7;
    static constexpr std::uint8_t Data_Length = 8;

public:
    explicit CSSD1036_OLED(const std::string& name,
                           std::uint32_t address,
                           std::uint32_t sda_pin_idx,
                           std::uint32_t scl_pin_idx,
                           zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                           zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin);

    void GPIO_Subscription_Callback([[maybe_unused]] std::uint32_t pin_idx) override;

private:
    enum class NState_Machine : std::uint8_t
    {
        Start_Bit,
        Address,
        RW,
        ACK_1,
        Data,
        ACK_2,
        Stop_Bit
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
    inline void Init_GPIO_Subscription();
    inline void Update();
    inline void I2C_Receive_Start_Bit();
    inline void I2C_Receive_Address();
    inline void I2C_Receive_RW_Bit();
    inline void I2C_Receive_Data();

private:
    std::string m_name;
    std::uint32_t m_address;
    std::uint32_t m_sda_pin_idx;
    std::uint32_t m_scl_pin_idx;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t m_set_pin;
    TTransaction m_transaction;
};