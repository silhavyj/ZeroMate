// ---------------------------------------------------------------------------------------------------------------------
/// \file c1.hpp
/// \date 25. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the primary register C1 of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "primary_reg.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::coprocessor::cp15
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CC1
    /// \brief This class represents primary register C1 of coprocessor CP15
    // -----------------------------------------------------------------------------------------------------------------
    class CC1 final : public IPrimary_Reg
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm
        /// \brief Enumeration of secondary registers of the C1 primary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm : std::uint32_t
        {
            C0 = 0, ///< CRm = 0
            C1 = 1  ///< CRm = 1
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C0_Register
        /// \brief Enumeration of the registers of the NCRm::C0 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C0_Register : std::uint32_t
        {
            Control = 0,                   ///< Control register (enable MMU, unaligned access, etc.)
            Auxiliary_Control = 1,         ///< Auxiliary control
            Coprocessor_Access_Control = 2 ///< Coprocessor access control
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C1_Register
        /// \brief Enumeration of the registers of the NCRm::C1 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C1_Register : std::uint32_t
        {
            Secure_Configuration = 0,     ///< Secure configuration
            Secure_Debug_Enable = 1,      ///< Secure debug enable
            Non_Secure_Access_Control = 2 ///< Non-secure access control
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NC0_Control_Flags
        /// \brief Enumeration of different flags that can be found in the NCRm_C0_Register::Control register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NC0_Control_Flags : std::uint32_t
        {
            MMU_Enable = 0b1U << 0U,                      ///< Enables MMU
            Data_Cache_Enable = 0b1U << 2U,               ///< Enable/disable data cache
            Branch_Prediction_Enable = 0b1U << 11U,       ///< Enable/disable branch prediction
            Instruction_Cache_Enable = 0b1U << 12U,       ///< Enable/disable instruction cache
            High_Exception_Vectors = 0b1U << 13U,         ///< IVT is located at 0xFFFF0000
            Unaligned_Memory_Access_Enable = 0b1U << 22U, ///< Enable/disable unaligned memory access
            TEX_Remap_Enable = 0b1U << 28U                ///< Enable/disable remapping of the TEX bit
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        ///
        /// All secondary registers (CC1::NCRm) get initialized upon object construction.
        // -------------------------------------------------------------------------------------------------------------
        CC1();

        // -------------------------------------------------------------------------------------------------------------
        /// Returns information about whether a given control flag is set or not.
        /// \param flag Flag to be checked
        /// \return true, if the flag is set. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Control_Flag_Set(NC0_Control_Flags flag) const;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C0.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R0();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C1.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R1();
    };

} // namespace zero_mate::coprocessor::cp15