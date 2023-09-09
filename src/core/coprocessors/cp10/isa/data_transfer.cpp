#include "data_transfer.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    CData_Transfer::CData_Transfer(std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    bool CData_Transfer::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 23U) & 0b1U);
    }

    bool CData_Transfer::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    std::uint32_t CData_Transfer::Get_Vd_Offset() const noexcept
    {
        return (m_value >> 22U) & 0b1U;
    }

    std::uint32_t CData_Transfer::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CData_Transfer::Get_Vd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CData_Transfer::Get_Immediate() const noexcept
    {
        return m_value & 0b1111'1111U;
    }
}