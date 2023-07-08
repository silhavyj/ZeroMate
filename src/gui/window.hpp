// ---------------------------------------------------------------------------------------------------------------------
/// \file window.hpp
/// \date 05. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an interface for all windows that will be rendered by the application.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
/// \endcond

// 3rd party library includes

#include "imgui/imgui.h"

namespace zero_mate
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class IGUI_Window
    /// \brief Common interface for all GUI windows.
    // -----------------------------------------------------------------------------------------------------------------
    class IGUI_Window
    {
    public:
        // clang-format off
        /// Flags defining the looks of all tables.
        static constexpr ImGuiTableFlags Table_Flags = ImGuiTableFlags_SizingFixedFit |
                                                       ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders |
                                                       ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable |
                                                       ImGuiTableFlags_Hideable;
        // clang-format on

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class (default non-parameterized constructor).
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~IGUI_Window() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window(const IGUI_Window&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window& operator=(const IGUI_Window&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window(IGUI_Window&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window& operator=(IGUI_Window&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the window.
        // -------------------------------------------------------------------------------------------------------------
        virtual void Render() = 0;
    };

} // namespace zero_mate