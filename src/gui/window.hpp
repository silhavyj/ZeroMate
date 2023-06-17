#pragma once

#include <memory>

namespace zero_mate
{
    class IGUI_Window
    {
    public:
        IGUI_Window() = default;
        virtual ~IGUI_Window() = default;

        IGUI_Window(const IGUI_Window&) = delete;
        IGUI_Window& operator=(const IGUI_Window&) = delete;
        IGUI_Window(IGUI_Window&&) = delete;
        IGUI_Window& operator=(IGUI_Window&&) = delete;

        virtual void Render() = 0;
    };
}