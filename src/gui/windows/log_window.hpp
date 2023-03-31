#pragma once

#include <imgui/imgui.h>

#include "../window.hpp"
#include "../../core/utils/logger/logger.hpp"

namespace zero_mate::gui
{
    class CLog_Window final : public utils::ILogger, public CGUI_Window
    {
    public:
        CLog_Window();

        void Print(const char* msg) override;
        void Debug(const char* msg) override;
        void Info(const char* msg) override;
        void Warning(const char* msg) override;
        void Error(const char* msg) override;

        void Render() override;

        void Clear();
        void Add_Log(const char* fmt, ...) IM_FMTARGS(2);
        static void Set_Log_Message_Color(const std::string& msg);

        ImGuiTextBuffer m_buffer;
        ImGuiTextFilter m_filter;
        ImVector<int> m_line_offsets;
        bool m_auto_scroll;
    };
}