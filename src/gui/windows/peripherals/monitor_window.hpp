// ---------------------------------------------------------------------------------------------------------------------
/// \file monitor_window.hpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that visualizes the memory-mapped debug monitor.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
/// \endcond

// Project file imports

#include "../../window.hpp"
#include "../../../core/peripherals/monitor.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CMonitor_Window
    /// \brief This class represents a window that visualizes the memory-mapped debug monitor.
    // -----------------------------------------------------------------------------------------------------------------
    class CMonitor_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param monitor Reference to the debug monitor.
        // -------------------------------------------------------------------------------------------------------------
        explicit CMonitor_Window(const std::shared_ptr<peripheral::CMonitor>& monitor);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the debug memory-mapped monitor (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders general information about the monitor (width, height, ...)
        // -------------------------------------------------------------------------------------------------------------
        static inline void Render_Monitor_Info();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the contents of the memory-mapped debug monitor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Monitor();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Retrieves a junk of data from the monitor which represents the current row.
        /// \param line_no Line number (row)
        /// \return Data that into the requested memory region
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::string Get_Current_Row(std::size_t line_no);

    private:
        const std::shared_ptr<peripheral::CMonitor>& m_monitor; ///< Debug monitor
    };

} // namespace zero_mate::gui