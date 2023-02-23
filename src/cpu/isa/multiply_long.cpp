#include "multiply_long.hpp"

namespace zero_mate::cpu::isa
{
    CMultiply_Long::CMultiply_Long(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CMultiply_Long::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    bool CMultiply_Long::Is_A_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CMultiply_Long::Is_S_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CMultiply_Long::Get_Rd_Hi() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CMultiply_Long::Get_Rd_Lo() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CMultiply_Long::Get_Rs() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CMultiply_Long::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }
}