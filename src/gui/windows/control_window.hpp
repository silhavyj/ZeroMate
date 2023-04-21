#pragma once

#include <atomic>

#include "../window.hpp"

#include "../../core/utils/logger/logger.hpp"
#include "../../core/arm1176jzf_s/core.hpp"

namespace zero_mate::gui
{
    class CControl_Window final : public CGUI_Window
    {
    public:
        explicit CControl_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                 bool& scroll_to_curr_line,
                                 const bool& elf_file_has_been_loaded,
                                 bool& cpu_running);

        void Render() override;

    private:
        void Render_CPU_State() const;
        void Render_Control_Buttons();
        static void Render_ImGUI_Demo();
        void Print_No_ELF_File_Loaded_Error_Msg() const;
        void Run();

        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        bool& m_scroll_to_curr_line;
        const bool& m_elf_file_has_been_loaded;
        utils::CLogging_System& m_logging_system;
        bool& m_cpu_running;
        bool m_breakpoint_hit;
        std::atomic<bool> m_start_cpu_thread;
        std::atomic<bool> m_stop_cpu_thread;
    };
}