#pragma once

#include <memory>

namespace zero_mate::gui
{
    class CGUI_Object
    {
    public:
        CGUI_Object() = default;
        virtual ~CGUI_Object() = default;

        CGUI_Object(const CGUI_Object&) = delete;
        CGUI_Object& operator=(const CGUI_Object&) = delete;
        CGUI_Object(CGUI_Object&&) = delete;
        CGUI_Object& operator=(CGUI_Object&&) = delete;

        virtual void Render() = 0;
    };
}