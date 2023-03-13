#include "branch_and_exchange.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CBranch_And_Exchange::CBranch_And_Exchange(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CBranch_And_Exchange::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 5U) & 0b1U);
    }

    CBranch_And_Exchange::NCPU_Instruction_Mode CBranch_And_Exchange::Get_Instruction_Mode() const noexcept
    {
        return static_cast<NCPU_Instruction_Mode>(m_value & 0b1U);
    }

    std::uint32_t CBranch_And_Exchange::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }
}