// ---------------------------------------------------------------------------------------------------------------------
/// \file instruction.cpp
/// \date 25. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the interface of a general ARM instruction defined in instruction.hpp.
// ---------------------------------------------------------------------------------------------------------------------

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CInstruction::CInstruction(std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    bool CInstruction::operator==(const CInstruction& other) const
    {
        return m_value == other.m_value;
    }

    bool CInstruction::operator!=(const CInstruction& other) const
    {
        return !(*this == other);
    }

    std::uint32_t CInstruction::Get_Value() const noexcept
    {
        return m_value;
    }

    CInstruction::NCondition CInstruction::Get_Condition() const noexcept
    {
        // The most significant 4 bits represent the condition field.
        return static_cast<NCondition>(m_value >> 28U);
    }

} // namespace zero_mate::arm1176jzf_s::isa