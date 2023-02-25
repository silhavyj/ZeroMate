#pragma once

#include <cstdint>

namespace zero_mate::cpu
{
    class CCSPR final
    {
    public:
        static constexpr std::uint32_t N_BIT_IDX = 31U;
        static constexpr std::uint32_t Z_BIT_IDX = 30U;
        static constexpr std::uint32_t C_BIT_IDX = 29U;
        static constexpr std::uint32_t V_BIT_IDX = 28U;

        enum class NCPU_Mode : std::uint32_t
        {
            USR = 0b10000, // User - Normal program execution mode
            FIQ = 0b10001, // FIQ - Supports a high-speed data transfer or channel process
            IRQ = 0b10010, // IRQ - Used for general-purpose interrupt handling
            SVC = 0b10011, // Supervisor - A protected mode for the operating system
            ABT = 0b10111, // Abort - Implements virtual memory and/or memory protection
            UND = 0b11011, // Undefined - Supports software emulation of hardware coprocessors
            SYS = 0b11111  // System - Runs privileged operating system tasks (ARMv4 and above)
        };

        enum class NFlag
        {
            N, // Negative result from ALU
            Z, // Zero result from ALU
            C, // ALU operation carried out
            V  // ALU operation overflowed
        };

    private:
        static constexpr std::uint32_t CPU_MODE_MASK = 0b11111U;

    public:
        explicit CCSPR(uint32_t value) noexcept;

        void Set_Flag(NFlag flag, bool set) noexcept;
        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;
        void Set_CPU_Mode(NCPU_Mode mode) noexcept;
        [[nodiscard]] NCPU_Mode Get_CPU_Mode() const noexcept;

    private:
        std::uint32_t m_value;
    };
}