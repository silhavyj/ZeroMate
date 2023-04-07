#pragma once

#include "../window.hpp"

#include "../../core/arm1176jzf_s/cpu_core.hpp"
#include "../../core/peripherals/bus.hpp"
#include "../../core/utils/elf_loader.hpp"
#include "../../core/utils/logger/logger.hpp"

namespace zero_mate::gui
{
    class CFile_Window final : public CGUI_Window
    {
    public:
        explicit CFile_Window(std::shared_ptr<CBus> bus,
                              std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                              std::vector<utils::elf::TText_Section_Record>& source_code);

        void Render() override;

    private:
        std::shared_ptr<CBus> m_bus;
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        std::vector<utils::elf::TText_Section_Record>& m_source_code;
        utils::CLogging_System& m_logging_system;
    };
}