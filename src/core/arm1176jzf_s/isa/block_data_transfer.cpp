#include "block_data_transfer.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CBlock_Data_Transfer::CBlock_Data_Transfer(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CBlock_Data_Transfer::Is_P_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 24U) & 0b1U);
    }

    bool CBlock_Data_Transfer::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 23U) & 0b1U);
    }

    bool CBlock_Data_Transfer::Is_S_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    bool CBlock_Data_Transfer::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CBlock_Data_Transfer::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    CBlock_Data_Transfer::NAddressing_Mode CBlock_Data_Transfer::Get_Addressing_Mode() const noexcept
    {
        return static_cast<NAddressing_Mode>((m_value >> 23U) & 0b11U);
    }

    std::uint32_t CBlock_Data_Transfer::Get_Rn() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CBlock_Data_Transfer::Get_Register_List() const noexcept
    {
        return m_value & 0b1111'1111'1111'1111U;
    }
}