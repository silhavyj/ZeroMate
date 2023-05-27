// ---------------------------------------------------------------------------------------------------------------------
/// \file multiply_long.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a multiplication (long) instruction as defined in multiply_long.hpp.
///
/// The following instructions are considered to be multiplication long instructions:
/// UMULL, UMLAL, SMULL, and SMLAL.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/umull (the other instruction types
/// can be found in the following sections).
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "multiply_long.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CMultiply_Long::CMultiply_Long(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CMultiply_Long::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    bool CMultiply_Long::Is_A_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CMultiply_Long::Is_S_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CMultiply_Long::Get_Rd_Hi_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CMultiply_Long::Get_Rd_Lo_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CMultiply_Long::Get_Rs_Idx() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CMultiply_Long::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa