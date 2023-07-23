#include <algorithm>

#include "fmt/format.h"
#include "magic_enum.hpp"

#include "auxiliary.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::peripheral
{
    // clang-format off
    const std::unordered_set<CAUX::NRegister> CAUX::s_read_only_registers = {
        CAUX::NRegister::IRQ
    };

    const std::unordered_set<CAUX::NRegister> CAUX::s_write_only_registers = {
    };
    // clang-format on

    CAUX::CAUX(std::shared_ptr<CGPIO_Manager> gpio, std::shared_ptr<CInterrupt_Controller> ic)
    : m_regs{}
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_gpio{ gpio }
    , m_ic{ ic }
    , m_mini_UART{ std::make_unique<CMini_UART>(*this) }
    {
        Reset();
    }

    void CAUX::Reset() noexcept
    {
        std::fill(m_regs.begin(), m_regs.end(), 0);

        m_regs[static_cast<std::uint32_t>(CAUX::NRegister::MU_LSR)] |= (1U << 5U);
    }

    std::uint32_t CAUX::Get_Size() const noexcept
    {
        return Number_Of_Registers * Reg_Size;
    }

    void CAUX::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        // TODO make sure the register does exist (indexes are not continuous)
        if (s_read_only_registers.contains(reg_type))
        {
            // clang-format off
            m_logging_system.Warning(fmt::format("The AUX {} register is read-only",
                                                 magic_enum::enum_name(reg_type)).c_str());
            // clang-format on

            return;
        }

        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        switch (reg_type)
        {
            case NRegister::ENABLES:
                m_mini_UART->Enable(Is_Enabled(NAUX_Peripheral::Mini_UART));
                break;

            case NRegister::MU_IO:
                m_mini_UART->Set_Transmit_Shift_Reg(static_cast<std::uint8_t>(m_regs[reg_idx] & 0xFFU));
                break;

            default:
                break;
        }
    }

    void CAUX::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        if (s_write_only_registers.contains(reg_type))
        {
            // clang-format off
            m_logging_system.Warning(fmt::format("The AUX {} register is write-only",
                                                 magic_enum::enum_name(reg_type)).c_str());
            // clang-format on

            return;
        }

        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);
    }

    bool CAUX::Is_Enabled(zero_mate::peripheral::CAUX::NAUX_Peripheral peripheral) const
    {
        return static_cast<bool>(m_regs.at(static_cast<std::uint32_t>(NRegister::ENABLES)) &
                                 (1U << static_cast<std::uint32_t>(peripheral)));
    }

    bool CAUX::Has_Pending_IRQ(zero_mate::peripheral::CAUX::NAUX_Peripheral peripheral) const
    {
        return static_cast<bool>(m_regs.at(static_cast<std::uint32_t>(NRegister::IRQ)) &
                                 (1U << static_cast<std::uint32_t>(peripheral)));
    }

    void CAUX::Increment_Passed_Cycles(std::uint32_t count)
    {
        m_mini_UART->Increment_Passed_Cycles(count);
    }
}