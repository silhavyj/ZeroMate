#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CData_Processing final
    {
    public:
        explicit CData_Processing(std::uint32_t value) noexcept;

        [[nodiscard]] std::uint32_t Get_Vn_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vd_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vm_Idx() const noexcept;

        [[nodiscard]] std::uint32_t Get_Vn_Offset() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vd_Offset() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vm_Offset() const noexcept;

    private:
        std::uint32_t m_value;
    };
}