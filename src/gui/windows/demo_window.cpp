// ---------------------------------------------------------------------------------------------------------------------
/// \file demo_window.cpp
/// \date 28. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a window that displays the ImGui and ImPlot demos (used for debugging).
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party libraries

#include "imgui.h"
#include "implot/implot.h"

// Project file imports

#include "demo_window.hpp"

namespace zero_mate::gui
{
    void CDemo_Window::Render()
    {
        // Render the window.
        if (ImGui::Begin("Demo"))
        {
            Render_ImGUI_Demo();
            Render_ImPlot_Demo();
        }

        ImGui::End();
    }

    void CDemo_Window::Render_ImGUI_Demo()
    {
        // Checkbox for showing/hiding the demo window.
        static bool show_demo{ false };
        ImGui::Checkbox("Show ImGUI demo", &show_demo);

        // If the user wishes to show the demo window, display it.
        if (show_demo)
        {
            ImGui::ShowDemoWindow(&show_demo);
        }
    }

    void CDemo_Window::Render_ImPlot_Demo()
    {
        // Checkbox for showing/hiding the demo window.
        static bool show_demo{ false };
        ImGui::Checkbox("Show ImPlot demo", &show_demo);

        // If the user wishes to show the demo window, display it.
        if (show_demo)
        {
            ImPlot::ShowDemoWindow(&show_demo);
        }
    }

} // namespace zero_mate::gui