#include <imgui/imgui.h>
#include <imgui_memory_editor/imgui_memory_editor.h>

#include "ram_window.hpp"

namespace zero_mate::gui
{
    CRAM_Window::CRAM_Window(std::shared_ptr<peripheral::CRAM> ram)
    : m_ram{ ram }
    {
    }

    void CRAM_Window::Render()
    {
        static MemoryEditor ram_editor;
        ram_editor.DrawWindow("RAM", m_ram->Get_Raw_Data(), m_ram->Get_Size());
    }
}