#pragma once

#include "window.hpp"

#include "../arm1176jzf_s/core.hpp"
#include "../utils/list_parser.hpp"

namespace zero_mate::gui
{
    class CSource_Code_Window : public CGUI_Window
    {
    public:
        explicit CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     std::vector<utils::TText_Section_Record>& source_code);

        void Render() override;

    private:
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        std::vector<utils::TText_Section_Record>& m_source_code;
    };
}