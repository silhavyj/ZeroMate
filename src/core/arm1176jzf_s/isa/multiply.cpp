// ---------------------------------------------------------------------------------------------------------------------
/// \file multiply.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a multiplication instruction (MUL, MLA) as defined in multiply.hpp.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-multiply-instructions/MUL-and-MLA
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "multiply.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CMultiply::CMultiply(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CMultiply::Is_A_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CMultiply::Is_S_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CMultiply::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CMultiply::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CMultiply::Get_Rs_Idx() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CMultiply::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa