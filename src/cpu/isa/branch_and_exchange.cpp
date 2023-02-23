#include "branch_and_exchange.hpp"

namespace zero_mate::cpu::isa
{
    CBranch_And_Exchange::CBranch_And_Exchange(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CBranch_And_Exchange::Switch_To_Thumb() const noexcept
    {
        return static_cast<bool>(m_value & 0b1U);
    }

    std::uint32_t CBranch_And_Exchange::Get_Rn() const noexcept
    {
        return m_value & 0b1111U;
    }
}