// ---------------------------------------------------------------------------------------------------------------------
/// \file smlaxy.cpp
/// \date 25. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a SMLAxy instruction.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-multiply-instructions/SMLAxy
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "smlaxy.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSMLAxy::CSMLAxy(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CSMLAxy::Get_Rd_Idx() const noexcept
    {
        return static_cast<std::uint32_t>((m_value >> 16U) & 0b1111U);
    }

    std::uint32_t CSMLAxy::Get_Rn_Idx() const noexcept
    {
        return static_cast<std::uint32_t>((m_value >> 12U) & 0b1111U);
    }

    std::uint32_t CSMLAxy::Get_Rs_Idx() const noexcept
    {
        return static_cast<std::uint32_t>((m_value >> 8U) & 0b1111U);
    }

    std::uint32_t CSMLAxy::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    CSMLAxy::NType CSMLAxy::Get_Type() const noexcept
    {
        return static_cast<NType>((m_value >> 5U) & 0b11U);
    }

} // namespace zero_mate::arm1176jzf_s::isa
