#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CData_Transfer final
    {
    public:
        explicit CData_Transfer(std::uint32_t value) noexcept;

        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vd_Offset() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rn_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vd_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Immediate() const noexcept;

    private:
        std::uint32_t m_value;
    };
}