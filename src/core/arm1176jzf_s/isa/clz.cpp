// ---------------------------------------------------------------------------------------------------------------------
/// \file clz.cpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a count leading zeros instruction (CLZ) as defined in clz.hpp.
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0802/b/A32-and-T32-Instructions/CLZ
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "clz.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCLZ::CCLZ(zero_mate::arm1176jzf_s::isa::CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CCLZ::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CCLZ::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa