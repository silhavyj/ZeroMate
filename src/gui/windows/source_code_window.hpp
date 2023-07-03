#pragma once

#include <unordered_map>

#include "../window.hpp"

#include "../../core/arm1176jzf_s/core.hpp"
#include "../../utils/elf_loader.hpp"

namespace zero_mate::gui
{
    class CSource_Code_Window final : public IGUI_Window
    {
    public:
        explicit CSource_Code_Window(
        std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
        std::unordered_map<std::string, std::vector<utils::elf::TText_Section_Record>>& source_codes,
        bool& scroll_to_curr_line,
        const bool& cpu_running);

        void Render() override;

    private:
        static constexpr ImGuiTableFlags Table_Flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        struct TRGB_Color
        {
            float r{};
            float g{};
            float b{};
        };

    private:
        void Render_Code_Block(const std::vector<utils::elf::TText_Section_Record>& source_code, std::size_t& idx);
        [[nodiscard]] bool Highlight_Code_Block(const std::vector<utils::elf::TText_Section_Record>& source_code,
                                                std::size_t idx) const;
        [[nodiscard]] static std::string Extract_Class_Name(std::string label);
        [[nodiscard]] static TRGB_Color Pick_Color(const std::string& str);

    private:
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        std::unordered_map<std::string, std::vector<utils::elf::TText_Section_Record>>& m_source_codes;
        std::unordered_map<std::uint32_t, bool> m_breakpoints;
        bool& m_scroll_to_curr_line;
        const bool& m_cpu_running;
        std::unordered_map<std::string, bool> m_open_tabs;
    };
}