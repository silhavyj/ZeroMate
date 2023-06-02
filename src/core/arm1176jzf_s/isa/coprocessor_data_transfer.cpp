// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor_data_transfer.cpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a coprocessor data transfer (LDC, STC) as defined in coprocessor_data_transfer.hpp.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/ldc-and-ldc2,
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/stc-and-stc2
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "coprocessor_data_transfer.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCoprocessor_Data_Transfer::CCoprocessor_Data_Transfer(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CCoprocessor_Data_Transfer::Is_P_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 24U) & 0b1U);
    }

    bool CCoprocessor_Data_Transfer::Is_U_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 23U) & 0b1U);
    }

    bool CCoprocessor_Data_Transfer::Is_N_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 22U) & 0b1U);
    }

    bool CCoprocessor_Data_Transfer::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    bool CCoprocessor_Data_Transfer::Is_L_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CCoprocessor_Data_Transfer::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Transfer::Get_CRd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Transfer::Get_Coprocessor_ID() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Transfer::Get_Offset() const noexcept
    {
        return m_value & 0b1111'1111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa