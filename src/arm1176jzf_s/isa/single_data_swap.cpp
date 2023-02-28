#include "single_data_swap.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSingle_Data_Swap::CSingle_Data_Swap(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CSingle_Data_Swap::Is_B_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    std::uint32_t CSingle_Data_Swap::Get_Rn() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CSingle_Data_Swap::Get_Rd() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CSingle_Data_Swap::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }
}