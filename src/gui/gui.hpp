// ---------------------------------------------------------------------------------------------------------------------
/// \file gui.hpp
/// \date 05. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the main GUI entry function that takes care of creating and rendering all windows.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::gui
{
    namespace config
    {
        /// Path to the font used by the application
        inline const char* const Font_Path = "fonts/Cousine-Regular.ttf";

        /// Path to the icons used in the GUI of the application
        inline const char* const Icons_Path = "icons/fa-solid-900.ttf";

        /// Path to the logo of the application
        inline const char* const Window_Icon_Path = "logos/logo.png";

    } // namespace config

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Main entry point of the GUI of the application.
    ///
    /// Its main purpose is to create and render the GUI of the application.
    ///
    /// \param argc Number of arguments passed into the function
    /// \param argv Arguments themselves
    /// \return Return code
    // -----------------------------------------------------------------------------------------------------------------
    int Main_GUI(int argc, const char* argv[]);

} // namespace zero_mate::gui