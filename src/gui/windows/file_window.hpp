#pragma once

#include "imgui.h"
#include "imfilebrowser.h"

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
        explicit CFile_Window(std::shared_ptr<CBus> bus,
                              std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                              utils::elf::Source_Codes_t& source_codes,
                              bool& m_kernel_has_been_loaded,
                              std::vector<std::shared_ptr<peripheral::IPeripheral>>& peripherals,
                              const bool& cpu_running);

        void Render() override;

    private:
        inline void Init_File_Browser();
        inline void Render_Load_Button(const char* name, bool loading_kernel);
        inline void Render_Kernel_Filename();
        inline void Render_Reload_Button();
        inline void Render_File_Browser();
        inline void Load_ELF_Files();
        inline void Load_ELF_File(const std::string& path, bool loading_kernel);
        [[nodiscard]] static std::string Get_Filename(const std::string& path);

    private:
        std::shared_ptr<CBus> m_bus;
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        utils::elf::Source_Codes_t& m_source_codes;
        utils::CLogging_System& m_logging_system;
        bool& m_kernel_has_been_loaded;
        std::vector<std::shared_ptr<peripheral::IPeripheral>>& m_peripherals;
        ImGui::FileBrowser m_file_browser;
        bool m_loading_kernel;
        const bool& m_cpu_running;
        std::string m_kernel_filename;
    };
}