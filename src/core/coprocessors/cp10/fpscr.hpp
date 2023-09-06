#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10
{
    class CFPSCR final
    {
    public:
        enum class NFlag : std::uint32_t
        {
            N = 0b1U << 31U,
            Z = 0b1U << 30U,
            C = 0b1U << 29U,
            V = 0b1U << 28U
        };

    public:
        CFPSCR();
        CFPSCR(const CFPSCR& other) = default;

        CFPSCR& operator=(std::uint32_t value);

        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;
        [[nodiscard]] std::uint32_t Get_Value() const noexcept;
        void Set_Flag(NFlag flag, bool set);

    private:
        std::uint32_t m_value;
    };
}