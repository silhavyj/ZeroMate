// ---------------------------------------------------------------------------------------------------------------------
/// \file vmov_arm_register_single_precision_register.cpp
/// \date 10. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a VMOV instruction between an ARM register and an FPU register.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "vmov_arm_register_single_precision_register.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    CVMOV_ARM_Register_Single_Precision_Register::CVMOV_ARM_Register_Single_Precision_Register(
    std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    bool CVMOV_ARM_Register_Single_Precision_Register::To_ARM_Register() const noexcept
    {
        return static_cast<bool>((m_value >> 20) & 0b1U);
    }

    std::uint32_t CVMOV_ARM_Register_Single_Precision_Register::Get_Vn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CVMOV_ARM_Register_Single_Precision_Register::Get_Rt_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CVMOV_ARM_Register_Single_Precision_Register::Get_Vn_Offset() const noexcept
    {
        return (m_value >> 7U) & 0b1U;
    }

} // namespace zero_mate::coprocessor::cp10::isa