#pragma once

#include <cstdint>

namespace zero_mate::gui
{
    namespace config
    {
        inline const char* const Font_Path = "fonts/Cousine-Regular.ttf";
        inline const char* const Icons_Path = "icons/fa-solid-900.ttf";

    } // namespace config

    int Main_GUI(int argc, const char* argv[]);

} // namespace zero_mate::gui