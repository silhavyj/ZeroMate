#include "psr_transfer.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CPSR_Transfer::CPSR_Transfer(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    CPSR_Transfer::NRegister CPSR_Transfer::Get_Register_Type() const noexcept
    {
        return static_cast<NRegister>((m_value >> 22U) & 0b1U);
    }

    CPSR_Transfer::NType CPSR_Transfer::Get_Type() const noexcept
    {
        return static_cast<NType>((m_value >> 21U) & 0b1U);
    }

    std::uint32_t CPSR_Transfer::Get_Rd() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CPSR_Transfer::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }

    std::uint32_t CPSR_Transfer::Get_Flags() const noexcept
    {
        return ((m_value >> 16U) & 0b1111U) << 28U;
    }
}