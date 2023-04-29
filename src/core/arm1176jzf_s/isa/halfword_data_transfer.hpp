#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CHalfword_Data_Transfer final : public CInstruction
    {
    public:
        enum class NType : std::uint32_t
        {
            SWP = 0b00,
            Unsigned_Halfwords = 0b01,
            Signed_Byte = 0b10,
            Signed_Halfwords = 0b11
        };

    public:
        explicit CHalfword_Data_Transfer(CInstruction instruction) noexcept;

        [[nodiscard]] bool Is_P_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_U_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_Immediate_Offset() const noexcept;
        [[nodiscard]] bool Is_W_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] bool Is_S_Bit_Set() const noexcept;
        [[nodiscard]] bool Is_H_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
        [[nodiscard]] std::uint32_t Get_Immediate_Offset_High() const noexcept;
        [[nodiscard]] std::uint32_t Get_Immediate_Offset_Low() const noexcept;
        [[nodiscard]] NType Get_Type() const noexcept;
    };
}