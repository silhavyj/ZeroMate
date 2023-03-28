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
        void Debug(const char* msg, const std::source_location& location = std::source_location::current()) override;
        void Info(const char* msg, const std::source_location& location = std::source_location::current()) override;
        void Warning(const char* msg, const std::source_location& location = std::source_location::current()) override;
        void Error(const char* msg, const std::source_location& location = std::source_location::current()) override;

        void Render() override;

    private:
        static constexpr const char* const DEBUG_MSG_PREFIX = "[debug]";
        static constexpr const char* const INFO_MSG_PREFIX = "[info]";
        static constexpr const char* const WARNING_MSG_PREFIX = "[warning]";
        static constexpr const char* const ERROR_MSG_PREFIX = "[error]";

        void Clear();
        void Add_Log(const char* fmt, ...) IM_FMTARGS(2);
        void Set_Log_Message_Color(const std::string& message) const;

        ImGuiTextBuffer m_buffer;
        ImGuiTextFilter m_filter;
        ImVector<int> m_line_offsets;
        bool m_auto_scroll;
    };
}