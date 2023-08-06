#include <algorithm>

#include "bsc.hpp"

namespace zero_mate::peripheral
{
    CBSC::CBSC(std::shared_ptr<CGPIO_Manager> gpio)
    : m_gpio{ gpio }
    , m_cpu_cycles{ 0 }
    , m_transaction_in_progress{ false }
    , m_transaction{}
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
            m_transaction.length = m_regs[static_cast<std::uint32_t>(NRegister::Data_Length)];
            m_transaction.read = static_cast<bool>(m_regs[static_cast<std::uint32_t>(NRegister::Control)] &
                                                   static_cast<std::uint32_t>(NControl_Flags::Read_Transfer));

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
        return m_regs[static_cast<std::uint32_t>(NRegister::Control)] >>
               static_cast<std::uint32_t>(NControl_Flags::FIFO_Clear) != 0;
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
                // TODO create callback functions
                m_gpio->Set_Pin_State(SDA_Pin_Idx, CGPIO_Manager::CPin::NState::Low);
                m_transaction.state = NState_Machine::Address;
                break;

            case NState_Machine::Address:
                break;

            case NState_Machine::RW:
                break;

            case NState_Machine::Register:
                break;

            case NState_Machine::Data:
                break;

            case NState_Machine::Stop_Bit:
                break;
        }
    }

    void CBSC::Increment_Passed_Cycles(std::uint32_t count)
    {
        static bool s_pulse_delay{ false };

        if (!m_transaction_in_progress)
        {
            return;
        }

        m_cpu_cycles += count;

        if (m_cpu_cycles < CPU_Cycles_Per_Update)
        {
            return;
        }

        if (!s_pulse_delay)
        {
            Update();
            // TODO create a helper function to handle the return value.
            m_gpio->Set_Pin_State(SCL_Pin_Idx, CGPIO_Manager::CPin::NState::Low);
            s_pulse_delay = true;
        }
        else
        {
            m_gpio->Set_Pin_State(SCL_Pin_Idx, CGPIO_Manager::CPin::NState::High);
            s_pulse_delay = false;
        }

        m_cpu_cycles = 0;
    }
}