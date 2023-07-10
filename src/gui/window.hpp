// ---------------------------------------------------------------------------------------------------------------------
/// \file window.hpp
/// \date 05. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an interface for all windows that will be rendered by the application.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <string>
#include <memory>
/// \endcond

// 3rd party library includes

#include "imgui/imgui.h"

namespace zero_mate::gui
{
    namespace color
    {
        static constexpr ImVec4 White{ 1.0F, 1.0F, 1.0F, 1.0F };                ///< White color
        static constexpr ImVec4 Blue{ 0.0F, 0.7F, 1.0F, 1.0F };                 ///< Blue color
        static constexpr ImVec4 Green{ 0.0F, 1.0F, 0.0F, 1.0F };                ///< Green color
        static constexpr ImVec4 Yellow{ 1.0F, 1.0F, 0.0F, 1.0F };               ///< Yellow color
        static constexpr ImVec4 Red{ 1.0F, 0.0F, 0.0F, 1.0F };                  ///< Red color
        static constexpr ImVec4 Gray{ 0.65F, 0.65F, 0.65F, 1.0F };              ///< Gray color
        static constexpr ImVec4 Dark_Red{ 0.8F, 0.0F, 0.0F, 1.0F };             ///< Dark red color
        static constexpr ImVec4 Dark_Gray_1{ 0.25F, 0.25F, 0.25F, 1.0F };       ///< Dark gray color 1
        static constexpr ImVec4 Dark_Gray_2{ 0.2F, 0.2F, 0.2F, 1.0F };          ///< Dark gray color 2
        static constexpr ImVec4 Transparent_Yellow_1{ 1.0f, 1.0f, 0.0f, 0.3f }; ///< Transparent yellow color 1
        static constexpr ImVec4 Transparent_Yellow_2{ 1.0f, 1.0f, 0.0f, 0.5f }; ///< Transparent yellow color 2

        // -------------------------------------------------------------------------------------------------------------
        /// \struct TRGB
        /// \brief Representation of an RGB format.
        // -------------------------------------------------------------------------------------------------------------
        struct TRGB
        {
            float r{}; ///< Red
            float g{}; ///< Green
            float b{}; ///< Blue
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Assigns a string its corresponding color based on its hash value.
        /// \param str String which will be assigned a color.
        /// \return Color based on the hash value calculated from the given string
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] TRGB Assign_Color_From_Hash(const std::string& str);

    } // namespace color

    // -----------------------------------------------------------------------------------------------------------------
    /// \class IGUI_Window
    /// \brief Common interface for all GUI windows.
    // -----------------------------------------------------------------------------------------------------------------
    class IGUI_Window
    {
    public:
        // clang-format off
        /// Flags defining the looks of all tables.
        static constexpr ImGuiTableFlags Table_Flags = ImGuiTableFlags_SizingFixedFit |
                                                       ImGuiTableFlags_RowBg |
                                                       ImGuiTableFlags_Borders |
                                                       ImGuiTableFlags_Resizable |
                                                       ImGuiTableFlags_Reorderable |
                                                       ImGuiTableFlags_Hideable;
        // clang-format on

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class (default non-parameterized constructor).
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~IGUI_Window() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window(const IGUI_Window&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window& operator=(const IGUI_Window&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window(IGUI_Window&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IGUI_Window& operator=(IGUI_Window&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders the window.
        // -------------------------------------------------------------------------------------------------------------
        virtual void Render() = 0;
    };

} // namespace zero_mate