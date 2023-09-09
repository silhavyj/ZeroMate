// ---------------------------------------------------------------------------------------------------------------------
/// \file data_processing.cpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a data processing instruction.
///
/// It groups up the functionality of the majory of the data processing instructions.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "data_processing.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    CData_Processing::CData_Processing(std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    std::uint32_t CData_Processing::Get_Vn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Vd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Vm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Vn_Offset() const noexcept
    {
        return (m_value >> 7U) & 0b1U;
    }

    std::uint32_t CData_Processing::Get_Vd_Offset() const noexcept
    {
        return (m_value >> 22U) & 0b1U;
    }

    std::uint32_t CData_Processing::Get_Vm_Offset() const noexcept
    {
        return (m_value >> 5U) & 0b1U;
    }

    bool CData_Processing::Is_OP_6_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 6U) & 0b1U);
    }

    bool CData_Processing::Is_OP_7_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 7U) & 0b1U);
    }

    bool CData_Processing::Compare_With_Zero() const noexcept
    {
        return !static_cast<bool>((m_value >> 16U) & 0b1U);
    }

    bool CData_Processing::Is_Accumulate_Type() const noexcept
    {
        return ((m_value >> 20U) & 0b11U) == 0b01U;
    }

    bool CData_Processing::To_Integer() const noexcept
    {
        return static_cast<bool>((m_value >> 18U) & 0b1U);
    }

    bool CData_Processing::Signed() const noexcept
    {
        return static_cast<bool>((m_value >> 16U) & 0b1U);
    }

    CData_Processing::TRegisters CData_Processing::Get_Register_Idxs() const noexcept
    {
        // We assume that single-precision registers are being used (S{x}).

        return { .vd_idx = 2 * Get_Vd_Idx() + Get_Vd_Offset(),
                 .vn_idx = 2 * Get_Vn_Idx() + Get_Vn_Offset(),
                 .vm_idx = 2 * Get_Vm_Idx() + Get_Vm_Offset() };
    }

} // namespace zero_mate::coprocessor::cp10::isa