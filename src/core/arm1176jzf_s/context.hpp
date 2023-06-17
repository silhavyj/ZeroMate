// ---------------------------------------------------------------------------------------------------------------------
/// \file context.hpp
/// \date 23. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the context (registers) of the CPU.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <cstdint>
#include <unordered_map>
/// \endcond

// Project file imports

#include "zero_mate/utils/logger.hpp"

namespace zero_mate::arm1176jzf_s
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCPU_Context
    /// \brief This class represents the context (registers) of the CPU.
    // -----------------------------------------------------------------------------------------------------------------
    class CCPU_Context final
    {
    public:
        /// Total number of CPU registers
        static constexpr std::size_t NUMBER_OF_REGS = 16;

        /// Number of general-purpose registers (LR, SP, PC are considered to be special registers)
        static constexpr std::size_t NUMBER_OF_GENERAL_REGS = 13;

        /// Register size (4B)
        static constexpr auto REG_SIZE = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        /// The least significant 5 bits in the CPS register represent the mode of the CPU
        static constexpr std::uint32_t CPU_MODE_MASK = 0b11111U;

        /// The lowest 8 bits of CPSR are called control bits
        static constexpr std::uint32_t CPU_CONTROL_BITS_MASK = 0xFFU;

        /// Index of the PC (program counter) register
        static constexpr std::size_t PC_REG_IDX = 15;

        /// Index of the LR (link register) register
        static constexpr std::size_t LR_REG_IDX = 14;

        /// Index of the SP (stack pointer) register
        static constexpr std::size_t SP_REG_IDX = 13;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NFlag
        /// \brief This enumeration lists out different flags in the CPSR register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NFlag : std::uint32_t
        {
            N = 0b1U << 31U, ///< Negative flag
            Z = 0b1U << 30U, ///< Zero flag
            C = 0b1U << 29U, ///< Carry flag
            V = 0b1U << 28U, ///< Overflow flag
            A = 0b1U << 8U,  ///< Imprecise abort (not used)
            I = 0b1U << 7U,  ///< Disable interrupts flag
            F = 0b1U << 6U   ///< Disable fast interrupts flag
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCPU_Mode
        /// \brief This enumeration represents different modes of the CPU.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCPU_Mode : std::uint32_t
        {
            User = 0b10000,       ///< User (normal program execution mode)
            FIQ = 0b10001,        ///< FIQ (supports a high-speed data transfer or channel process)
            IRQ = 0b10010,        ///< IRQ (used for general-purpose interrupt handling)
            Supervisor = 0b10011, ///< Supervisor (protected mode for the operating system)
            Abort = 0b10111,      ///< Abort (implements virtual memory and/or memory protection)
            Undefined = 0b11011,  ///< Undefined (supports software emulation of hardware coprocessors)
            System = 0b11111,     ///< System (runs privileged operating system tasks (ARMv4 and above))
        };

        /// Alias for the CPU banked registers (just to make the code less wordy)
        using Banked_Registers_t = std::unordered_map<NCPU_Mode, std::unordered_map<std::uint32_t, std::uint32_t>>;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CCPU_Context();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the context of the CPU.
        ///
        /// It sets all registers to 0, disables FIQ and RIQ, and sets the CPU mode to Supervisor.
        // -------------------------------------------------------------------------------------------------------------
        void Reset();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to a register of the current CPU mode.
        /// \param idx Index of the register to be returned (0 - 15)
        /// \return Const Reference to the register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::uint32_t& operator[](std::uint32_t idx) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to a register of the current CPU mode.
        /// \param idx Index of the register to be returned (0 - 15)
        /// \return Reference to the register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& operator[](std::uint32_t idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to a register of a particular CPU mode.
        /// \param idx Index of the register to be returned (0 - 15)
        /// \param mode Mode of the CPU used to retrieve the register
        /// \return Const reference to the register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::uint32_t& Get_Register(std::uint32_t idx, NCPU_Mode mode) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to a register of a particular CPU mode.
        /// \param idx Index of the register to be returned (0 - 15)
        /// \param mode Mode of the CPU used to retrieve the register
        /// \return Reference to the register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& Get_Register(std::uint32_t idx, NCPU_Mode mode);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference the CPSR register of the current CPU mode.
        /// \return Reference to the CPSR register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& Get_CPSR();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference the CPSR register of the current CPU mode.
        /// \return Const reference to the CPSR register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::uint32_t& Get_CPSR() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets a new value to the CPSR register.
        ///
        /// If the new value is supposed to change the current mode of the CPU, the function is only allowed to be
        /// called from a privileged mode. Otherwise, no effect will take place.
        ///
        /// \param value New value of the CPSR register.
        // -------------------------------------------------------------------------------------------------------------
        void Set_CPSR(std::uint32_t value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the value of the SPSR register of the current CPU mode.
        /// \throws exceptions::CReset if the CPU is in a mode where the SPSR register is not supported
        /// \return Value of the SPSR register of the current CPU mode
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_SPSR() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to the SPSR register of the CPU mode passed in as a parameter.
        /// \param mode Mode of the CPU
        /// \throws exceptions::CReset if the provided CPU does not support the SPSR register
        /// \return Reference to the SPSR register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& Get_SPSR(NCPU_Mode mode);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the SPSR register of the CPU mode passed in as a parameter.
        /// \param mode Mode of the CPU
        /// \throws exceptions::CReset if the provided CPU does not support the SPSR register
        /// \return Const reference to the SPSR register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::uint32_t& Get_SPSR(NCPU_Mode mode) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the value of the SPSR register in the CPU mode passed in as a parameter.
        /// \throws exceptions::CReset if the provided CPU does not support the SPSR register
        /// \param value New value of the SPSR register
        // -------------------------------------------------------------------------------------------------------------
        void Set_SPSR(std::uint32_t value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets/resets a flag in the CPSR register of the current CPU mode.
        /// \param flag Flag to be set/reset
        /// \param set Indication of whether the flag should be set to 1 (set) or 0
        // -------------------------------------------------------------------------------------------------------------
        void Set_Flag(NFlag flag, bool set) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets/resets a flag in the given value which is treated as if it was the CPSR register.
        /// \param cpsr Value to be treated as the CPSR register.
        /// \param flag Flag to be set/reset
        /// \param set Indication of whether the flag should be set to 1 (set) or 0
        // -------------------------------------------------------------------------------------------------------------
        static void Set_Flag(std::uint32_t& cpsr, NFlag flag, bool set) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a given flag is set in the CPSR register of the current CPU mode.
        /// \param flag Type of flag to be checked
        /// \return true, if the flag is set. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the mode of the CPU.
        /// \param mode New mode of the CPU
        // -------------------------------------------------------------------------------------------------------------
        void Set_CPU_Mode(NCPU_Mode mode) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the current mode of the CPU.
        /// \return Current mode of the CPU
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NCPU_Mode Get_CPU_Mode() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the CPU is in a privileged mode.
        ///
        /// Privileged modes are considered to all CPU modes except for the User mode.
        ///
        /// \return true, if the CPU is currently in a privileged mode. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_In_Privileged_Mode() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the CPU mode passed in as a parameter supports the SPSR register or not.
        ///
        /// The SPSR register is supported (is accessible) in all modes except for the User and System mode.
        ///
        /// \param mode CPU mode to be checked
        /// \return true, if the mode does support the SPSR register. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static bool Is_Mode_With_No_SPSR(NCPU_Mode mode) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Globally enables/disables IRQ (interrupts)
        /// \param enable Indication of whether interrupts should be enabled
        ///               (true means interrupts will be enabled)
        // -------------------------------------------------------------------------------------------------------------
        void Enable_IRQ(bool enable);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Globally enables/disables FIQ (fast interrupts)
        /// \param enable Indication of whether interrupts should be enabled
        ///               (true means fast interrupts will be enabled)
        // -------------------------------------------------------------------------------------------------------------
        void Enable_FIQ(bool enable);

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes (resets) all CPU registers.
        ///
        /// Registers r0-r15 in all CPU modes are set to 0. The CPSR registers of all modes hold only info about their
        /// corresponding mode (least significant 5 bits). The SPSR registers are cleared out to 0.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_Registers();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the banked registers of the FIQ mode to 0.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_FIQ_Banked_Regs();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the banked registers of the IRQ mode to 0.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_IRQ_Banked_Regs();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the banked registers of the Supervisor mode to 0.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_Supervisor_Banked_Regs();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the banked registers of the Undefined mode to 0.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_Undefined_Banked_Regs();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the banked registers of the Abort mode to 0.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_Abort_Banked_Regs();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the CPSR register in all CPU modes.
        ///
        /// The registers are reset to 0, except for their 5 least significant bits as they hold information about the
        /// mode itself.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CPSR();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets all SPSR registers (in all CPU modes) to 0.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_SPSR();

        // -------------------------------------------------------------------------------------------------------------
        /// Makes sure the SPSR register is accessible from the given mode of the CPU (helper function).
        /// \param mode CPU mode to be checked if it supports the SPSR register
        /// \throws exceptions::CReset if the mode does not support the SPSR register
        // -------------------------------------------------------------------------------------------------------------
        inline void Verify_SPSR_Accessibility(NCPU_Mode mode) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if a flag is set in the given value which is treated as the CPSR register.
        /// \param cpsr Value treated as the CPSR register
        /// \param flag Flag to be checked
        /// \return true, if the given flag is set (1). false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static bool Is_Flag_Set(std::uint32_t cpsr, NFlag flag) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the mode of the CPU from the value given as a parameter.
        /// \param cpsr Value to be treated as the CPSR register.
        /// \return Mode of the CPU retrieved from the given value
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static NCPU_Mode Get_CPU_Mode(std::uint32_t cpsr) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if there is an invalid attempt to change the control bits of the CPSR register.
        ///
        /// The control bits of the CPSR register can be changed only from a privileged mode. If the CPU is in the
        /// User mode, it is not allowed the change the least significant byte of CPSR (control bits).
        ///
        /// \param new_cpsr New value of the CPSR register
        /// \return true, if an invalid attempt takes place. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Invalid_Change_Of_Control_Bits(std::uint32_t new_cpsr) noexcept;

    private:
        NCPU_Mode m_mode;                                    ///< Current mode of the CPU
        std::array<std::uint32_t, NUMBER_OF_REGS> m_regs;    ///< USR and SYS mode registers
        Banked_Registers_t m_banked_regs;                    ///< Banked registers
        std::unordered_map<NCPU_Mode, std::uint32_t> m_spsr; ///< SPSR registers (for different CPU modes)
        std::unordered_map<NCPU_Mode, std::uint32_t> m_cpsr; ///< CPSR registers (for different CPU modes)
        utils::CLogging_System* m_logging_system;            ///< Logging system
    };

} // namespace zero_mate::arm1176jzf_s
