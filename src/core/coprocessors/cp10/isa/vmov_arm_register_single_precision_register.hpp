#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CVMOV_ARM_Register_Single_Precision_Register final
    {
    public:
        explicit CVMOV_ARM_Register_Single_Precision_Register(std::uint32_t value) noexcept;

        [[nodiscard]] bool To_ARM_Register() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vn_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rt_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vn_Offset() const noexcept;

    private:
        std::uint32_t m_value;
    };
}