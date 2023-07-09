// ---------------------------------------------------------------------------------------------------------------------
/// \file window.cpp
/// \date 09. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements common functions that can be used throughout the GUI of the application.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <functional>
/// \endcond

// Project file imports

#include "window.hpp"

namespace zero_mate::gui::color
{
    TRGB Assign_Color_From_Hash(const std::string& str)
    {
        // TODO it may be worth adding a cache here

        // Calculate the hash value of the given string (class name).
        const std::size_t hash_value = std::hash<std::string>()(str) % 0xFFFFFFU;

        // Convert the hash value into the RGB format (0.0 - 1.0).
        return { .r = static_cast<float>((hash_value & 0xFF0000U) >> 16U) / 255.0f,
                 .g = static_cast<float>((hash_value & 0x00FF00U) >> 8U) / 255.0f,
                 .b = static_cast<float>(hash_value & 0x0000FFU) / 255.0f };
    }

} // namespace zero_mate::gui::color