// ---------------------------------------------------------------------------------------------------------------------
/// \file single_data_transfer.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements single data transfer instruction (LDR, STR) as defined in single_data_transfer.hpp.
///
/// To find more information about this instruction, please visit
/// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.9)
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "single_data_transfer.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSingle_Data_Transfer::CSingle_Data_Transfer(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CSingle_Data_Transfer::Is_I_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 25U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_P_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 24U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 23U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_B_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CSingle_Data_Transfer::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CSingle_Data_Transfer::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Immediate_Offset() const noexcept
    {
        return m_value & 0b1111'1111'1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    std::uint32_t CSingle_Data_Transfer::Get_Shift_Amount() const noexcept
    {
        return (m_value >> 7U) & 0b11111U;
    }

    CSingle_Data_Transfer::NShift_Type CSingle_Data_Transfer::Get_Shift_Type() const noexcept
    {
        return static_cast<NShift_Type>((m_value >> 5U) & 0b11U);
    }

} // namespace zero_mate::arm1176jzf_s::isa