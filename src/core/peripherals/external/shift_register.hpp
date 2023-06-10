// ---------------------------------------------------------------------------------------------------------------------
/// \file shift_register.hpp
/// \date 09. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a shift register that is located on the KIV-DPP-01 external board.
///
/// To find more information about how it is connected, please visit
/// https://home.zcu.cz/~ublm/files/os/kiv-dpp-01-en.pdf.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <numeric>
/// \endcond

// Project file imports

#include "../gpio.hpp"
#include "../external_peripheral.hpp"

namespace zero_mate::peripheral::external
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CShift_Register
    /// \brief This class represents a shift register (external peripheral)
    /// \tparam Register Underlining data type (width) of the register
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Register = std::uint8_t>
    class CShift_Register final : public IExternal_Peripheral
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param gpio_manager Reference to a GPIO manager, so it can read/set the state of individual pins
        /// \param data_pin_idx Index of the data pin of the shift register
        /// \param clock_pin_idx Index of the clock pin of the shift register
        /// \param latch_pin_idx Index of the latch pin (output enabled)
        // -------------------------------------------------------------------------------------------------------------
        explicit CShift_Register(std::shared_ptr<CGPIO_Manager> gpio_manager,
                                 std::uint32_t latch_pin_idx,
                                 std::uint32_t data_pin_idx,
                                 std::uint32_t clock_pin_idx)
        : m_gpio_manager{ gpio_manager }
        , m_last_input_value{ 0 }
        , m_value{ 0 }
        , m_output_value{ 0 }
        , m_latch_pin_idx{ latch_pin_idx }
        , m_data_pin_idx{ data_pin_idx }
        , m_clock_pin_idx{ clock_pin_idx }
        , m_clock_state{ 0 }
        , m_clock_state_prev{ 0 }
        {
            // Subscribe to the GPIO pins.
            Init_GPIO_Subscription();
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Notifies the peripheral that the state of one of the pins it subscribes to has changed.
        ///
        /// This function is part of the implementation of the the IExternal_Peripheral interface.
        ///
        /// \param pin_idx Index of the GPIO pin whose state has been changed
        // -------------------------------------------------------------------------------------------------------------
        void GPIO_Subscription_Callback(std::uint32_t pin_idx) override
        {
            // Simplification of an if-else statement - only one function will be fully executed.
            // The remaining two function will bail as the index does not match the expected pin.
            Handle_Clock_Signal(pin_idx);
            Handle_Data_Signal(pin_idx);
            Handle_Latch_Signal(pin_idx);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the GPIO the latch pin is connected to.
        /// \return Index of the GPIO pin the latch pin is connected to.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Latch_Pin_Idx() const
        {
            return m_latch_pin_idx;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the GPIO the data pin is connected to.
        /// \return Index of the GPIO pin the data pin is connected to.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Data_Pin_Idx() const
        {
            return m_data_pin_idx;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the GPIO the clock pin is connected to.
        /// \return Index of the GPIO pin the clock pin is connected to.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Clock_Pin_Idx() const
        {
            return m_clock_pin_idx;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Hooks up the data pin to a different GPIO pin.
        /// \param data_pin_idx Index of the GPIO the data pin will be connected to
        // -------------------------------------------------------------------------------------------------------------
        void Set_Data_Pin_idx(std::uint32_t data_pin_idx)
        {
            m_data_pin_idx = data_pin_idx;
            Init_GPIO_Subscription();
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Hooks up the clock pin to a different GPIO pin.
        /// \param data_pin_idx Index of the GPIO the clock pin will be connected to
        // -------------------------------------------------------------------------------------------------------------
        void Set_Clock_Pin_Idx(std::uint32_t clock_pin_idx)
        {
            m_clock_pin_idx = clock_pin_idx;
            Init_GPIO_Subscription();
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Hooks up the latch pin to a different GPIO pin.
        /// \param data_pin_idx Index of the GPIO the latch pin will be connected to
        // -------------------------------------------------------------------------------------------------------------
        void Set_Latch_Pin_Idx(std::uint32_t latch_pin_idx)
        {
            m_latch_pin_idx = latch_pin_idx;
            Init_GPIO_Subscription();
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the current output value of the shift register.
        /// \return Shift register output value
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] Register Get_Value() const noexcept
        {
            return m_output_value;
        }

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes GPIO pin subscription.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_GPIO_Subscription()
        {
            // Clear the collection (re-initialization).
            m_gpio_subscription.clear();

            // Subscribe (listen) to the following pins.
            m_gpio_subscription.insert(m_data_pin_idx);
            m_gpio_subscription.insert(m_clock_pin_idx);
            m_gpio_subscription.insert(m_latch_pin_idx);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Handles the change of the state of the clock pin.
        /// \param pin_idx Index of the GPIO pin whose state has changed
        // -------------------------------------------------------------------------------------------------------------
        inline void Handle_Clock_Signal(std::uint32_t pin_idx)
        {
            // Make sure the pin index is the clock pin.
            if (pin_idx != m_clock_pin_idx)
            {
                return;
            }

            // Read the value of the GPIO clock pin.
            m_clock_state = m_gpio_manager->Read_GPIO_Pin(m_clock_pin_idx);

            // Check if the clock signal has gone from High to Low.
            if (m_clock_state_prev == CGPIO_Manager::CPin::NState::High &&
                m_clock_state == CGPIO_Manager::CPin::NState::Low)
            {
                // Shift the register one bit to the right.
                m_value >>= 1;

                // Add the input bit to the far right.
                m_value |= static_cast<Register>((m_last_input_value << (std::numeric_limits<Register>::digits - 1)));

                // Clear the input of the shift register.
                m_last_input_value = 0;
            }

            // Update the previous state of the pin.
            m_clock_state_prev = m_clock_state;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Handles the change of the state of the latch pin.
        /// \param pin_idx Index of the GPIO pin whose state has changed
        // -------------------------------------------------------------------------------------------------------------
        inline void Handle_Latch_Signal(std::uint32_t pin_idx)
        {
            // Make sure the pin index is the latch pin.
            if (pin_idx != m_latch_pin_idx)
            {
                return;
            }

            // Read the value of the GPIO latch pin.
            if (m_gpio_manager->Read_GPIO_Pin(m_latch_pin_idx) == CGPIO_Manager::CPin::NState::High)
            {
                // Propagate the value to the output of the register.
                m_output_value = m_value;
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Handles the change of the state of the data pin.
        /// \param pin_idx Index of the GPIO pin whose state has changed
        // -------------------------------------------------------------------------------------------------------------
        inline void Handle_Data_Signal(std::uint32_t pin_idx)
        {
            // Make sure the pin index is the data pin.
            if (pin_idx != m_data_pin_idx)
            {
                return;
            }

            // Read the state of the GPIO data pin and store it as the last input value to the shift register.
            const auto data_pin_value = m_gpio_manager->Read_GPIO_Pin(m_data_pin_idx);
            m_last_input_value = static_cast<std::uint32_t>(data_pin_value);
        }

    private:
        std::shared_ptr<CGPIO_Manager> m_gpio_manager;  ///< GPIO manager
        std::uint32_t m_last_input_value;               ///< Last input value
        Register m_value;                               ///< Current value of the shift register
        Register m_output_value;                        ///< Output value of the shift register (latch is enabled)
        std::uint32_t m_latch_pin_idx;                  ///< Index of the GPIO latch pin
        std::uint32_t m_data_pin_idx;                   ///< Index of the GPIO data pin
        std::uint32_t m_clock_pin_idx;                  ///< Index of the GPIO clock pin
        CGPIO_Manager::CPin::NState m_clock_state;      ///< State of the clock pin
        CGPIO_Manager::CPin::NState m_clock_state_prev; ///< Previous state of the clock pin
    };

} // namespace zero_mate::peripheral::external