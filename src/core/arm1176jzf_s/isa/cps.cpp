#include "cps.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCPS::CCPS(zero_mate::arm1176jzf_s::isa::CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    CCPS::NType CCPS::Get_Type() const noexcept
    {
        return static_cast<NType>((m_value >> 18U) & 0b11U);
    }

    bool CCPS::Is_M_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 17U) & 0b1U);
    }

    bool CCPS::Is_A_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 8U) & 0b1U);
    }

    bool CCPS::Is_I_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 7U) & 0b1U);
    }

    bool CCPS::Is_F_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 6U) & 0b1U);
    }

    std::uint32_t CCPS::Get_Mode() const noexcept
    {
        return m_value & 0b11111U;
    }
}