#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10::isa
{
    class CData_Processing final
    {
    public:
        struct TRegisters
        {
            std::uint32_t vd_idx;
            std::uint32_t vn_idx;
            std::uint32_t vm_idx;
        };

    public:
        explicit CData_Processing(std::uint32_t value) noexcept;

        [[nodiscard]] std::uint32_t Get_Vn_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vd_Idx() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vm_Idx() const noexcept;

        [[nodiscard]] std::uint32_t Get_Vn_Offset() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vd_Offset() const noexcept;
        [[nodiscard]] std::uint32_t Get_Vm_Offset() const noexcept;

        [[nodiscard]] bool Is_OP_Bit_Set() const noexcept;
        [[nodiscard]] bool Compare_With_Zero() const noexcept;
        [[nodiscard]] bool Is_Accumulate_Type() const noexcept;

        [[nodiscard]] TRegisters Get_Register_Idxs() const noexcept;

    private:
        std::uint32_t m_value;
    };
}