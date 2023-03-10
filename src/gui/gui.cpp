#include <memory>

#include <imgui/imgui.h>
#include <imgui_memory_editor/imgui_memory_editor.h>

#include "gui.hpp"

#include "../bus/bus.hpp"
#include "../peripherals/ram.hpp"
#include "../arm1176jzf_s/core.hpp"

namespace zero_mate::gui
{
    static constexpr std::uint32_t RAM_SIZE = 256 * 1024 * 1024;

    static auto ram_s = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
    static auto bus_s = std::make_shared<CBus>();
    static auto cpu_s = std::make_unique<arm1176jzf_s::CCPU_Core>(0, bus_s);

    static bool initialized_s{ false };

    static void Initialize()
    {
        if (bus_s->Attach_Peripheral(0x0, ram_s) != 0)
        {
            // TODO
        }
    }

    static void Render_RAM_Window()
    {
        static MemoryEditor ram_editor;
        ram_editor.DrawWindow("RAM", ram_s->Get_Raw_Data(), ram_s->Get_Size());
    }

    void Render_GUI()
    {
        if (!initialized_s)
        {
            Initialize();
            initialized_s = true;
        }

        Render_RAM_Window();
    }
}