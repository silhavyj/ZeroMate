#pragma once

#include <unordered_map>

#include "../window.hpp"

#include "../../core/arm1176jzf_s/core.hpp"
#include "../../core/utils/elf_loader.hpp"

namespace zero_mate::gui
{
    class CSource_Code_Window final : public CGUI_Window
    {
    public:
        explicit CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     std::vector<utils::elf::TText_Section_Record>& source_code,
                                     bool& scroll_to_curr_line,
                                     const bool& cpu_running);

        void Render() override;

    private:
        static constexpr ImGuiTableFlags TABLE_FLAGS = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        std::vector<utils::elf::TText_Section_Record>& m_source_code;
        std::unordered_map<std::uint32_t, bool> m_breakpoints;
        bool& m_scroll_to_curr_line;
        const bool& m_cpu_running;
    };
}