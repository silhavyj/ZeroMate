// ---------------------------------------------------------------------------------------------------------------------
/// \file vmrs.hpp
/// \date 10. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a VMRS instruction (FPU special register to an ARM register).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CVMRS
    /// \brief This class represents a VMRS instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CVMRS final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as a 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CVMRS(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether an FPU special register should be transferred to the ARM APSR register (flags).
        /// \return true if the special register should be transferred to APSR. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Transfer_To_APSR() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of an ARM destination register.
        /// \return Index of an ARM register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rt_Idx() const noexcept;

    private:
        std::uint32_t m_value; ///< Encoded instruction as a 32-bit integer
    };

} // namespace zero_mate::coprocessor::cp10::isa
