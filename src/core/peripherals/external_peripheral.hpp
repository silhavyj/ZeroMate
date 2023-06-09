// ---------------------------------------------------------------------------------------------------------------------
/// \file external_peripheral.hpp
/// \date 09. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an interface for external peripheral that can been hooked up to the system (Rpi Zero).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
#include <memory>
#include <unordered_set>
/// \endcond

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class IExternal_Peripheral
    /// \brief This class represents an interface for external peripheral that are connected to GPIO pins.
    // -----------------------------------------------------------------------------------------------------------------
    class IExternal_Peripheral
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class (default non-parameterized constructor).
        // -------------------------------------------------------------------------------------------------------------
        IExternal_Peripheral() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~IExternal_Peripheral() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IExternal_Peripheral(const IExternal_Peripheral&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IExternal_Peripheral& operator=(const IExternal_Peripheral&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IExternal_Peripheral(IExternal_Peripheral&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IExternal_Peripheral& operator=(IExternal_Peripheral&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a collection of GPIO pins the peripheral subscribes to.
        ///
        /// The peripheral gets notified whenever the state of any of the listed pins changes.
        ///
        /// \return Collection of GPIO pins the peripheral subscribes to
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::unordered_set<std::uint32_t>& Get_GPIO_Subscription() const
        {
            return m_gpio_subscription;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Notifies the peripheral that the state of one of the pins it subscribes to has changed.
        /// \note The peripheral may choose not to subscribe to any GPIO pins (e.g. when it is an input peripheral)
        /// \param pin_idx Index of the GPIO pin whose state has been changed
        // -------------------------------------------------------------------------------------------------------------
        [[maybe_unused]] virtual void GPIO_Subscription_Callback([[maybe_unused]] std::uint32_t pin_idx)
        {
        }

    protected:
        std::unordered_set<std::uint32_t> m_gpio_subscription{}; ///< Collection of GPIO the peripheral subscribes to
    };

} // namespace zero_mate::peripheral