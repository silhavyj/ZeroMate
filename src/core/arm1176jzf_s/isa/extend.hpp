#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CExtend final : CInstruction
    {
    public:
        enum class NType : std::uint32_t
        {
            SXTAB16 = 0,
            UXTAB16 = 1,
            SXTB16 = 2,
            UXTB16 = 3,

            SXTAB = 4,
            UXTAB = 5,
            SXTB = 6,
            UXTB = 7,

            SXTAH = 8,
            UXTAH = 9,
            SXTH = 10,
            UXTH = 11
        };

    public:
        explicit CExtend(CInstruction instruction) noexcept;

        [[nodiscard]] NType Get_Type() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rot() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;

    private:
        enum class NCategory_Mask
        {
            Category_0_0 = 0b000,
            Category_0_1 = 0b100,
            Category_1_0 = 0b010,
            Category_1_1 = 0b110,
            Category_2_0 = 0b011,
            Category_2_1 = 0b111,
        };
    };
}