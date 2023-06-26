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

// STL imports (excluded from Doxygen)
/// \cond
#include <vector>
/// \endcond

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
        /// Value to be returned when accessing a register that does not exist (has not been implemented yet)
        static constexpr auto Invalid_Reg_Value = static_cast<std::uint32_t>(0);

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
            MMU_Enable = 0b1U << 0U,                                  ///< Enables MMU
            Strict_Alignment_Enable = 0b1U << 1U,                     ///< Any memory access must be aligned to 4B
            Data_Cache_Enable = 0b1U << 2U,                           ///< Enable/disable data cache

            Big_Endian_Mem = 0b1U << 7U,                              ///< Switch between Little and Big endian

            Branch_Prediction_Enable = 0b1U << 11U,                   ///< Enable/disable branch prediction
            Instruction_Cache_Enable = 0b1U << 12U,                   ///< Enable/disable instruction cache
            High_Exception_Vectors = 0b1U << 13U,                     ///< IVT is located at 0xFFFF0000

            Low_Interrupt_Latency_Configuration_Enable = 0b1U << 21U, ///< Low latency for FIQ
            Unaligned_Memory_Access_Enable = 0b1U << 22U,             ///< Enable/disable unaligned memory access

            TEX_Remap_Enable = 0b1U << 28U                            ///< Enable/disable remapping of the TEX bit
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        ///
        /// All secondary registers (CC1::NCRm) get initialized upon object construction.
        // -------------------------------------------------------------------------------------------------------------
        CC1();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to the register addressed by a secondary register index and op2
        ///
        /// This function is implemented from the IPrimary_Reg interface.
        ///
        /// \note If the register does not exist or has not been implemented yet, an error message is printed out
        /// and a default value of Invalid_Reg_Value is returned.
        /// \param crm_idx Index of the secondary register CC1::NCRm
        /// \param op2 Index of the register of the secondary register (e.g. Control, AUX, etc.)
        /// \return Reference to the desired register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& Get_Reg(std::uint32_t crm_idx, std::uint32_t op2) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the register addressed by a secondary register index and op2
        ///
        /// /// This function is implemented from the IPrimary_Reg interface.
        ///
        /// \note If the register does not exist or has not been implemented yet, an error message is printed out
        /// and a default value of Invalid_Reg_Value is returned.
        /// \param crm_idx Index of the secondary register CC1::NCRm
        /// \param op2 Index of the register of the secondary register (e.g. Control, AUX, etc.)
        /// \return Const reference to the desired register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::uint32_t& Get_Reg(std::uint32_t crm_idx, std::uint32_t op2) const override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether unaligned access is permitted or not.
        /// \return true, if unaligned access is permitted. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Unaligned_Access_Permitted() const;

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

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a register addressed by a secondary register index and op2 exists or not.
        /// \param crm_idx Index of the secondary register CC1::NCRm
        /// \param op2 Index of the register of the secondary register (e.g. Control, AUX, etc.)
        /// \return true, if the register exists. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Register_Exists(std::uint32_t crm_idx, std::uint32_t op2) const;

    private:
        Registers_t m_regs;                       ///< Register hierarchy of the C1 primary register
        utils::CLogging_System& m_logging_system; ///< Logging system
        mutable std::uint32_t m_invalid_reg;      ///< Invalid register value (helper variable)
    };

} // namespace zero_mate::coprocessor::cp15