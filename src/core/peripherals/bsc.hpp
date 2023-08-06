#pragma once

#include <array>
#include <queue>

#include "gpio.hpp"
#include "peripheral.hpp"
#include "system_clock_listener.hpp"

namespace zero_mate::peripheral
{
    class CBSC final : public IPeripheral, public ISystem_Clock_Listener
    {
    public:
        static constexpr std::uint32_t SDA_Pin_Idx = 2;
        static constexpr std::uint32_t SCL_Pin_Idx = 3;

        static constexpr std::uint32_t CPU_Cycles_Per_Update = 100;

        enum class NRegister : std::uint32_t
        {
            Control = 0,
            Status,
            Data_Length,
            Slave_Address,
            Data_FIFO,
            Clock_Div,
            Data_Delay,
            Clock_Stretch_Timeout,
            Count
        };

        enum class NControl_Flags : std::uint32_t
        {
            I2C_Enable = 0b1U << 15U,
            Start_Transfer = 0b1U << 7U,
            FIFO_Clear = 4U,
            Read_Transfer = 0b1U << 0U
        };

        enum class NStatus_Flags : std::uint32_t
        {
            Clock_Stretch_Timeout = 0b1U << 9U,
            ACK_Error = 0b1U << 8U,
            Transfer_Done = 0b1U << 1U
        };

        static constexpr auto Number_Of_Registers = static_cast<std::size_t>(NRegister::Count);
        static constexpr auto Reg_Size = static_cast<std::uint32_t>(sizeof(std::uint32_t));

    public:
        explicit CBSC(std::shared_ptr<CGPIO_Manager> gpio);

        void Reset() noexcept override;
        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

        void Increment_Passed_Cycles(std::uint32_t count) override;

    private:
        inline void Add_Data_To_FIFO();
        inline void Control_Reg_Callback();
        inline void Clear_FIFO();
        [[nodiscard]] inline bool Should_Transaction_Begin();
        [[nodiscard]] inline bool Should_FIFO_Be_Cleared();
        void Update();

    private:
        enum class NState_Machine : std::uint8_t
        {
            Start_Bit,
            Address,
            RW,
            Register,
            Data,
            Stop_Bit
        };

        struct TTransaction
        {
            NState_Machine state{ NState_Machine::Start_Bit };
            std::uint32_t address{ 0x0 };
            std::uint32_t length{ 0 };
            bool read{ false };
        };

    private:
        std::shared_ptr<CGPIO_Manager> m_gpio;
        std::array<std::uint32_t, Number_Of_Registers> m_regs;
        std::queue<std::uint8_t> m_fifo;
        std::uint32_t m_cpu_cycles;
        bool m_transaction_in_progress;
        TTransaction m_transaction;
    };
}