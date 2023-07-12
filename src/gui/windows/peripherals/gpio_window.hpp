// ---------------------------------------------------------------------------------------------------------------------
/// \file gpio_window.hpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that visualizes the states and information about GPIO pins.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
/// \endcond

// Project file imports

#include "../../window.hpp"
#include "../../../core/peripherals/gpio.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CGPIO_Window
    /// \brief This class represents a windows that displays information about GPIO pins.
    // -----------------------------------------------------------------------------------------------------------------
    class CGPIO_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param gpio Reference to the GPIO manager
        // -------------------------------------------------------------------------------------------------------------
        explicit CGPIO_Window(const std::shared_ptr<peripheral::CGPIO_Manager> gpio);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders GPIO pins (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TInterrupt_Type
        /// \brief This structure encapsulates an interrupt type and its string representation (name)
        // -------------------------------------------------------------------------------------------------------------
        struct TInterrupt_Type
        {
            peripheral::CGPIO_Manager::CPin::NInterrupt_Type type; ///< Interrupt type
            std::string_view name;                                 ///< Interrupt name
        };

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a table with all GPIO pins.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_GPIO_Pins_Table();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders information about a single GPIO pin (table row).
        /// \param idx Index of the GPIO pin to be rendered.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_GPIO_Pin(std::size_t idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Converts an interrupt index into an enumeration along with its string representation.
        /// \param idx Interrupt index (type)
        /// \return Interrupt type as well as its name (string representation)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] TInterrupt_Type Get_Interrupt_Type_From_Idx(std::size_t idx);

    private:
        const std::shared_ptr<peripheral::CGPIO_Manager> m_gpio; ///< GPIO manager
    };

} // namespace zero_mate::gui