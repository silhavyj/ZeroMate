#pragma once

#include <mutex>
#include <vector>

#include <imgui/imgui.h>

#include "../window.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::gui
{
    template<typename Type, std::size_t Size>
    class CCircular_Log_Buffer final
    {
    public:
        CCircular_Log_Buffer() = default;

        void Add(Type value)
        {
            if (m_data.size() >= Size)
            {
                m_data.erase(m_data.begin());
            }

            m_data.push_back(value);
        }

        void Clear()
        {
            m_data.clear();
        }

        [[nodiscard]] const auto& Get_Data() const
        {
            return m_data;
        }

    private:
        std::vector<Type> m_data;
    };

    class CLog_Window final : public utils::ILogger, public IGUI_Window
    {
    public:
        static constexpr std::size_t Max_Logs = 80;

        CLog_Window();

        void Print(const char* msg) override;
        void Debug(const char* msg) override;
        void Info(const char* msg) override;
        void Warning(const char* msg) override;
        void Error(const char* msg) override;

        void Render() override;

        void Clear();

    private:
        static void Set_Log_Message_Color(const std::string& msg);
        void Render_Filtered_Log_Messages();
        void Render_All_Log_Messages();

    private:
        ImGuiTextFilter m_filter;
        bool m_auto_scroll;
        CCircular_Log_Buffer<std::string, Max_Logs> m_buffer;
        std::mutex m_mtx;
    };
}