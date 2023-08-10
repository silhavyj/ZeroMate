#include "ssd1306_oled.hpp"

CSSD1036_OLED::CSSD1036_OLED(const std::string& name,
                             std::uint32_t address,
                             std::uint32_t sda_pin_idx,
                             std::uint32_t scl_pin_idx,
                             zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                             zero_mate::IExternal_Peripheral::Set_GPIO_Pin_t set_pin)
: m_name{ std::move(name) }
, m_address{ address }
, m_sda_pin_idx{ sda_pin_idx }
, m_scl_pin_idx{ scl_pin_idx }
, m_read_pin{ read_pin }
, m_set_pin{ set_pin }
, m_transaction{}
{
    Init_GPIO_Subscription();
}

void CSSD1036_OLED::Init_GPIO_Subscription()
{
    m_gpio_subscription.insert(m_sda_pin_idx);
    m_gpio_subscription.insert(m_scl_pin_idx);
}

void CSSD1036_OLED::GPIO_Subscription_Callback(std::uint32_t pin_idx)
{
    if (pin_idx == m_scl_pin_idx && !m_read_pin(pin_idx))
    {
        Update();
    }
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
            break;

        case NState_Machine::Stop_Bit:
            break;
    }
}

void CSSD1036_OLED::I2C_Receive_Start_Bit()
{
    if (m_read_pin(m_sda_pin_idx))
    {
        m_transaction.state = NState_Machine::Address;
    }
}

void CSSD1036_OLED::I2C_Receive_Address()
{
    if (m_read_pin(m_sda_pin_idx))
    {
        m_transaction.address |= (0b1U << m_transaction.addr_idx);
    }

    if (m_transaction.addr_idx == 0)
    {
        // TODO check if the frame is meant to be for us

        m_transaction.state = NState_Machine::RW;
    }
    else
    {
        --m_transaction.addr_idx;
    }
}

void CSSD1036_OLED::I2C_Receive_RW_Bit()
{
    m_transaction.read = m_read_pin(m_sda_pin_idx);

    // TODO check the return value
    // ACK_1
    m_set_pin(m_sda_pin_idx, false);
}

void CSSD1036_OLED::I2C_Receive_Data()
{
    if (m_read_pin(m_sda_pin_idx))
    {
        m_transaction.data |= (0b1U << m_transaction.data_idx);
    }

    if (m_transaction.data_idx == 0)
    {
        m_transaction.state = NState_Machine::ACK_2;

        // TODO check the return value
        // ACK_2
        m_set_pin(m_sda_pin_idx, false);
    }
    else
    {
        --m_transaction.data_idx;
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
                          [[maybe_unused]] zero_mate::utils::CLogging_System* logging_system)
    {
        if (pin_count != 3)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::GPIO_Mismatch);
        }

        // TODO change gpio_pins[2] to address
        // clang-format off
        *peripheral = new (std::nothrow) CSSD1036_OLED(name,
                                                       gpio_pins[0],
                                                       gpio_pins[1],
                                                       gpio_pins[2],
                                                       read_pin,
                                                       set_pin);
        // clang-format on

        if (*peripheral == nullptr)
        {
            return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::Allocation_Error);
        }

        return static_cast<int>(zero_mate::IExternal_Peripheral::NInit_Status::OK);
    }
}