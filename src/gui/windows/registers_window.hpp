// ---------------------------------------------------------------------------------------------------------------------
/// \file registers_window.hpp
/// \date 05. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that displays the contents of all CPU registers.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "../window.hpp"
#include "../../core/arm1176jzf_s/core.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CRegisters_Window
    /// \brief This class represents the window that displays the contents of all CPU registers.
    // -----------------------------------------------------------------------------------------------------------------
    class CRegisters_Window final : public IGUI_Window
    {
    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TCPU_Mode_Tab_States
        /// \brief Structure containing information about what tab (CPU mode) is currently selected.
        // -------------------------------------------------------------------------------------------------------------
        struct TCPU_Mode_Tab_States
        {
            ImGuiTableFlags USR_SYS_tab_open; ///< USR mode (tab)
            ImGuiTableFlags FIQ_tab_open;     ///< FIQ mode (tab)
            ImGuiTableFlags SVC_tab_open;     ///< SVC mode (tab)
            ImGuiTableFlags ABT_tab_open;     ///< ABT mode (tab)
            ImGuiTableFlags IRQ_tab_open;     ///< IRQ mode (tab)
            ImGuiTableFlags UND_tab_open;     ///< UND mode (tab)
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu Reference to the CPU whose registers' contents will be visualized
        // -------------------------------------------------------------------------------------------------------------
        explicit CRegisters_Window(const std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the windows (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NFormat
        /// \brief Enumeration of different formats values can be displayed.
        // -------------------------------------------------------------------------------------------------------------
        enum class NFormat
        {
            HEX, ///< Hexadecimal values
            U32, ///< Unsigned 32 bits
            S32  ///< Signed 32 bits
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the CPU mode has changed.
        ///
        /// If it has, it selects the corresponding tab to view the banked registers of the current CPU mode.
        ///
        /// \param cpu_context CPU context
        // -------------------------------------------------------------------------------------------------------------
        void Check_If_CPU_Mode_Changes(const arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a label displaying the current CPU mode.
        /// \param cpu_context CPU context
        // -------------------------------------------------------------------------------------------------------------
        void Render_CPU_Mode(const arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders tabs for different CPU modes (SVC, IRQ, FIQ, etc.)
        /// \param cpu_context CPU context
        // -------------------------------------------------------------------------------------------------------------
        void Render_Register_Modes_Tabs(const arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders table with CPU registers of a given CPU mode.
        /// \param title Unique title (identifier) of the table
        /// \param format Format in which numbers will be printed (HEX, DEC, ...)
        /// \param mode Mode of the CPU
        /// \param cpu_context CPU context
        // -------------------------------------------------------------------------------------------------------------
        void Render_Registers_Table(const char* const title,
                                    NFormat format,
                                    arm1176jzf_s::CCPU_Context::NCPU_Mode mode,
                                    const arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders different format tabs of a given CPU mode.
        /// \param mode Mode of the CPU
        /// \param context CPU context
        // -------------------------------------------------------------------------------------------------------------
        void Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode mode,
                                  const arm1176jzf_s::CCPU_Context& context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders flags of the CPSR register.
        /// \param cpu_context  CPU context
        // -------------------------------------------------------------------------------------------------------------
        void Render_CPSR_Flags(const arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders a raw integer value in a given format.
        /// \param value Value to be rendered
        /// \param format Format of the number (HEX, DEC, ...)
        // -------------------------------------------------------------------------------------------------------------
        void Render_Raw_Value(std::uint32_t value, NFormat format);

    private:
        const std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;  /// Reference to the CPU
        TCPU_Mode_Tab_States m_tab_states;                     ///< States of CPU modes (tabs)
        arm1176jzf_s::CCPU_Context::NCPU_Mode m_cpu_mode_prev; ///< Previous CPU mode
    };

} // namespace zero_mate::gui