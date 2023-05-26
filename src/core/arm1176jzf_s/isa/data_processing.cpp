// ---------------------------------------------------------------------------------------------------------------------
/// \file data_processing.cpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a data processing instruction as defined in data_processing.hpp.
///
/// To find more information about this instruction, please visit
/// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.5)
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "data_processing.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CData_Processing::CData_Processing(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    bool CData_Processing::Is_I_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 25U) & 0b1U);
    }

    CData_Processing::NOpcode CData_Processing::Get_Opcode() const noexcept
    {
        return static_cast<NOpcode>((m_value >> 21U) & 0b1111U);
    }

    bool CData_Processing::Is_S_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 20U) & 0b1U);
    }

    std::uint32_t CData_Processing::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Shift_Amount() const noexcept
    {
        return (m_value >> 7U) & 0b11111U;
    }

    CData_Processing::NShift_Type CData_Processing::Get_Shift_Type() const noexcept
    {
        return static_cast<NShift_Type>((m_value >> 5U) & 0b11U);
    }

    bool CData_Processing::Is_Immediate_Shift() const noexcept
    {
        return !static_cast<bool>((m_value >> 4U) & 0b1U);
    }

    std::uint32_t CData_Processing::Get_Rs_Idx() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Rotate() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Immediate() const noexcept
    {
        return m_value & 0b11111111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa