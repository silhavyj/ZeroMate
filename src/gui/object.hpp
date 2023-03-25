#pragma once

#include <memory>

namespace zero_mate::gui
{
    class CGUI_Window
    {
    public:
        CGUI_Window() = default;
        virtual ~CGUI_Window() = default;

        CGUI_Window(const CGUI_Window&) = delete;
        CGUI_Window& operator=(const CGUI_Window&) = delete;
        CGUI_Window(CGUI_Window&&) = delete;
        CGUI_Window& operator=(CGUI_Window&&) = delete;

        virtual void Render() = 0;
    };
}