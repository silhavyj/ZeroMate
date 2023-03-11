#include <memory>

#include "gui.hpp"
#include "window.hpp"
#include "registers_window.hpp"
#include "ram_window.hpp"
#include "control_window.hpp"
#include "source_code_window.hpp"

#include "../utils/elf_loader.hpp"

namespace zero_mate::gui
{
    static auto s_ram = std::make_shared<peripheral::CRAM<>>();
    static auto s_bus = std::make_shared<CBus>();
    static auto s_cpu = std::make_shared<arm1176jzf_s::CCPU_Core>(0, s_bus);

    static std::vector<utils::TText_Section_Record> s_source_code{};

    static const std::vector<std::shared_ptr<CGUI_Window>> s_windows = {
        std::make_shared<CRegisters_Window>(s_cpu),
        std::make_shared<CRAM_Window>(s_ram),
        std::make_shared<CControl_Window>(s_cpu),
        std::make_shared<CSource_Code_Window>(s_cpu, s_source_code)
    };

    static void Initialize()
    {
        static bool initialized_s{ false };

        if (initialized_s)
        {
            return;
        }
        initialized_s = true;

        if (s_bus->Attach_Peripheral(0x0, s_ram) != 0)
        {
            // TODO
        }

        [[maybe_unused]] const auto result = zero_mate::utils::elf::Load_Kernel(*s_bus, "/home/silhavyj/School/ZeroMate/test/utils/elf/source_files/test_02/kernel.elf");
        s_cpu->Set_PC(result.pc);
        s_source_code = utils::Extract_Text_Section_From_List_File("/home/silhavyj/School/ZeroMate/test/utils/elf/source_files/test_02/kernel.list");
    }

    void Render_GUI()
    {
        Initialize();

        for (auto& window : s_windows)
        {
            window->Render();
        }
    }
}