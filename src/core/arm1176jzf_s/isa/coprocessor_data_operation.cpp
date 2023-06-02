// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor_data_operation.cpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a coprocessor data operation (CDP) as defined in coprocessor_data_operation.hpp.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/cdp-and-cdp2
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "coprocessor_data_operation.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCoprocessor_Data_Operation::CCoprocessor_Data_Operation(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_Opcode1() const noexcept
    {
        return (m_value >> 20U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_CRn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_CRd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_Coprocessor_ID() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_Opcode2() const noexcept
    {
        return (m_value >> 5U) & 0b111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_CRm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }
} // namespace zero_mate::arm1176jzf_s::isa