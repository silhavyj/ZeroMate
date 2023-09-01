#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10
{
    class CFPEXC final
    {
    public:
        enum class NFlags : std::uint32_t
        {
            EX = 31U,
            EN = 30U,
        };

    public:
        CFPEXC();
        CFPEXC(const CFPEXC& other) = default;

        CFPEXC& operator=(std::uint32_t value);
        [[nodiscard]] bool Is_Enabled() const noexcept;

    private:
        std::uint32_t m_value;
    };
}