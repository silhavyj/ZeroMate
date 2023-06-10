#pragma once

// Define the macro to handle symbol visibility
#ifdef _WIN32
    #ifdef EXTERNAL_PERIPHERAL_EXPORTS
        // If building the library on Windows
        #define EXTERNAL_PERIPHERAL_API __declspec(dllexport)
    #else
        // If consuming the library on Windows
        #define EXTERNAL_PERIPHERAL_API __declspec(dllimport)
    #endif
#else
    // If building or consuming the library on Linux or other platforms
    #define EXTERNAL_PERIPHERAL_API
#endif

#include <memory>

namespace zero_mate
{
    class EXTERNAL_PERIPHERAL_API IGUI_Window
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