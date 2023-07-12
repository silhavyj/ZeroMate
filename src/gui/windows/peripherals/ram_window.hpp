// ---------------------------------------------------------------------------------------------------------------------
/// \file ram_window.hpp
/// \date 12. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that visualizes the contents of the RAM.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// 3rd party libraries

#include "imgui/imgui.h"
#include "imgui_memory_editor/imgui_memory_editor.h"

// Project file includes

#include "../../window.hpp"
#include "../../../core/peripherals/ram.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CRAM_Window
    /// \brief This class represents a windows that visualizes the contents of the RAM.
    // -----------------------------------------------------------------------------------------------------------------
    class CRAM_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param ram Referent to the RAM
        // -------------------------------------------------------------------------------------------------------------
        explicit CRAM_Window(const std::shared_ptr<peripheral::CRAM> ram);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the memory editor (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        const std::shared_ptr<peripheral::CRAM> m_ram; ///< RAM
        MemoryEditor m_ram_editor;                     ///< Memory editor
    };

} // namespace zero_mate::gui