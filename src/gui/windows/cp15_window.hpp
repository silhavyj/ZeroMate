// ---------------------------------------------------------------------------------------------------------------------
/// \file cp15_window.hpp
/// \date 10. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that displays data (information) related to coprocessor 15.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <vector>
#include <utility>
/// \endcond

// Project file imports

#include "../window.hpp"
#include "../../core/coprocessors/cp15/cp15.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP15_Window
    /// \brief This class represents a window that displays information related to CP15 (coprocessor 15).
    // -----------------------------------------------------------------------------------------------------------------
    class CCP15_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cp15 Reference to coprocessor 15.
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP15_Window(std::shared_ptr<coprocessor::cp15::CCP15> cp15);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the window (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders tabs representing the primary registers of CP15.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Tab_Bar();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders registers that fall under primary register C1.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Primary_Register_C1();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders registers that fall under primary register C2.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Primary_Register_C2();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders registers that fall under primary register C3.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Primary_Register_C3();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders registers that fall under primary register C7.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Primary_Register_C7();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders registers that fall under primary register C8.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Primary_Register_C8();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a table (register values).
        /// \param title Title of the table
        /// \param data Data where each item represents a single row in the table (key, value)
        // -------------------------------------------------------------------------------------------------------------
        static inline void Render_Table(const char* title,
                                        const std::vector<std::pair<std::string, std::string>>& data);

    private:
        std::shared_ptr<coprocessor::cp15::CCP15> m_cp15; ///< Coprocessor 15
    };

} // namespace zero_mate::gui