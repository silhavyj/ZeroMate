// ---------------------------------------------------------------------------------------------------------------------
/// \file aux.cpp \date 24. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the auxiliaries (UART1 & SPI1, and SPI2) used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 2)
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <algorithm>
/// \endcond

// 3rd party libraries

#include "fmt/format.h"
#include "magic_enum.hpp"

// Project file imports

#include "auxiliary.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::peripheral
{
    // clang-format off
    // Read-only registers
    const std::unordered_set<CAUX::NRegister> CAUX::s_read_only_registers = {
        CAUX::NRegister::IRQ,
        CAUX::NRegister::MU_LSR,
        CAUX::NRegister::MU_MSR,
        CAUX::NRegister::MU_STAT
    };

    // Write-only registers
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
        // Reset all registers.
        std::fill(m_regs.begin(), m_regs.end(), 0);

        // Reset all auxiliaries (one by one)
        m_mini_UART->Reset();
    }

    std::uint32_t CAUX::Get_Size() const noexcept
    {
        return Number_Of_Registers * Reg_Size;
    }

    void CAUX::Write(std::uint32_t addr, const char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        // Make sure we are not writing into a read-only register.
        if (s_read_only_registers.contains(reg_type))
        {
            // clang-format off
            m_logging_system.Warning(fmt::format("The AUX {} register is read-only",
                                                 magic_enum::enum_name(reg_type)).c_str());
            // clang-format on

            return;
        }

        // Write data to the peripheral's registers.
        std::copy_n(data, size, &std::bit_cast<char*>(m_regs.data())[addr]);

        switch (reg_type)
        {
            // Enable AUX peripherals.
            case NRegister::ENABLES:
                m_mini_UART->Enable(Is_Enabled(NAUX_Peripheral::Mini_UART));
                break;

            // Mini UART IO (transmit/receive data)
            case NRegister::MU_IO:
                m_mini_UART->Set_Transmit_Shift_Reg(static_cast<std::uint8_t>(m_regs[reg_idx] & 0xFFU));
                break;

            // Mini UART IER (reset IRQ?)
            case NRegister::MU_IER:
                m_mini_UART->Clear_IRQ();
                break;

            default:
                break;
        }
    }

    void CAUX::Read(std::uint32_t addr, char* data, std::uint32_t size)
    {
        const std::size_t reg_idx = addr / Reg_Size;
        const auto reg_type = static_cast<NRegister>(reg_idx);

        // Make sure we are not reading from a write-only register.
        if (s_write_only_registers.contains(reg_type))
        {
            // clang-format off
            m_logging_system.Warning(fmt::format("The AUX {} register is write-only",
                                                 magic_enum::enum_name(reg_type)).c_str());
            // clang-format on

            return;
        }

        // Read data from the peripheral's registers.
        std::copy_n(&std::bit_cast<char*>(m_regs.data())[addr], size, data);

        // If we are reading from the Mini UART's IO register, clear data ready flag (it's just been read).
        if (reg_type == NRegister::MU_IO)
        {
            m_mini_UART->Clear_Data_Ready();
        }
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
        // Forward the CPU cycles to the Mini UART.
        m_mini_UART->Increment_Passed_Cycles(count);
    }

    const CMini_UART* const CAUX::Get_Mini_UART() const
    {
        return m_mini_UART.get();
    }

} // namespace zero_mate::peripheral