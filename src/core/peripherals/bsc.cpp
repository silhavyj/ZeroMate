#include <algorithm>

#include "bsc.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::peripheral
{
    CBSC::CBSC(std::shared_ptr<CGPIO_Manager> gpio)
    : m_gpio{ gpio }
    , m_cpu_cycles{ 0 }
    , m_transaction_in_progress{ false }
    , m_transaction{}
    , m_SCL_state{ NSCL_State::SDA_Change }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
    }

    void CBSC::Reset() noexcept
    {
        std::fill(m_regs.begin(), m_regs.end(), 0);
    }

    std::uint32_t CBSC::Get_Size() const noexcept
    {
        return static_cast<std::uint32_t>(sizeof(m_regs));
    }

    void CBSC::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        switch (reg_type)
        {
            case NRegister::Data_FIFO:
                Add_Data_To_FIFO();
                break;

            case NRegister::Control:
                Control_Reg_Callback();
                break;

            case NRegister::Status:
                [[fallthrough]];
            case NRegister::Data_Length:
            case NRegister::Slave_Address:
            case NRegister::Clock_Div:
            case NRegister::Data_Delay:
            case NRegister::Clock_Stretch_Timeout:
            case NRegister::Count:
                break;
        }
    }

    void CBSC::Control_Reg_Callback()
    {
        if (Should_FIFO_Be_Cleared())
        {
            Clear_FIFO();
        }

        if (Should_Transaction_Begin())
        {
            m_transaction.state = NState_Machine::Start_Bit;
            m_transaction.address = m_regs[static_cast<std::uint32_t>(NRegister::Slave_Address)];
            m_transaction.addr_idx = Slave_Addr_Length;
            m_transaction.data_idx = Data_Length;
            m_transaction.length = m_regs[static_cast<std::uint32_t>(NRegister::Data_Length)];
            m_transaction.read = static_cast<bool>(m_regs[static_cast<std::uint32_t>(NRegister::Control)] &
                                                   static_cast<std::uint32_t>(NControl_Flags::Read_Transfer));

            m_regs[static_cast<std::uint32_t>(NRegister::Status)] &=
            ~static_cast<std::uint32_t>(NStatus_Flags::Transfer_Done);

            Set_GPIO_pin(SDA_Pin_Idx, true);
            Set_GPIO_pin(SCL_Pin_Idx, true);

            m_cpu_cycles = 0;
            m_transaction_in_progress = true;
        }
    }

    void CBSC::Clear_FIFO()
    {
        while (!m_fifo.empty())
        {
            m_fifo.pop();
        }
    }

    bool CBSC::Should_FIFO_Be_Cleared()
    {
        // clang-format off
        return (m_regs[static_cast<std::uint32_t>(NRegister::Control)] >>
               static_cast<std::uint32_t>(NControl_Flags::FIFO_Clear) & 0b11U) != 0;
        // clang-format on
    }

    void CBSC::Add_Data_To_FIFO()
    {
        m_fifo.push(static_cast<std::uint8_t>(m_regs[static_cast<std::uint32_t>(NRegister::Data_FIFO)]));
    }

    bool CBSC::Should_Transaction_Begin()
    {
        const auto i2c_enabled = static_cast<bool>(m_regs[static_cast<std::uint32_t>(NRegister::Control)] &
                                                   static_cast<std::uint32_t>(NControl_Flags::I2C_Enable));

        const auto start_transfer = static_cast<bool>(m_regs[static_cast<std::uint32_t>(NRegister::Control)] &
                                                      static_cast<std::uint32_t>(NControl_Flags::Start_Transfer));

        return i2c_enabled && start_transfer;
    }

    void CBSC::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        switch (reg_type)
        {
            case NRegister::Data_FIFO:
                m_regs[static_cast<std::uint32_t>(NRegister::Data_FIFO)] = m_fifo.front();
                m_fifo.pop();
                break;

            case NRegister::Control:
                [[fallthrough]];
            case NRegister::Status:
            case NRegister::Data_Length:
            case NRegister::Slave_Address:
            case NRegister::Clock_Div:
            case NRegister::Data_Delay:
            case NRegister::Clock_Stretch_Timeout:
            case NRegister::Count:
                break;
        }

        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);
    }

    void CBSC::Update()
    {
        switch (m_transaction.state)
        {
            case NState_Machine::Start_Bit:
                I2C_Send_Start_Bit();
                break;

            case NState_Machine::Address:
                I2C_Send_Slave_Address();
                break;

            case NState_Machine::RW:
                I2C_Send_RW_Bit();
                break;

            case NState_Machine::ACK_1:
                I2C_Receive_ACK_1();
                break;

            case NState_Machine::Data:
                I2C_Send_Data();
                break;

            case NState_Machine::ACK_2:
                I2C_Receive_ACK_2();
                break;

            case NState_Machine::Stop_Bit:
                I2C_Send_Stop_Bit();
                break;
        }
    }

    void CBSC::I2C_Send_Start_Bit()
    {
        Set_GPIO_pin(SDA_Pin_Idx, false);
        m_transaction.state = NState_Machine::Address;
    }

    void CBSC::I2C_Send_Slave_Address()
    {
        --m_transaction.addr_idx;
        const auto curr_bit = static_cast<bool>((m_transaction.address >> m_transaction.addr_idx) & 0b1U);

        Set_GPIO_pin(SDA_Pin_Idx, curr_bit);

        if (m_transaction.addr_idx == 0)
        {
            m_transaction.state = NState_Machine::RW;
        }
    }

    void CBSC::I2C_Send_RW_Bit()
    {
        Set_GPIO_pin(SDA_Pin_Idx, m_transaction.read);
        m_transaction.state = NState_Machine::ACK_1;
    }

    void CBSC::I2C_Receive_ACK_1()
    {
        if (m_gpio->Read_GPIO_Pin(SDA_Pin_Idx) != CGPIO_Manager::CPin::NState::Low)
        {
            m_logging_system.Error("Failed to receive ACK_1");
        }

        m_transaction.state = NState_Machine::Data;
    }

    void CBSC::I2C_Send_Data()
    {
        bool curr_bit{ false };
        --m_transaction.data_idx;

        if (m_fifo.empty())
        {
            m_logging_system.Error("There is no data in the FIFO to transmit");
        }
        else
        {
            curr_bit = static_cast<bool>(static_cast<std::uint8_t>(m_fifo.front() >> m_transaction.data_idx) & 0b1U);
        }

        Set_GPIO_pin(SDA_Pin_Idx, curr_bit);

        if (m_transaction.data_idx == 0)
        {
            if (!m_fifo.empty())
            {
                m_fifo.pop();
            }

            m_transaction.state = NState_Machine::ACK_2;
        }
    }

    void CBSC::I2C_Receive_ACK_2()
    {
        if (m_gpio->Read_GPIO_Pin(SDA_Pin_Idx) != CGPIO_Manager::CPin::NState::Low)
        {
            m_logging_system.Error("Failed to receive ACK_2");
        }

        --m_transaction.length;

        if (m_transaction.length != 0)
        {
            m_transaction.state = NState_Machine::Data;
            m_transaction.data_idx = Data_Length;
        }
        else
        {
            m_transaction.state = NState_Machine::Stop_Bit;
        }
    }

    void CBSC::I2C_Send_Stop_Bit()
    {
        Set_GPIO_pin(SCL_Pin_Idx, true);
        Terminate_Transaction();
    }

    void CBSC::Increment_Passed_Cycles(std::uint32_t count)
    {
        if (!m_transaction_in_progress)
        {
            return;
        }

        m_cpu_cycles += count;

        if (m_cpu_cycles < (CPU_Cycles_Per_Update / 3))
        {
            return;
        }

        m_cpu_cycles = 0;

        switch (m_SCL_state)
        {
            case NSCL_State::SDA_Change:
                Update();
                m_SCL_state = NSCL_State::SCL_High;
                break;

            case NSCL_State::SCL_High:
                Set_GPIO_pin(SCL_Pin_Idx, true);
                m_SCL_state = NSCL_State::SCL_Low;
                break;

            case NSCL_State::SCL_Low:
                Set_GPIO_pin(SCL_Pin_Idx, false);
                m_SCL_state = NSCL_State::SDA_Change;
                break;
        }
    }

    void CBSC::Terminate_Transaction()
    {
        m_transaction_in_progress = false;

        m_SCL_state = NSCL_State::SDA_Change;
        Set_GPIO_pin(SDA_Pin_Idx, true);

        m_regs[static_cast<std::uint32_t>(NRegister::Status)] |=
        static_cast<std::uint32_t>(NStatus_Flags::Transfer_Done);

        m_regs[static_cast<std::uint32_t>(NRegister::Control)] &=
        ~static_cast<std::uint32_t>(NControl_Flags::Start_Transfer);

        m_regs[static_cast<std::uint32_t>(NRegister::Control)] &=
        ~(0b11U << static_cast<std::uint32_t>(NControl_Flags::FIFO_Clear));
    }

    void CBSC::Set_GPIO_pin(std::uint8_t pin_idx, bool set)
    {
        const auto status = m_gpio->Set_Pin_State(pin_idx, static_cast<CGPIO_Manager::CPin::NState>(set));

        switch (status)
        {
            case CGPIO_Manager::NPin_Set_Status::OK:
                break;

            case CGPIO_Manager::NPin_Set_Status::Invalid_Pin_Function:
                m_logging_system.Error("Invalid function of pin");
                break;

            case CGPIO_Manager::NPin_Set_Status::Invalid_Pin_Number:
                m_logging_system.Error("Invalid pin number");
                break;
        }
    }
}