#pragma once

#include "../window.hpp"

#include "../../core/arm1176jzf_s/core.hpp"
#include "../../core/bus.hpp"
#include "../../utils/elf_loader.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::gui
{
    class CFile_Window final : public IGUI_Window
    {
    public:
        explicit CFile_Window(
        std::shared_ptr<CBus> bus,
        std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
        std::unordered_map<std::string, std::vector<utils::elf::TText_Section_Record>>& source_codes,
        bool& elf_file_has_been_loaded,
        std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals);

        void Render() override;

    private:
        std::shared_ptr<CBus> m_bus;
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        std::unordered_map<std::string, std::vector<utils::elf::TText_Section_Record>>& m_source_codes;
        utils::CLogging_System& m_logging_system;
        bool& m_elf_file_has_been_loaded;
        std::vector<std::shared_ptr<peripheral::IPeripheral>>& m_peripherals;
    };
}