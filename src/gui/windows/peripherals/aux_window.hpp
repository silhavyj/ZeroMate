// ---------------------------------------------------------------------------------------------------------------------
/// \file aux_window.hpp
/// \date 26. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that visualizes the auxiliaries (UART1 & SPI1, and SPI2) used in BCM2835.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "../../window.hpp"
#include "../../../core/peripherals/auxiliary/auxiliary.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CAUX_Window
    /// \brief This class represents the windows that visualizes auxiliary peripherals.
    // -----------------------------------------------------------------------------------------------------------------
    class CAUX_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        /// \param aux Reference to the AUX peripheral (backend)
        // -------------------------------------------------------------------------------------------------------------
        explicit CAUX_Window(const std::shared_ptr<peripheral::CAUX>& aux);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders GPIO pins (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the ENABLES and IRQ register of the AUX peripheral.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_AUX();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders information related to the mini UART auxiliary peripheral.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Mini_UART();

    private:
        const std::shared_ptr<peripheral::CAUX>& m_aux; ///< AUX peripheral
    };

} // namespace zero_mate::gui