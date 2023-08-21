// ---------------------------------------------------------------------------------------------------------------------
/// \file arm_timer.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the ARM timer used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 14)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <memory>
#include <unordered_set>
/// \endcond

// Project file imports

#include "peripheral.hpp"
#include "interrupt_controller.hpp"
#include "system_clock_listener.hpp"

#include "zero_mate/utils/logging_system.hpp"

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CARM_Timer
    /// \brief This class represents the ARM timer used in BCM2835.
    // -----------------------------------------------------------------------------------------------------------------
    class CARM_Timer final : public IPeripheral, public ISystem_Clock_Listener
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NRegister
        /// \brief Enumeration of different registers which are used to interact with the timer.
        // -------------------------------------------------------------------------------------------------------------
        enum class NRegister : std::uint32_t
        {
            Load = 0,     ///< The value the timer starts off at (it it loaded into the value register)
            Value,        ///< The current value of the timer (counts down to 0)
            Control,      ///< Control register (see CARM_Timer::TControl_Register)
            IRQ_Clear,    ///< Used to clear a pending IRQ (by writing a 1 to it)
            IRQ_Raw,      ///< When the times reaches zero, this register is set to a 1 regardless of the settings
            IRQ_Masked,   ///< If the timer interrupt is enabled, this register is set to a 1 whenever the timer hits 0
            Reload,       ///< Copy of the load register
            Pre_Divider,  ///< TODO not used?
            Free_Running, ///< Free running counter (how many times the timer has hit 0)
            Count         ///< Total number of register (helper enum record)
        };

        /// Collection of read-only registers (access control)
        static const std::unordered_set<NRegister> s_read_only_registers;

        /// Collection of write-only register (access control)
        static const std::unordered_set<NRegister> s_write_only_registers;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NPrescal_Bits
        /// \brief Different pre-scaler values that can be used to adjust the speed of the timer.
        ///
        /// The timer frequency is inherited from the main CPU clock.
        // -------------------------------------------------------------------------------------------------------------
        enum class NPrescal_Bits : std::uint32_t
        {
            Prescale_None = 0b00U, ///< No prescaler is present
            Prescale_16 = 0b01U,   ///< The CPU frequency is divided by 16
            Prescale_256 = 0b10U,  ///< The CPU frequency is divided by 256
            Prescale_1 = 0b11U     ///< The CPU frequency is divided by 1 (same as the CPU frequency)
        };

#pragma pack(push, 1) // so the compiler does not put any extra bits in between the struct members

        // -------------------------------------------------------------------------------------------------------------
        /// \struct TControl_Register
        /// \brief Bit layout of the control register.
        // -------------------------------------------------------------------------------------------------------------
        struct TControl_Register
        {
            std::uint32_t Unused_0 : 1;               ///< Unused
            std::uint32_t Counter_32b : 1;            ///< The timer either counts in 16-bit = 0 or 32-bit mode = 1
            std::uint32_t Prescaler : 2;              ///< Prescaler value (see CARM_Timer::NPrescal_Bits)
            std::uint32_t Unused_1 : 1;               ///< Unused
            std::uint32_t Interrupt_Enabled : 1;      ///< Enable/disable interrupts
            std::uint32_t Unused_2 : 1;               ///< Unused
            std::uint32_t Timer_Enabled : 1;          ///< Enable/disable the timer
            std::uint32_t Halt_In_Debug_Break : 1;    ///< // TODO have no clue as to what it does
            std::uint32_t Free_Running : 1;           ///< Enable free-running mode
            std::uint32_t Unused_3 : 6;               ///< Unused
            std::uint32_t Free_Running_Prescaler : 8; ///< // TODO have no clue as to what it does
            std::uint32_t Unused_4 : 8;               ///< Unused
        };

#pragma pack(pop)

        /// Total number of registers associated with the peripheral
        static constexpr auto Number_Of_Registers = static_cast<std::uint32_t>(NRegister::Count);

        /// Size of a single register
        static constexpr auto Reg_Size = static_cast<std::uint32_t>(sizeof(std::uint32_t));

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param interrupt_controller Reference to an interrupt controller, so it can notify it when an
        ///                             interrupt occurs.
        // -------------------------------------------------------------------------------------------------------------
        explicit CARM_Timer(std::shared_ptr<CInterrupt_Controller> interrupt_controller);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the timer (ISystem_Clock_Listener interface).
        /// \param count Number of CPU cycles it took to execute the last instruction
        // -------------------------------------------------------------------------------------------------------------
        void Increment_Passed_Cycles(std::uint32_t count) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the current content of a register.
        /// \param reg Type of register whose contents will be returned
        /// \return Content of the given register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Reg(NRegister reg) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to a given register.
        /// \param reg Type of register that will be returned to the caller
        /// \return Reference to the given register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& Get_Reg(NRegister reg);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the current content of the control register.
        /// \return Content of the control register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] TControl_Register Get_Control_Reg() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets/re-initializes the ARM timer (IPeripheral interface).
        // -------------------------------------------------------------------------------------------------------------
        void Reset() noexcept override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the size of the peripheral (IPeripheral interface).
        /// \return number of register * register size
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Writes data to the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) where the data will be written
        /// \param data Pointer to the data to be written to the peripheral
        /// \param size Size of the data to be written to the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads data from the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) from which the data will be read
        /// \param data Pointer to a buffer the data will be copied into
        /// \param size Size of the data to read from the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \class CPrescaler
        /// \brief This class represents a prescaler of the ARM timer.
        ///
        /// It works as wrapper counter around the number of cycles passed in whenever an instruction is executed.
        // -------------------------------------------------------------------------------------------------------------
        class CPrescaler final
        {
        public:
            // ---------------------------------------------------------------------------------------------------------
            /// \enum NPrescal_Values
            /// \brief This represents the threshold the total number of CPU cycles must reach so the counter is increm.
            // ---------------------------------------------------------------------------------------------------------
            enum class NPrescal_Values : std::uint32_t
            {
                Prescale_16 = 16U,   ///< 16 (the prescaler counts up to 16)
                Prescale_256 = 256U, ///< 256 (the prescaler counts up to 256)
            };

        public:
            // ---------------------------------------------------------------------------------------------------------
            /// \brief Creates an instance of the class.
            // ---------------------------------------------------------------------------------------------------------
            CPrescaler();

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Resets the prescaler.
            ///
            /// The default limit is set to NPrescal_Bits::Prescale_None.
            // ---------------------------------------------------------------------------------------------------------
            void Reset() noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Updates the prescaler.
            ///
            /// The prescaler adds this value to its own counter and checks whether the threshold has been reached.
            ///
            /// \param cycles_passed Number of CPU cycles it took to execute the last instruction
            /// \return Updated (prescaled) number CPU cycles it took to execute the last instruction
            // ---------------------------------------------------------------------------------------------------------
            std::uint32_t operator()(std::uint32_t cycles_passed) noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Sets a new limit of the prescaler.
            /// \param limit New prescaler value
            // ---------------------------------------------------------------------------------------------------------
            void Set_Limit(NPrescal_Bits limit);

        private:
            // ---------------------------------------------------------------------------------------------------------
            /// \brief Updates the internal prescaler counter (helper function).
            /// \param limit_value Threshold the internal counter counts up to
            /// \return Number of prescaled cycles
            // ---------------------------------------------------------------------------------------------------------
            [[nodiscard]] std::uint32_t Update_Counter(std::uint32_t limit_value);

        private:
            NPrescal_Bits m_limit;   ///< Prescaler settings
            std::uint32_t m_counter; ///< Internal counter to keep track of the number of CPU cycles
        };

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clear a pending interrupt (helper function).
        ///
        /// When a 1 is written to this register, it notifies the interrupt controller, so it does not keep on firing
        /// an IRQ exception. It also clears the following registers: IRQ_Clear, IRQ_Raw, IRQ_Masked.
        // -------------------------------------------------------------------------------------------------------------
        inline void Clear_Basic_IRQ();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief This procedure is called whenever the timer reaches 0 (helper function).
        ///
        /// It sets the value register to the value stored in the reload register, and sets IRQ_Raw to 1.
        /// If interrupts are enabled, it also stores a 1 into IRQ_Masked, and signalizes the interrupt controller.
        /// If the free-running if set to a 1, it increments the Free_Running register.
        ///
        /// \param control_reg Reference to the timer control register
        // -------------------------------------------------------------------------------------------------------------
        inline void Timer_Has_Reached_Zero(const TControl_Register& control_reg);

    private:
        std::shared_ptr<CInterrupt_Controller> m_interrupt_controller; ///< Interrupt controller
        std::array<std::uint32_t, Number_Of_Registers> m_regs;         ///< Timer registers
        CPrescaler m_prescaler;                                        ///< Prescaler
        utils::CLogging_System& m_logging_system;                      ///< Logging system
    };

} // namespace zero_mate::peripheral