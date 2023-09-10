// ---------------------------------------------------------------------------------------------------------------------
/// \file vmov_arm_register_single_precision_register.hpp
/// \date 10. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a VMOV instruction between an ARM register and an FPU register.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CVMOV_ARM_Register_Single_Precision_Register
    /// \brief This class presents a VMOV instruction (ARM <-> FPU).
    // -----------------------------------------------------------------------------------------------------------------
    class CVMOV_ARM_Register_Single_Precision_Register final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as a 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CVMOV_ARM_Register_Single_Precision_Register(std::uint32_t value) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a register should be moved from the FPU to ARM or vice versa.
        /// \return true, if the register should be moved from the FPU to ARM. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool To_ARM_Register() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of an FPU register encoded in the instruction.
        /// \return Index of an FPU register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vn_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the index of an ARM register encoded in the instruction.
        /// \return Index of an ARM register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Rt_Idx() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the offset of the Vn register (S{x} vs D{x}).
        /// \return Offset of the Vn register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Vn_Offset() const noexcept;

    private:
        std::uint32_t m_value; ///< Encoded instruction as a 32-bit integer
    };

} // namespace zero_mate::coprocessor::cp10::isa