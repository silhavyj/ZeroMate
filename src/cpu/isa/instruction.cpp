#include "instruction.hpp"

namespace zero_mate::cpu::isa
{
    CInstruction::CInstruction(std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    std::uint32_t CInstruction::Get_Value() const noexcept
    {
        return m_value;
    }

    CInstruction::NCondition CInstruction::Get_Condition() const noexcept
    {
        return static_cast<NCondition>(m_value >> 28U);
    }
}