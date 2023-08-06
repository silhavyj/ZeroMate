#include <algorithm>

#include "bsc.hpp"

namespace zero_mate::peripheral
{
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
                m_fifo.push(m_regs[reg_idx]);
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

    void CBSC::Increment_Passed_Cycles(std::uint32_t count)
    {
        m_cpu_cycles += count;
    }
}