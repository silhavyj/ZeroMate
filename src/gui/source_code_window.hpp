#pragma once

#include <unordered_map>

#include "object.hpp"

#include "../arm1176jzf_s/core.hpp"
#include "../utils/list_parser.hpp"

namespace zero_mate::gui
{
    class CSource_Code_Window final : public CGUI_Object
    {
    public:
        explicit CSource_Code_Window(std::shared_ptr<arm1176jzf_s::CCPU_Core> cpu,
                                     std::vector<utils::TText_Section_Record>& source_code);

        void Render() override;

    private:
        std::shared_ptr<arm1176jzf_s::CCPU_Core> m_cpu;
        std::vector<utils::TText_Section_Record>& m_source_code;
        std::unordered_map<std::uint32_t, bool> m_breakpoints;
    };
}