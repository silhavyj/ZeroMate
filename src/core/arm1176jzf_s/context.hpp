#pragma once

#include <array>
#include <cstdint>
#include <unordered_map>

namespace zero_mate::arm1176jzf_s
{
    class CCPU_Context final
    {
    public:
        static constexpr std::size_t NUMBER_OF_REGS = 16;
        static constexpr std::size_t NUMBER_OF_GENERAL_REGS = 13;
        static constexpr auto REG_SIZE = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        static constexpr std::size_t PC_REG_IDX = 15;
        static constexpr std::size_t LR_REG_IDX = 14;
        static constexpr std::size_t SP_REG_IDX = 13;

        enum class NFlag : std::uint32_t
        {
            N = 0b1U << 31U,
            Z = 0b1U << 30U,
            C = 0b1U << 29U,
            V = 0b1U << 28U
        };

        enum class NCPU_Mode : std::uint32_t
        {
            User = 0b10000,       // User - Normal program execution mode
            FIQ = 0b10001,        // FIQ - Supports a high-speed data transfer or channel process
            IRQ = 0b10010,        // IRQ - Used for general-purpose interrupt handling
            Supervisor = 0b10011, // Supervisor - A protected mode for the operating system
            Abort = 0b10111,      // Abort - Implements virtual memory and/or memory protection
            Undefined = 0b11011,  // Undefined - Supports software emulation of hardware coprocessors
            System = 0b11111,     // System - Runs privileged operating system tasks (ARMv4 and above)
        };

        static constexpr auto DEFAULT_CPU_MODE = NCPU_Mode::User;

        CCPU_Context();

        [[nodiscard]] const std::uint32_t& operator[](std::uint32_t idx) const;
        [[nodiscard]] std::uint32_t& operator[](std::uint32_t idx);

        void Set_Flag(NFlag flag, bool set) noexcept;
        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;
        void Set_CPU_Mode(NCPU_Mode mode) noexcept;
        [[nodiscard]] NCPU_Mode Get_CPU_Mode() const noexcept;

    private:
        inline void Init_FIQ_Banked_Regs();
        inline void Init_IRQ_Banked_Regs();
        inline void Init_Supervisor_Banked_Regs();
        inline void Init_Undefined_Banked_Regs();
        inline void Init_Abort_Banked_Regs();

        static void Set_Flag(std::uint32_t& cpsr, NFlag flag, bool set) noexcept;
        [[nodiscard]] static bool Is_Flag_Set(std::uint32_t cpsr, NFlag flag) noexcept;

        NCPU_Mode m_mode;
        std::array<std::uint32_t, NUMBER_OF_REGS> m_regs;
        std::unordered_map<NCPU_Mode, std::unordered_map<std::uint32_t, std::uint32_t>> m_banked_regs;
        std::unordered_map<NCPU_Mode, std::uint32_t> m_spsr;
        std::unordered_map<NCPU_Mode, std::uint32_t> m_cpsr;
    };
}