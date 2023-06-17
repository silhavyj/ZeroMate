#pragma once

#include <imgui/imgui.h>

#include "../window.hpp"

#include "../../core/arm1176jzf_s/core.hpp"

namespace zero_mate::gui
{
    class CRegisters_Window final : public IGUI_Window
    {
    public:
        explicit CRegisters_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu, const bool& cpu_running);

        void Render() override;

    private:
        enum class NFormat
        {
            HEX,
            U32,
            S32
        };

        void Render_Registers_Table(const char* const title, const char* const type, NFormat format, arm1176jzf_s::CCPU_Context::NCPU_Mode mode);
        void Render_Register_Tabs(arm1176jzf_s::CCPU_Context::NCPU_Mode mode);
        void Render_Flags();
        void Render_Value(std::uint32_t value, NFormat format);

    private:
        static constexpr ImGuiTableFlags Table_Flags = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders | ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable;

        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        arm1176jzf_s::CCPU_Context m_cpu_context;
        const bool& m_cpu_running;
    };
}