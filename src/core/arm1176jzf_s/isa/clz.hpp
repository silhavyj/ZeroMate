// ---------------------------------------------------------------------------------------------------------------------
/// \file clz.hpp
/// \date 26. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a count leading zeros instruction (CLZ).
///
/// To find more information about this instruction, please visit
/// https://developer.arm.com/documentation/dui0802/b/A32-and-T32-Instructions/CLZ
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCLZ
    /// \brief This class represents a count leading zeros instruction (it is inherited from the CInstruction class).
    // -----------------------------------------------------------------------------------------------------------------
    class CCLZ final : public CInstruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param instruction General instruction (32-bit value)
        // -------------------------------------------------------------------------------------------------------------
        explicit CCLZ(CInstruction instruction) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the destination register (Rd) where the result will be stored.
        /// \return Index of the destination register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of the Rm register involved in the calculation of the number of leasing zeros.
        /// \return Index of the Rm register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
    };

} // namespace zero_mate::arm1176jzf_s::isa