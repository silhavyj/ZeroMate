// ---------------------------------------------------------------------------------------------------------------------
/// \file cp15.hpp
/// \date 29. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines CP15 (system control coprocessor).
///
/// To find more information about the coprocessor, please visit
/// https://developer.arm.com/documentation/ddi0290/g/system-control-coprocessor/about-control-coprocessor-cp15
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <vector>
#include <unordered_map>
/// \endcond

// Project file imports

#include "coprocessor.hpp"
#include "../utils/logger/logger.hpp"

namespace zero_mate::coprocessor
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP15
    /// \brief This class represents the system control coprocessor
    // -----------------------------------------------------------------------------------------------------------------
    class CCP15 final : public ICoprocessor
    {
    public:
        /// ID of the coprocessor
        static constexpr std::uint32_t ID = 15;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NPrimary_Register
        /// \brief This enumeration represents the primary registers of CP15.
        // -------------------------------------------------------------------------------------------------------------
        enum class NPrimary_Register : std::uint32_t
        {
            C0 = 0, ///< Opcode_1 = 0
            C1 = 1  ///< Opcode_1 = 1
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NC1_Register
        /// \brief This enumeration represents registers of the C1 primary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NC1_Register : std::uint32_t
        {
            Control = 0,                ///< Opcode_2 = 0 (control register)
            Auxiliary_Control,          ///< Opcode_2 = 1 (auxiliary register)
            Coprocessor_Access_Control, ///< Opcode_2 = 2 (coprocessor access register)
            Count                       ///< Count (helper enumeration record)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NC1_Control_Flags
        /// \brief This enumeration defines different flags in the C1 Control register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NC1_Control_Flags : std::uint32_t
        {
            U = 0b1U << 22U ///< Enable/disable unaligned memory access
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu_context Reference to the CPU context, so it can transfer values to/from the CPU registers.
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP15(arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor register transfer instruction (ICoprocessor interface).
        /// \param instruction Coprocessor register transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor data transfer instruction (ICoprocessor interface).
        /// \param instruction Coprocessor data transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor data operation instruction (ICoprocessor interface).
        /// \param instruction Coprocessor data operation instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information whether or not the CPU should permit unaligned memory access
        /// \return true, if the CPU should check memory access alignment. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Unaligned_Access_Permitted() const;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the coprocessor (sets default settings).
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if a flag in the C1 control register is set or not.
        /// \param flag Flag to be checked
        /// \return true, if the flag is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_C1_Control_Flag_Set(NC1_Control_Flags flag) const;

    private:
        std::unordered_map<NPrimary_Register, std::vector<std::uint32_t>> m_regs; ///< Coprocessor registers
        utils::CLogging_System& m_logging_system;                                 ///< Logging system
    };

} // namespace zero_mate::coprocessor