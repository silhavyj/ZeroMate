#pragma once

#include <array>

#include "peripheral.hpp"
#include "../utils/logger/logger.hpp"

namespace zero_mate::peripheral
{
    class CGPIO_Manager final : public IPeripheral
    {
    public:
        static constexpr std::size_t NUMBER_OF_REGISTERS = 34;
        static constexpr std::size_t NUMBER_OF_GPIO_PINS = 54;

        struct CPin final
        {
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
                Rising_Edge,
                Falling_Edge,
                Low,
                High
            };

            NState m_state{ NState::Low };
            NFunction m_function{ NFunction::Input };
        };

        enum class NRegister_Type : std::uint32_t
        {
            GPFSEL0 = 0,
            GPFSEL1 = 1,
            GPFSEL2 = 2,
            GPFSEL3 = 3,
            GPFSEL4 = 4,
            GPFSEL5 = 5,
            Reserved_01 = 6,
            GPSET0 = 7,
            GPSET1 = 8,
            Reserved_02 = 9,
            GPCLR0 = 10,
            GPCLR1 = 11,
            Reserved_03 = 12,
            GPLEV0 = 13,
            GPLEV1 = 14,
            Reserved_04 = 15,
            GPEDS0 = 16,
            GPEDS1 = 17,
            Reserved_05 = 16,
            GPREN0 = 17,
            GPREN1 = 18,
            Reserved_06 = 17,
            GPFEN0 = 18,
            GPFEN1 = 19,
            Reserved_07 = 20,
            GPHEN0 = 21,
            GPHEN1 = 22,
            Reserved_08 = 23,
            GPLEN0 = 24,
            GPLEN1 = 25,
            Reserved_09 = 26,
            GPAREN0 = 27,
            GPAREN1 = 28,
            Reserved_10 = 27,
            GPAFEN0 = 28,
            GPAFEN1 = 29,
            Reserved_11 = 30,
            GPPUD = 31,
            GPPUDCLK0 = 32,
            GPPUDCLK1 = 33
        };

        CGPIO_Manager() noexcept;

        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

    private:
        void Update_Pin_Function(std::size_t reg_idx, bool last_reg);
        void Update_Pin_State(std::size_t reg_idx, CPin::NState state, bool last_reg);

        std::array<std::uint32_t, NUMBER_OF_REGISTERS> m_regs;
        std::array<CPin, NUMBER_OF_GPIO_PINS> m_pins;
        utils::CLogging_System& m_logging_system;
    };
}