// ---------------------------------------------------------------------------------------------------------------------
/// \file button.hpp
/// \date 09. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an external button that can be hooked up to the system.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
/// \endcond

// Project file imports

#include "../gpio.hpp"
#include "../external_peripheral.hpp"
#include "../../utils/logger/logger.hpp"

namespace zero_mate::peripheral::external
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CButton
    /// \brief This class represents an external button
    // -----------------------------------------------------------------------------------------------------------------
    class CButton final : public IExternal_Peripheral
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of hte class
        /// \param gpio_manager Reference to a GPIO manager, so it can set the state of individual pins
        /// \param pin_idx Index of the GPIO the button is hooked up to
        // -------------------------------------------------------------------------------------------------------------
        explicit CButton(std::shared_ptr<CGPIO_Manager> gpio_manager, std::uint32_t pin_idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the GPIO pin the button is connected to.
        /// \return Index of the GPIO pin the button is connected to
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Pin_Idx() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Connects the button to a different GPIO pin.
        /// \param pin_idx Index of the GPIO pin the button will be connected to
        // -------------------------------------------------------------------------------------------------------------
        void Set_Pin_Idx(std::uint32_t pin_idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Presses/Release the button based on the stated passed in as a parameter.
        /// \param state Output state of the button
        // -------------------------------------------------------------------------------------------------------------
        void Set_Output(CGPIO_Manager::CPin::NState state);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Toggles the button.
        ///
        /// It sets the output to the opposite of whatever it is set now.
        // -------------------------------------------------------------------------------------------------------------
        void Toggle();

    private:
        std::shared_ptr<CGPIO_Manager> m_gpio_manager; ///< Reference to the GPIO manager
        std::uint32_t m_pin_idx;                       ///< Index of the GPIO pin the button is hooked up to
        CGPIO_Manager::CPin::NState m_state;           ///< Current state of the output of the button
        utils::CLogging_System& m_logging_system;      ///< Logging system
    };

} // namespace zero_mate::peripheral::external