#pragma once

#include <array>
#include <unordered_map>

#include "peripheral.hpp"
#include "../arm1176jzf_s/context.hpp"

namespace zero_mate::peripheral
{
    class CInterrupt_Controller final : public IPeripheral
    {
    public:
        static constexpr auto REG_SIZE = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        enum class NRegister : std::uint32_t
        {
            IRQ_Basic_Pending,
            IRQ_Pending_1,
            IRQ_Pending_2,

            FIQ_Control,

            Enable_IRQs_1,
            Enable_IRQs_2,
            Enable_Basic_IRQs,

            Disable_IRQs_1,
            Disable_IRQs_2,
            Disable_Basic_IRQs,

            Count
        };

        enum class NIRQ_Basic_Source : std::uint32_t
        {
            ARM_Timer = 0,
            ARM_Mailbox = 1,
            ARM_Doorbell_0 = 2,
            ARM_Doorbell_1 = 3,
            GPU_0_Halted = 4,
            GPU_1_Halted = 5,
            Illegal_Access_Type_1 = 6,
            Illegal_Access_Type_0 = 7,
        };

        enum class NIRQ_Source
        {
            AUX = 29,
            I2C_SPI_SLV = 43,
            PWA_0 = 45,
            PWA_1 = 45,
            SMI = 48,
            GPIO_0 = 49,
            GPIO_1 = 50,
            GPIO_2 = 51,
            GPIO_3 = 52,
            I2C = 53,
            SPI = 54,
            PCM = 55,
            UART = 57
        };

        static constexpr std::uint32_t FIRST_REG_OFFSET = 0x200;
        static constexpr auto NUMBER_OF_REGISTERS = static_cast<std::uint32_t>(NRegister::Count);

        struct TInterrupt_Info
        {
            bool enabled{ false };
            bool pending{ false };
        };

        explicit CInterrupt_Controller(const arm1176jzf_s::CCPU_Context& cpu_context);

        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

        void Signalize_IRQ(NIRQ_Source source);
        void Signalize_Basic_IRQ(NIRQ_Basic_Source source);
        [[nodiscard]] bool Is_IRQ_Pending() const noexcept;

    private:
        inline void Initialize();
        inline void Initialize_IRQ_Basic_Sources();
        inline void Initialize_IRQ_Sources();

        void Update_IRQ_Basic_Sources(NRegister reg, bool enable);
        void Update_IRQ_Sources(NRegister reg, bool enable);

        const arm1176jzf_s::CCPU_Context& m_cpu_context;
        std::array<std::uint32_t, NUMBER_OF_REGISTERS> m_regs;
        std::unordered_map<NIRQ_Basic_Source, TInterrupt_Info> m_irq_basic_sources;
        std::unordered_map<NIRQ_Source, TInterrupt_Info> m_irq_sources;
        bool m_is_irq_pending;
    };
}