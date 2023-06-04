// ---------------------------------------------------------------------------------------------------------------------
/// \file halfword_data_transfer.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a Halfword data transfer instruction as defined in halfword_data_transfer.hpp.
///
/// The following instructions are considered to be Halfword data transfer instruction:
/// LDRH, STRH, LDRSB, and LDRSH.
///
/// To find more information about this instruction, please visit
/// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.10)
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "halfword_data_transfer.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CHalfword_Data_Transfer::CHalfword_Data_Transfer(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CHalfword_Data_Transfer::Is_P_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 24U) & 0b1U);
    }

    bool CHalfword_Data_Transfer::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 23U) & 0b1U);
    }

    bool CHalfword_Data_Transfer::Is_Immediate_Offset() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    bool CHalfword_Data_Transfer::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CHalfword_Data_Transfer::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CHalfword_Data_Transfer::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CHalfword_Data_Transfer::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CHalfword_Data_Transfer::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    std::uint32_t CHalfword_Data_Transfer::Get_Immediate_Offset_High() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CHalfword_Data_Transfer::Get_Immediate_Offset_Low() const noexcept
    {
        return m_value & 0b1111U;
    }

    CHalfword_Data_Transfer::NType CHalfword_Data_Transfer::Get_Type() const noexcept
    {
        return static_cast<NType>((m_value >> 5U) & 0b11U);
    }

} // namespace zero_mate::arm1176jzf_s::isa