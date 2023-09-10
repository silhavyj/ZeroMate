// ---------------------------------------------------------------------------------------------------------------------
/// \file vmsr.hpp
/// \date 10. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a VMSR instruction (ARM register to a special FPU register).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CVMSR
    /// \brief This class represents a VMSR instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CVMSR final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NSpecial_Register_Type
        /// \brief Enumeration of FPU special registers.
        // -------------------------------------------------------------------------------------------------------------
        enum class NSpecial_Register_Type : std::uint32_t
        {
            FPSID = 0b0000U, ///< Not used
            FPSCR = 0b0001U, ///< Contains flags (result of the VCMP instruction)
            FPEXC = 0b1000U  ///< Enable/disable the FPU
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as a 32-bit integer.
        // -------------------------------------------------------------------------------------------------------------
        explicit CVMSR(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the special register encoded in the instruction.
        /// \return Type of the special register.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NSpecial_Register_Type Get_Special_Reg_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of an ARM register (source).
        /// \return Index of an ARM register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rt_Idx() const noexcept;

    private:
        std::uint32_t m_value; ///< Encoded instruction as a 32-bit integer
    };

} // namespace zero_mate::coprocessor::cp10::isa