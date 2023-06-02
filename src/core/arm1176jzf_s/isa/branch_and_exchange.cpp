// ---------------------------------------------------------------------------------------------------------------------
/// \file branch_and_exchange.cpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a branch and exchange instruction (BX) as defined in branch_and_exchange.hpp.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/bx
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

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

    CBranch_And_Exchange::NCPU_Instruction_Mode
    CBranch_And_Exchange::Get_Instruction_Mode(std::uint32_t rm_reg_value) const noexcept
    {
        return static_cast<NCPU_Instruction_Mode>(rm_reg_value & 0b1U);
    }

    std::uint32_t CBranch_And_Exchange::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa