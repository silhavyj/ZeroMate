// ---------------------------------------------------------------------------------------------------------------------
/// \file smulwy.hpp
/// \date 23. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a SMULWy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/ddi0597/2020-12/Base-Instructions/
/// SMULWB--SMULWT--Signed-Multiply--word-by-halfword--
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "smulwy.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSMULWy::CSMULWy(zero_mate::arm1176jzf_s::isa::CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CSMULWy::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CSMULWy::Get_Rs_Idx() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CSMULWy::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    CSMULWy::NType CSMULWy::Get_Type() const noexcept
    {
        return static_cast<NType>((m_value >> 6U) & 0b1U);
    }

} // namespace zero_mate::arm1176jzf_s::isa