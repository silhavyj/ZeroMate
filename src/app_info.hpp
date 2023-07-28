#pragma once

namespace zero_mate::app_info
{
    /// Current version of the application
    inline const char* const Version = "v1.1.0";

    /// URL where the project is held
    inline const char* const URL = "https://github.com/silhavyj/ZeroMate";

    /// Author of the project
    inline const char* const Author = "Jakub Silhavy";

    /// Contact email
    inline const char* const Email = "jakub.silhavy.cz@gmail.com";

    /// Project description
    inline const char* const Description =
    R"CLC(
ZeroMate is an educational Raspberry Pi Zero emulator designed
specifically as a debugging tool for operating system development.
Please keep in mind that while using the emulator, certain features
may be missing or limited as it is still under active development.
    )CLC";

} // namespace zero_mate::app_info