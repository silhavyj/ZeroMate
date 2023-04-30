#include "coprocessor_register_transfer.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCoprocessor_Reg_Transfer::CCoprocessor_Reg_Transfer(zero_mate::arm1176jzf_s::isa::CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Operation_Mode() const noexcept
    {
        return (m_value >> 21U) & 0b111U;
    }

    bool CCoprocessor_Reg_Transfer::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_CRd() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Rd() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Coprocessor_ID() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Coprocessor_Information() const noexcept
    {
        return (m_value >> 5U) & 0b111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_CRm() const noexcept
    {
        return m_value & 0b1111U;
    }
}