#include "branch.hpp"
#include "../../utils/math.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CBranch::CBranch(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CBranch::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 24U) & 0b1U);
    }

    std::int32_t CBranch::Get_Offset() const noexcept
    {
        static constexpr std::uint32_t MASK_28_BITS = 0xFFFFFFFU;
        static constexpr std::uint32_t MASK_24_BITS = 0xFFFFFFU;

        if (utils::math::Is_Bit_Set(m_value, 23U))
        {
            const std::uint32_t twos_compliment = ((~(m_value & MASK_28_BITS) + 1) & MASK_24_BITS);
            return -static_cast<std::int32_t>(twos_compliment << 2U);
        }

        return static_cast<std::int32_t>((m_value & MASK_24_BITS) << 2U);
    }
}