#include "single_data_transfer.hpp"

namespace zero_mate::cpu::isa
{
    CSingle_Data_Transfer::CSingle_Data_Transfer(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CSingle_Data_Transfer::Is_I_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 25U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_P_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 24U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 23U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_B_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CSingle_Data_Transfer::Get_Rn() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Rd() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Immediate_Offset() const noexcept
    {
        return m_value & 0b1111'1111'1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Shift() const noexcept
    {
        return (m_value >> 4U) & 0b1111'1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }
}