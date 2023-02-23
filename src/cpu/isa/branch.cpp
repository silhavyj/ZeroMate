#include "branch.hpp"

namespace zero_mate::cpu::isa
{
    CBranch::CBranch(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CBranch::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 24U) & 0b1U);
    }

    std::uint32_t CBranch::Get_Offset() const noexcept
    {
        return m_value & 0b1111'1111'1111'1111'1111'1111U;
    }
}