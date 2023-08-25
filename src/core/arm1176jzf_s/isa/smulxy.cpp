// ---------------------------------------------------------------------------------------------------------------------
/// \file smulxy.cpp
/// \date 22. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a SMULxy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/100235/0004/the-cortex-m33-instruction-set/multiply-and-divide-instructions/
/// smul-and-smulw?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "smulxy.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSMULxy::CSMULxy(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CSMULxy::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CSMULxy::Get_Rs_Idx() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CSMULxy::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    CSMULxy::NType CSMULxy::Get_Type() const noexcept
    {
        return static_cast<NType>((m_value >> 5U) & 0b11U);
    }

} // namespace zero_mate::arm1176jzf_s::isa