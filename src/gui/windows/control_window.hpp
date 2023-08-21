// ---------------------------------------------------------------------------------------------------------------------
/// \file control_window.hpp
/// \date 10. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a window that allows the user to control CPU execution.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <atomic>
#include <vector>
#include <memory>
/// \endcond

// Project file imports

#include "../window.hpp"
#include "zero_mate/utils/logging_system.hpp"
#include "../../core/arm1176jzf_s/core.hpp"
#include "../../core/peripherals/peripheral.hpp"

namespace zero_mate::gui
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CControl_Window
    /// \brief This class represents a window that allows the user to control CPU execution.
    // -----------------------------------------------------------------------------------------------------------------
    class CControl_Window final : public IGUI_Window
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu Reference to the CPU (stepping through the code)
        /// \param scroll_to_curr_line Flag indicating the the GUI should scroll to the current line of execution
        /// \param elf_file_has_been_loaded Flag indicating that an ELF kernel file has been loaded
        /// \param cpu_running Flag indicating that the CPU is running
        /// \param kernel_filename Name of the currently loaded kernel (ELF file)
        // -------------------------------------------------------------------------------------------------------------
        explicit CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                 bool& scroll_to_curr_line,
                                 const bool& elf_file_has_been_loaded,
                                 bool& cpu_running,
                                 const std::string& kernel_filename);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deletes the object from memory.
        ///
        /// Before the object gets deleted, it waits for the CPU execution thread to finish.
        // -------------------------------------------------------------------------------------------------------------
        ~CControl_Window() override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the window (IGUI_Window interface).
        // -------------------------------------------------------------------------------------------------------------
        void Render() override;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Runs CPU execution (separate thread).
        // -------------------------------------------------------------------------------------------------------------
        void Run();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the current CPU state (running, breakpoint, ...)
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_CPU_State() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the control button (step, stop, run)
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Control_Buttons();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Log an error message saying that no ELF file (kernel) has been loaded yet.
        // -------------------------------------------------------------------------------------------------------------
        inline void Print_No_ELF_File_Loaded_Error_Msg() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Starts CPU execution as a separate thread.
        // -------------------------------------------------------------------------------------------------------------
        inline void Start_CPU_Thread();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the step control button.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Step_Button();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the stop control button.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Stop_Button();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the run control button.
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Run_Button();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the name (filepath) of the currently loaded kernel (ELF file).
        // -------------------------------------------------------------------------------------------------------------
        inline void Render_Currently_Loaded_Kernel();

    private:
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu; ///< CPU
        bool& m_scroll_to_curr_line;                    ///< Should the GUI scroll to the current line of execution?
        const bool& m_elf_file_has_been_loaded;         ///< Has a kernel been loaded?
        utils::CLogging_System& m_logging_system;       ///< Logging system
        bool& m_cpu_running;                            ///< Is the CPU running?
        bool m_breakpoint_hit;                          ///< Has CPU execution hit a breakpoint?
        std::atomic<bool> m_start_cpu_thread;           ///< Flag indicating that CPU execution should be started
        std::atomic<bool> m_stop_cpu_thread;            ///< Flag indicating that CPU execution should be stopped
        const std::string& m_kernel_filename;           ///< Name (filepath) of the currently loaded kernel
    };

} // namespace zero_mate::gui