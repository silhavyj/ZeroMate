// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor_register_transfer.cpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a coprocessor register transfer as defined in coprocessor_register_transfer.hpp.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/mrc-and-mrc2
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/mcr-and-mcr2
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "coprocessor_register_transfer.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCoprocessor_Reg_Transfer::CCoprocessor_Reg_Transfer(
    zero_mate::arm1176jzf_s::isa::CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Opcode1() const noexcept
    {
        return (m_value >> 21U) & 0b111U;
    }

    bool CCoprocessor_Reg_Transfer::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_CRn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Coprocessor_ID() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_Opcode2() const noexcept
    {
        return (m_value >> 5U) & 0b111U;
    }

    std::uint32_t CCoprocessor_Reg_Transfer::Get_CRm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa