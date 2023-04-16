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

    std::uint32_t CPSR_Transfer::Get_Mask() const noexcept
    {
        std::uint32_t mask{ 0 };

        if (Is_F_Bit_Set())
        {
            mask |= (0xFFU << 24U);
        }
        if (Is_S_Bit_Set())
        {
            mask |= (0xFFU << 16U);
        }
        if (Is_X_Bit_Set())
        {
            mask |= (0xFFU << 8U);
        }
        if (Is_C_Bit_Set())
        {
            mask |= 0xFFU;
        }

        return mask;
    }

    bool CPSR_Transfer::Is_F_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 19U) & 0b1U);
    }

    bool CPSR_Transfer::Is_S_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 18U) & 0b1U);
    }

    bool CPSR_Transfer::Is_X_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 17U) & 0b1U);
    }

    bool CPSR_Transfer::Is_C_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 16U) & 0b1U);
    }
}