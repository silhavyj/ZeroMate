// ---------------------------------------------------------------------------------------------------------------------
/// \file vmsr.cpp
/// \date 10. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a VMSR instruction (ARM register to a special FPU register).
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "vmsr.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    CVMSR::CVMSR(std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    CVMSR::NSpecial_Register_Type CVMSR::Get_Special_Reg_Type() const noexcept
    {
        return static_cast<NSpecial_Register_Type>((m_value >> 16U) & 0b1111U);
    }

    std::uint32_t CVMSR::Get_Rt_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

} // namespace zero_mate::coprocessor::cp10::isa