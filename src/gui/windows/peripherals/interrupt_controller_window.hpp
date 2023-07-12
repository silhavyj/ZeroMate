// ---------------------------------------------------------------------------------------------------------------------
/// \file interrupt_controller_window.hpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that visualizes the interrupt controller IC.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
/// \endcond

// Project file imports

#include "../../window.hpp"
#include "../../../core/peripherals/interrupt_controller.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CInterrupt_Controller_Window
    /// \brief This class defines a window that displays information about the interrupt controller.
    // -----------------------------------------------------------------------------------------------------------------
    class CInterrupt_Controller_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// Creates an instance of the class.
        /// \param interrupt_controller Referent to the interrupt controller (IC)
        // -------------------------------------------------------------------------------------------------------------
        explicit CInterrupt_Controller_Window(
        const std::shared_ptr<peripheral::CInterrupt_Controller> interrupt_controller);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the bar (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders information about a pending interrupt.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Pending_IRQ();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders information about IRQ sources.
        /// \tparam IRQ_Sources Type of an IRQ source (basic IRQ or IRQ)
        /// \param name Name of the collection of IRQ sources
        /// \param irq_sources Collection of IRQ sources
        // -------------------------------------------------------------------------------------------------------------
        template<typename IRQ_Sources>
        void Render_IRQ(const char* name, const IRQ_Sources& irq_sources);

    private:
        const std::shared_ptr<peripheral::CInterrupt_Controller> m_interrupt_controller; ///< Interrupt controller
    };

} // namespace zero_mate::gui