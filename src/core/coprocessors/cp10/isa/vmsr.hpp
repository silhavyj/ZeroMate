#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CVMSR final
    {
    public:
        enum class NSpecial_Register_Type : std::uint32_t
        {
            FPSID = 0b0000U,
            FPSCR = 0b0001U,
            FPEXC = 0b1000U
        };

    public:
        explicit CVMSR(std::uint32_t value) noexcept;

        [[nodiscard]] NSpecial_Register_Type Get_Special_Reg_Type() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rt_Idx() const noexcept;

    private:
        std::uint32_t m_value;
    };
}