// ---------------------------------------------------------------------------------------------------------------------
/// \file gpio.hpp
/// \date 28. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the GPIO controller used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 6)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <memory>
#include <limits>
#include <functional>
#include <unordered_set>
/// \endcond

// Project file imports

#include "peripheral.hpp"
#include "interrupt_controller.hpp"
#include "zero_mate/utils/logger.hpp"

#include <zero_mate/external_peripheral.hpp>

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CGPIO_Manager
    /// \brief This class represents a GPIO (general-purpose I/O) manager.
    // -----------------------------------------------------------------------------------------------------------------
    class CGPIO_Manager final : public IPeripheral
    {
    public:
        /// Size of a single register
        static constexpr auto Reg_Size = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        /// Total number of GPIO pins
        static constexpr std::size_t Number_of_GPIO_Pins = 54;

        /// Number of pins encapsulated in a single register
        static constexpr std::uint32_t Number_Of_Pins_In_Reg = std::numeric_limits<std::uint32_t>::digits;

        // -------------------------------------------------------------------------------------------------------------
        /// \class CPin
        /// \brief This class represents a single pin.
        // -------------------------------------------------------------------------------------------------------------
        class CPin final
        {
        public:
            // ---------------------------------------------------------------------------------------------------------
            /// \enum NFunction
            /// \brief This enumeration defines different functions a pin can be assigned.
            // ---------------------------------------------------------------------------------------------------------
            enum class NFunction : std::uint32_t
            {
                Input = 0b000,  ///< Input pin
                Output = 0b001, ///< Output pin
                Alt_0 = 0b100,  ///< Alternative function 0
                Alt_1 = 0b101,  ///< Alternative function 1
                Alt_2 = 0b110,  ///< Alternative function 2
                Alt_3 = 0b111,  ///< Alternative function 3
                Alt_4 = 0b011,  ///< Alternative function 4
                Alt_5 = 0b010   ///< Alternative function 5
            };

            // ---------------------------------------------------------------------------------------------------------
            /// \enum NState
            /// \brief This enumeration defines states of a pin (only digital pins are supported).
            // ---------------------------------------------------------------------------------------------------------
            enum class NState : std::uint8_t
            {
                Low = 0, ///< Low voltage (0V)
                High = 1 ///< High voltage (+5V)
            };

            // ---------------------------------------------------------------------------------------------------------
            /// \enum NInterrupt_Type
            /// \brief This enumeration defines different interrupt types that can be assigned to a pin.
            // ---------------------------------------------------------------------------------------------------------
            enum class NInterrupt_Type : std::uint8_t
            {
                Rising_Edge = 0,  ///< Change from NState::Low to NState::High
                Falling_Edge = 1, ///< Change from NState::High to NState::Low
                Low = 2,          ///< NState::Low detected
                High = 3,         ///< NState::High detected
                Undefined = 4     ///< Undefined (helper enum record)
            };

            /// Total number of interrupt types
            /// TODO add count to NInterrupt_Type
            static constexpr std::size_t Number_Of_Interrupt_Types = 4;

            /// Alias for an array of interrupts (just to make the code less wordy)
            using Interrupts_t = std::array<bool, Number_Of_Interrupt_Types>;

        public:
            // ---------------------------------------------------------------------------------------------------------
            /// \brief Creates an instance of the class.
            ///
            /// The default state of the pin is set to NState::Low and its function is set to NFunction::Input.
            // ---------------------------------------------------------------------------------------------------------
            CPin();

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Checks information about whether an interrupt has occurred or not.
            /// \param new_state State the pin is transitioning into
            /// \return true, if the transition triggers an interrupt. false, otherwise.
            // ---------------------------------------------------------------------------------------------------------
            [[nodiscard]] bool Is_Interrupt_Detected(NState new_state) const noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Returns the current state of the pin.
            /// \return State of the pin
            // ---------------------------------------------------------------------------------------------------------
            [[nodiscard]] NState Get_State() const noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Sets the current state of the pin.
            /// \param state New state of the pin
            // ---------------------------------------------------------------------------------------------------------
            void Set_State(NState state) noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Returns the current function of the pin.
            /// \return Function of the pin
            // ---------------------------------------------------------------------------------------------------------
            [[nodiscard]] NFunction Get_Function() const noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Sets the current function of the pin.
            /// \param function New function of the pin
            // ---------------------------------------------------------------------------------------------------------
            void Set_Function(NFunction function) noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Enables an interrupt on the pin.
            /// \param type Interrupt type to be enabled
            // ---------------------------------------------------------------------------------------------------------
            void Enable_Interrupt_Type(NInterrupt_Type type);

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Disabled an interrupt on the pin.
            /// \param type Interrupt type to be disabled
            // ---------------------------------------------------------------------------------------------------------
            void Disable_Interrupt_Type(NInterrupt_Type type);

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Checks whether or not an interrupt is enabled on the pin.
            /// \param type Interrupt type to be checked
            /// \return true, if the given interrupt type is enabled. false, otherwise.
            // ---------------------------------------------------------------------------------------------------------
            [[nodiscard]] bool Is_Interrupt_Enabled(NInterrupt_Type type) const;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Checks if there is a pending interrupt on the pin.
            /// \return true, if there is a pending interrupt. false, otherwise.
            // ---------------------------------------------------------------------------------------------------------
            [[nodiscard]] bool Has_Pending_IRQ() const noexcept;

            // ---------------------------------------------------------------------------------------------------------
            /// \brief Sets a pending interrupt.
            ///
            /// This function is called from CGPIO_Manager when clearing interrupts as well as when setting
            /// a new state of the pin which triggers an interrupt.
            ///
            /// \param set New value of the pending interrupt on the pin
            // ---------------------------------------------------------------------------------------------------------
            void Set_Pending_IRQ(bool set);

        private:
            NState m_state;                    ///< Current state of the pin
            NFunction m_function;              ///< Function of the pin
            Interrupts_t m_enabled_interrupts; ///< Array or interrupts (which are enabled/disabled)
            bool m_pending_irq;                ///< Flag if there is a pending interrupt on the pin
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NRegister
        /// \brief Enumeration of different registers which are used to interact with the GPIO pins.
        // -------------------------------------------------------------------------------------------------------------
        enum class NRegister : std::uint32_t
        {
            GPFSEL0 = 0, ///< Function of GPIO pins 0-9 (3 bits per pin)
            GPFSEL1,     ///< Function of GPIO pins 10-19 (3 bits per pin)
            GPFSEL2,     ///< Function of GPIO pins 02-29 (3 bits per pin)
            GPFSEL3,     ///< Function of GPIO pins 30-39 (3 bits per pin)
            GPFSEL4,     ///< Function of GPIO pins 40-49 (3 bits per pin)
            GPFSEL5,     ///< Function of GPIO pins 50-23 (3 bits per pin)
            Reserved_01, ///< Reserved
            GPSET0,      ///< Sets the value of a GPIO pin (pins 0-31)
            GPSET1,      ///< Sets the value of a GPIO pin (pins 32-53)
            Reserved_02, ///< Reserved
            GPCLR0,      ///< Clears the value of a GPIO pin (pins 0-31)
            GPCLR1,      ///< Clears the value of a GPIO pin (pins 32-53)
            Reserved_03, ///< Reserved
            GPLEV0,      ///< Actual value of the pin (pins 0-31)
            GPLEV1,      ///< Actual value of the pin (pins 32-53)
            Reserved_04, ///< Reserved
            GPEDS0,      ///< GPIO Pin Event Detect Status 0 (pins 0-31)
            GPEDS1,      ///< GPIO Pin Event Detect Status 1 (pins 32-53)
            Reserved_05, ///< Reserved
            GPREN0,      ///< Enables/disables the rising edge interrupt for pins 0-31
            GPREN1,      ///< Enables/disables the rising edge interrupt for pins 32-53
            Reserved_06, ///< Reserved
            GPFEN0,      ///< Enables/disables the falling edge interrupt for pins 0-31
            GPFEN1,      ///< Enables/disables the falling edge interrupt for pins 32-53
            Reserved_07, ///< Reserved
            GPHEN0,      ///< Enables/disables the high value interrupt for pins 0-31
            GPHEN1,      ///< Enables/disables the high value interrupt for pins 32-53
            Reserved_08, ///< Reserved
            GPLEN0,      ///< Enables/disables the low value interrupt for pins 0-31
            GPLEN1,      ///< Enables/disables the low value interrupt for pins 32-53
            Reserved_09, ///< Reserved
            GPAREN0,     ///< Enables/disables the asynchronous rising edge interrupt for pins 0-31
            GPAREN1,     ///< Enables/disables the asynchronous rising edge interrupt for pins 32-53
            Reserved_10, ///< Reserved
            GPAFEN0,     ///< Enables/disables the asynchronous falling edge interrupt for pins 0-31
            GPAFEN1,     ///< Enables/disables the asynchronous falling edge interrupt for pins 32-53
            Reserved_11, ///< Reserved
            GPPUD,       ///< Pull-up/down register controls
            GPPUDCLK0,   ///< Pull-up/down clock register 0
            GPPUDCLK1,   ///< Pull-up/down clock register 1
            Reserved_12, ///< Reserved
            Test,        ///< Test
            Count        ///< Total number of registers (helper enum record)
        };

        /// Collection of read-only registers (access control)
        static const std::unordered_set<NRegister> s_read_only_registers;

        /// Collection of write-only registers (access control)
        static const std::unordered_set<NRegister> s_write_only_registers;

        /// Total number of GPIO registers
        static constexpr auto Number_Of_Registers = static_cast<std::size_t>(NRegister::Count);

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NPin_Set_Status
        /// \brief This enumeration defines return values when setting a new state of pin.
        // -------------------------------------------------------------------------------------------------------------
        enum class NPin_Set_Status
        {
            OK,                ///< The new state has been set successfully
            Not_Input_Pin,     ///< The function of the pin must be set to Input (TODO there might be exceptions?)
            State_Already_Set, ///< The pin is already in the desired state
            Invalid_Pin_Number ///< Invalid pin number (Rpi Zero has 54 GPIO pins)
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param interrupt_controller Reference to the interrupt controller, so it can notify it when an
        ///                             interrupt occurs
        // -------------------------------------------------------------------------------------------------------------
        explicit CGPIO_Manager(std::shared_ptr<CInterrupt_Controller> interrupt_controller) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets/re-initializes the GPIO manager (IPeripheral interface).
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

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Hooks up an external peripheral to the GPIO manager.
        /// \param peripheral Instance of an external peripheral
        // -------------------------------------------------------------------------------------------------------------
        void Add_External_Peripheral(IExternal_Peripheral* peripheral);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to a pin (visualization purposes).
        /// \param idx Index of the pin to be returned
        /// \return Const reference to a pin
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const CPin& Get_Pin(std::size_t idx) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the current state of a given pin.
        /// \param idx Index of the pin whose state will be returned
        /// \return Current state of the given pin
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CPin::NState Read_GPIO_Pin(std::size_t idx) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets a new state of a given pin.
        ///
        /// This function is called from the outer world.
        ///
        /// \param pin_idx Index of the pin whose state will be changed
        /// \param state New state of the pin
        /// \return Information about whether the state has been changed successfully or not
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NPin_Set_Status Set_Pin_State(std::size_t pin_idx, CPin::NState state);

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the register (out of the two alternatives) based on the pin index.
        ///
        /// If the index of the pin is greater than 31, the second register is returned and the index gets
        /// modified, so it is relative to the register.
        ///
        /// \param pin_idx Index of the pin
        /// \param reg_0 First register (e.g. GPSET0)
        /// \param reg_1 Second register (e.g. GPSET1)
        /// \return Index of the register to be used
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static std::size_t
        Get_Register_Index(std::size_t& pin_idx, NRegister reg_0, NRegister reg_1) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the function of all pins within a given register.
        /// \param reg_idx Index of an GPFSEL register
        /// \param last_reg Indication of whether it is the last register (not all bits are being used)
        // -------------------------------------------------------------------------------------------------------------
        void Update_Pin_Function(std::size_t reg_idx, bool last_reg);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates the state of all pins within a given register.
        /// \param reg_idx Index of an GPSET/GPCLR register
        /// \param state Indication of whether the state of the corresponding pins should be set to a 1 or 0
        /// \param last_reg Indication of whether it is the last register (not all bits are being used)
        // -------------------------------------------------------------------------------------------------------------
        void Update_Pin_State(std::size_t reg_idx, CPin::NState state, bool last_reg);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Mirrors the state of a given in in the GPLEV register.
        /// \param pin_idx Index of the pin
        /// \param state Current state of the pin
        // -------------------------------------------------------------------------------------------------------------
        inline void Mirror_Pin_State_In_GPLEVn(std::size_t pin_idx, CPin::NState state);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Enables/disables an interrupt for all pins within a given register
        ///
        /// If a bit is set to a 0, the interrupt type will be disabled. If a bit set to a 1, the interrupt type will
        /// be enabled.
        ///
        /// \param reg_idx Index of the register (GPREN, GPHEN, GPLEN, or GPFEN)
        /// \param last_reg Indication of whether it is the last register (not all bits are being used)
        /// \param type Type of the interrupt to be enabled/disabled
        // -------------------------------------------------------------------------------------------------------------
        void Set_Interrupt(std::size_t reg_idx, bool last_reg, CPin::NInterrupt_Type type);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears a pending interrupt by writing a 1 to the GPEDS register.
        /// \param reg_idx Index of the register to be used
        /// \param last_reg Indication of whether it is the last register (not all bits are being used)
        // -------------------------------------------------------------------------------------------------------------
        void Clear_IRQ(std::size_t reg_idx, bool last_reg);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Notifies external peripherals that subscribe to the given pin about the change of its state.
        /// \param pin_idx Index of the pin whose state has changed
        // -------------------------------------------------------------------------------------------------------------
        void Notify_External_Peripherals(std::uint32_t pin_idx);

    private:
        std::array<std::uint32_t, Number_Of_Registers> m_regs;         ///< GPIO registers
        std::array<CPin, Number_of_GPIO_Pins> m_pins;                  ///< GPIO pins
        utils::CLogging_System& m_logging_system;                      ///< Logging system
        std::shared_ptr<CInterrupt_Controller> m_interrupt_controller; ///< Interrupt controller
        std::vector<IExternal_Peripheral*> m_external_peripherals;     ///< Collection of external peripherals
    };

} // namespace zero_mate::peripheral