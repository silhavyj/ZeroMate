#include <unordered_map>

#include "extend.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CExtend::CExtend(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    CExtend::NType CExtend::Get_Type() const noexcept
    {
        static const std::unordered_map<NCategory_Mask, std::uint32_t> category_idx = {
            { NCategory_Mask::Category_0_0, 0 },
            { NCategory_Mask::Category_0_1, 1 },
            { NCategory_Mask::Category_1_0, 4 },
            { NCategory_Mask::Category_1_1, 5 },
            { NCategory_Mask::Category_2_0, 8 },
            { NCategory_Mask::Category_2_1, 9 },
        };

        std::uint32_t idx = category_idx.at(static_cast<NCategory_Mask>((m_value >> 20U) & 0b111U));

        if (Get_Rn() == 15U)
        {
            idx += 2;
        }

        return static_cast<NType>(idx);
    }

    std::uint32_t CExtend::Get_Rn() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CExtend::Get_Rd() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CExtend::Get_Rot() const noexcept
    {
        return 8U * ((m_value >> 10U) & 0b11U);
    }

    std::uint32_t CExtend::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }
}