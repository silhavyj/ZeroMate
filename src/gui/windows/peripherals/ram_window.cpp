// ---------------------------------------------------------------------------------------------------------------------
/// \file ram_window.cpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that visualizes the contents of the RAM.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "ram_window.hpp"

namespace zero_mate::gui
{
    CRAM_Window::CRAM_Window(const std::shared_ptr<peripheral::CRAM> ram)
    : m_ram{ ram }
    {
    }

    void CRAM_Window::Render()
    {
        // Render the memory monitor.
        m_ram_editor.DrawWindow("RAM", m_ram->Get_Raw_Data(), m_ram->Get_Size());
    }

} // namespace zero_mate::gui