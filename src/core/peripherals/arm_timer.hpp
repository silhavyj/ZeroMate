#pragma once

#include <array>
#include <memory>

#include "peripheral.hpp"
#include "interrupt_controller.hpp"

namespace zero_mate::peripheral
{
    class CARM_Timer final : public IPeripheral
    {
    public:
        enum class NRegister : std::uint32_t
        {
            Load = 0,
            Value,
            Control,
            IRQ_Clear,
            IRQ_Raw,
            IRQ_Masked,
            Reload,
            Pre_Divider,
            Free_Running,
            Count
        };

        enum class NPrescal_Bits : std::uint32_t
        {
            Prescale_None = 0b00U,
            Prescale_16 = 0b01U,
            Prescale_256 = 0b10U,
            Prescale_1 = 0b11U
        };

#pragma pack(push, 1)

        struct TControl_Register
        {
            std::uint32_t Unused_0 : 1;
            std::uint32_t Counter_32b : 1;
            std::uint32_t Prescaler : 2;
            std::uint32_t Unused_1 : 1;
            std::uint32_t Interrupt_Enabled : 1;
            std::uint32_t Unused_2 : 1;
            std::uint32_t Timer_Enabled : 1;
            std::uint32_t Halt_In_Debug_Break : 1;
            std::uint32_t Free_Running : 1;
            std::uint32_t Unused_3 : 6;
            std::uint32_t Free_Running_Prescaler : 8;
            std::uint32_t Unused_4 : 8;
        };

#pragma pack(pop)

        static constexpr auto NUMBER_OF_REGISTERS = static_cast<std::uint32_t>(NRegister::Count);
        static constexpr auto REG_SIZE = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        explicit CARM_Timer(std::shared_ptr<CInterrupt_Controller> interrupt_controller);

        void Update(std::uint32_t cycles_passed);
        [[nodiscard]] std::uint32_t Get_Reg(NRegister reg) const;
        [[nodiscard]] std::uint32_t& Get_Reg(NRegister reg);
        [[nodiscard]] TControl_Register Get_Control_Reg() const;

        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

    private:
        class CPrescaler final
        {
        public:
            enum class NPrescal_Values : std::uint32_t
            {
                Prescale_16 = 16U,
                Prescale_256 = 256U,
            };

            CPrescaler();

            [[nodiscard]] std::uint32_t Prescale_Cycle_Passed(std::uint32_t cycles_passed) noexcept;
            void Set_Limit(NPrescal_Bits limit);

        private:
            [[nodiscard]] std::uint32_t Update_Counter(std::uint32_t limit_value);

            NPrescal_Bits m_limit;
            std::uint32_t m_counter;
        };

        inline void Clear_Basic_IRQ();
        inline void Timer_Has_Reached_Zero(const TControl_Register& control_reg);

        std::shared_ptr<CInterrupt_Controller> m_interrupt_controller;
        std::array<std::uint32_t, NUMBER_OF_REGISTERS> m_regs;
        CPrescaler m_prescaler;
    };
}