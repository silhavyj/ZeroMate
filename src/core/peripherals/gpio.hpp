#pragma once

#include <array>
#include <memory>
#include <limits>
#include <functional>

#include "peripheral.hpp"
#include "interrupt_controller.hpp"
#include "../utils/logger/logger.hpp"

namespace zero_mate::peripheral
{
    class CGPIO_Manager final : public IPeripheral
    {
    public:
        static constexpr auto REG_SIZE = static_cast<std::uint32_t>(sizeof(std::uint32_t));
        static constexpr std::size_t NUMBER_OF_GPIO_PINS = 54;
        static constexpr std::uint32_t NUMBER_OF_PINS_IN_REG = std::numeric_limits<std::uint32_t>::digits;

        class CPin final
        {
        public:
            enum class NFunction : std::uint32_t
            {
                Input = 0b000,
                Output = 0b001,
                Alt_0 = 0b100,
                Alt_1 = 0b101,
                Alt_2 = 0b110,
                Alt_3 = 0b111,
                Alt_4 = 0b011,
                Alt_5 = 0b010
            };

            enum class NState : std::uint8_t
            {
                Low = 0,
                High = 1
            };

            enum class NInterrupt_Type : std::uint8_t
            {
                Rising_Edge = 0,
                Falling_Edge = 1,
                Low = 2,
                High = 3,
                Undefined = 4
            };

            static constexpr std::size_t NUMBER_OF_INTERRUPT_TYPES = 4;
            using Interrupts_t = std::array<bool, NUMBER_OF_INTERRUPT_TYPES>;

            CPin();

            [[nodiscard]] bool Interrupt_Detected(NState new_state) const noexcept;

            [[nodiscard]] NState Get_State() const noexcept;
            void Set_State(NState state) noexcept;
            [[nodiscard]] NFunction Get_Function() const noexcept;
            void Set_Function(NFunction function) noexcept;
            void Enable_Interrupt_Type(NInterrupt_Type type);
            void Disable_Interrupt_Type(NInterrupt_Type type);
            [[nodiscard]] bool Is_Interrupt_Enabled(NInterrupt_Type type) const;
            [[nodiscard]] bool Has_Pending_IRQ() const noexcept;
            void Set_Pending_IRQ(bool set);

        private:
            NState m_state;
            NFunction m_function;
            Interrupts_t m_enabled_interrupts;
            bool m_pending_irq;
        };

        enum class NRegister : std::uint32_t
        {
            GPFSEL0 = 0,
            GPFSEL1,
            GPFSEL2,
            GPFSEL3,
            GPFSEL4,
            GPFSEL5,
            Reserved_01,
            GPSET0,
            GPSET1,
            Reserved_02,
            GPCLR0,
            GPCLR1,
            Reserved_03,
            GPLEV0,
            GPLEV1,
            Reserved_04,
            GPEDS0,
            GPEDS1,
            Reserved_05,
            GPREN0,
            GPREN1,
            Reserved_06,
            GPFEN0,
            GPFEN1,
            Reserved_07,
            GPHEN0,
            GPHEN1,
            Reserved_08,
            GPLEN0,
            GPLEN1,
            Reserved_09,
            GPAREN0,
            GPAREN1,
            Reserved_10,
            GPAFEN0,
            GPAFEN1,
            Reserved_11,
            GPPUD,
            GPPUDCLK0,
            GPPUDCLK1,
            Reserved_12,
            Test,
            Count
        };

        static constexpr auto NUMBER_OF_REGISTERS = static_cast<std::size_t>(NRegister::Count);

        enum class NPin_Set_Status
        {
            OK,
            Not_Input_Pin,
            State_Already_Set,
            Invalid_Pin_Number
        };

        explicit CGPIO_Manager(std::shared_ptr<CInterrupt_Controller> interrupt_controller) noexcept;

        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;
        [[nodiscard]] const CPin& Get_Pin(std::size_t idx) const;
        [[nodiscard]] NPin_Set_Status Set_Pin_State(std::size_t pin_idx, CPin::NState state);

    private:
        [[nodiscard]] static std::size_t Get_Register_Index(std::size_t& pin_idx, NRegister reg_0, NRegister reg_1) noexcept;

        void Update_Pin_Function(std::size_t reg_idx, bool last_reg);
        void Update_Pin_State(std::size_t reg_idx, CPin::NState state, bool last_reg);
        inline void Reflect_Pin_State_In_GPLEVn(std::size_t pin_idx, CPin::NState state);
        void Set_Interrupt(std::size_t reg_idx, bool last_reg, CPin::NInterrupt_Type type);
        void Clear_IRQ(std::size_t reg_idx, bool last_reg);

        std::array<std::uint32_t, NUMBER_OF_REGISTERS> m_regs;
        std::array<CPin, NUMBER_OF_GPIO_PINS> m_pins;
        utils::CLogging_System& m_logging_system;
        std::shared_ptr<CInterrupt_Controller> m_interrupt_controller;
    };
}