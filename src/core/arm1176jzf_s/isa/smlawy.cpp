// ---------------------------------------------------------------------------------------------------------------------
/// \file smlawy.cpp
/// \date 25. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a SMLAWy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/ddi0597/2020-12/Base-Instructions/SMLAWB--SMLAWT--
/// Signed-Multiply-Accumulate--word-by-halfword--?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "smlawy.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSMLAWy::CSMLAWy(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CSMLAWy::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CSMLAWy::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CSMLAWy::Get_Rs_Idx() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CSMLAWy::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    CSMLAWy::NType CSMLAWy::Get_Type() const noexcept
    {
        return static_cast<NType>((m_value >> 5U) & 0b11U);
    }

} // namespace zero_mate::arm1176jzf_s::isa