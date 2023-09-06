#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CVMRS final
    {
    public:
        explicit CVMRS(std::uint32_t value) noexcept;

        [[nodiscard]] bool Transfer_To_APSR() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rt_Idx() const noexcept;

    private:
        std::uint32_t m_value;
    };
}
