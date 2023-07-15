// ---------------------------------------------------------------------------------------------------------------------
/// \file arm_timer_window.hpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that visualizes the contents of the ARM timer registers.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
#include <vector>
#include <utility>
/// \endcond

// Project file imports

#include "../../window.hpp"
#include "../../../core/peripherals/arm_timer.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CARM_Timer_Window
    /// \brief This windows visualizes the contents of the ARM timer registers.
    // -----------------------------------------------------------------------------------------------------------------
    class CARM_Timer_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        /// \param arm_timer Reference to the ARM timer
        // -------------------------------------------------------------------------------------------------------------
        explicit CARM_Timer_Window(const std::shared_ptr<peripheral::CARM_Timer>& arm_timer);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the ARM timer registers (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders ARM timer registers (value, load, etc.).
        // -------------------------------------------------------------------------------------------------------------
        void Render_Registers();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Render individual bits of the ARM timer control register.
        // -------------------------------------------------------------------------------------------------------------
        void Render_Control_Register();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a table (register values).
        /// \param title Title of the table
        /// \param data Data where each item represents a single row in the table (key, value)
        // -------------------------------------------------------------------------------------------------------------
        static inline void Render_Table(const char* title,
                                        const std::vector<std::pair<std::string, std::string>>& data);

    private:
        const std::shared_ptr<peripheral::CARM_Timer> m_arm_timer; ///< ARM timer
    };

} // namespace zero_mate::gui