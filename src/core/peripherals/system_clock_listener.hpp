#pragma once

#include <cstdint>

namespace zero_mate::peripheral
{
    class ISystem_Clock_Listener
    {
    public:
        ISystem_Clock_Listener() = default;
        virtual ~ISystem_Clock_Listener() = default;

        ISystem_Clock_Listener(const ISystem_Clock_Listener&) = delete;
        ISystem_Clock_Listener& operator=(const ISystem_Clock_Listener&) = delete;
        ISystem_Clock_Listener(ISystem_Clock_Listener&&) = delete;
        ISystem_Clock_Listener& operator=(ISystem_Clock_Listener&&) = delete;

        virtual void Update(std::uint32_t cycles_passed) = 0;
    };
}