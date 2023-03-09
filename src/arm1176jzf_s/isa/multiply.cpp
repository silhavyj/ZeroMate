#include "multiply.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CMultiply::CMultiply(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CMultiply::Is_A_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CMultiply::Is_S_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CMultiply::Get_Rd() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CMultiply::Get_Rn() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CMultiply::Get_Rs() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CMultiply::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }
}