#pragma once

#include <array>
#include <memory>
#include <unordered_set>

#include "gpio.hpp"
#include "mini_uart.hpp"
#include "peripheral.hpp"
#include "system_clock_listener.hpp"
#include "interrupt_controller.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::peripheral
{
    class CAUX final : public IPeripheral, public ISystem_Clock_Listener
    {
    public:
        friend class CMini_UART;

        enum class NAUX_Peripheral : std::uint32_t
        {
            Mini_UART = 0,
            SPI_1 = 1,
            SPI_2 = 2
        };

        enum class NRegister : std::uint32_t
        {
            IRQ = 0,
            ENABLES = 1,
            MU_IO = 16,
            MU_IER = 17,
            MU_IIR = 18,
            MU_LCR = 19,
            MU_MCR = 20,
            MU_LSR = 21,
            MU_MSR = 22,
            MU_SCRATCH = 23,
            MU_CNTL = 24,
            MU_STAT = 25,
            MU_BAUD = 26,
            // TODO Add SPI registers
            Count = 27
        };

        static constexpr auto Number_Of_Registers = static_cast<std::uint32_t>(NRegister::Count);
        static constexpr auto Reg_Size = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        static const std::unordered_set<NRegister> s_read_only_registers;
        static const std::unordered_set<NRegister> s_write_only_registers;

    public:
        CAUX(std::shared_ptr<CGPIO_Manager> gpio, std::shared_ptr<CInterrupt_Controller> ic);

        void Reset() noexcept override;
        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;
        void Increment_Passed_Cycles(std::uint32_t count) override;

        [[nodiscard]] bool Is_Enabled(NAUX_Peripheral peripheral) const;
        [[nodiscard]] bool Has_Pending_IRQ(NAUX_Peripheral peripheral) const;

    private:
        std::array<std::uint32_t, Number_Of_Registers> m_regs;
        utils::CLogging_System& m_logging_system;
        std::shared_ptr<CGPIO_Manager> m_gpio;
        std::shared_ptr<CInterrupt_Controller> m_ic;
        std::unique_ptr<CMini_UART> m_mini_UART;
    };
}