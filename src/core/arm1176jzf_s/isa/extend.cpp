// ---------------------------------------------------------------------------------------------------------------------
/// \file extend.cpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an extend instruction as defined in extend.hpp.
///
/// The following instructions are considered to extend instructions:
/// SXTAB16, UXTAB16, SXTB16, UXTB16, SXTAB, UXTAB, SXTB, UXTB, SXTAH, UXTAH, SXTH, and UXTH
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/sxtab16 (the other instruction types
/// can be find in the next sections).
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <unordered_map>
/// \endcond

// Project file imports

#include "extend.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CExtend::CExtend(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    CExtend::NType CExtend::Get_Type() const noexcept
    {
        // Create a look-up table to figure out the type of the
        // operation based on a given mask.
        static const std::unordered_map<NCategory_Mask, std::uint32_t> category_idx = {
            { NCategory_Mask::Category_0_0, 0 }, // index 0
            { NCategory_Mask::Category_0_1, 1 }, // index 1
            { NCategory_Mask::Category_1_0, 4 }, // index 4
            { NCategory_Mask::Category_1_1, 5 }, // index 5
            { NCategory_Mask::Category_2_0, 8 }, // index 8
            { NCategory_Mask::Category_2_1, 9 }, // index 9
        };

        // Figure out the operation type index.
        std::uint32_t idx = category_idx.at(static_cast<NCategory_Mask>((m_value >> 20U) & 0b111U));

        // If the Rn register is 15, it means that the instruction is not an Add type.
        if (Get_Rn_Idx() == 15U)
        {
            // Move on to the non-add type within the same category.
            idx += 2;
        }

        // Return the actual index.
        return static_cast<NType>(idx);
    }

    std::uint32_t CExtend::Get_Rn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CExtend::Get_Rd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CExtend::Get_Rot() const noexcept
    {
        return 8U * ((m_value >> 10U) & 0b11U);
    }

    std::uint32_t CExtend::Get_Rm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

} // namespace zero_mate::arm1176jzf_s::isa