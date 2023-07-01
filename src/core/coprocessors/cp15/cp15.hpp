// ---------------------------------------------------------------------------------------------------------------------
/// \file cp15.hpp
/// \date 26. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
#include <type_traits>
/// \endcond

// Project file imports

#include "c1.hpp"
#include "c2.hpp"
#include "c3.hpp"
#include "c7.hpp"
#include "c8.hpp"
#include "primary_reg.hpp"
#include "../coprocessor.hpp"
#include "zero_mate/utils/logger.hpp"

namespace zero_mate::coprocessor::cp15
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP15
    /// \brief This class represents coprocessor CP15
    // -----------------------------------------------------------------------------------------------------------------
    class CCP15 final : public ICoprocessor
    {
    public:
        /// Unique ID of the coprocessor.
        static constexpr std::uint32_t ID = 15;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu_context Reference to the CPU context, so it can transfer values to/from the CPU registers.
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP15(arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the coprocessor.
        // -------------------------------------------------------------------------------------------------------------
        void Reset() override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a primary register of a given type.
        ///
        /// All primary registers are held by this class as IPrimary_Reg, which they all inherit from. When the caller
        /// function wants the access a primary register of its actual type, it needs to pass the type as a template.
        ///
        /// \tparam Reg_Type Type of the primary register to be returned
        /// \param primary_reg Index of the primary register to be returned
        /// \return Primary register of CP15
        // -------------------------------------------------------------------------------------------------------------
        template<typename Reg_Type>
        [[nodiscard]] std::shared_ptr<const Reg_Type> Get_Primary_Register(NPrimary_Register primary_reg) const
        {
            // Make sure Reg_Type is derived from IPrimary_Reg.
            static_assert(std::is_base_of<IPrimary_Reg, Reg_Type>::value);

            // Return the primary register of a desired type.
            return std::static_pointer_cast<Reg_Type>(m_regs.at(static_cast<std::uint32_t>(primary_reg)));
        }

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

    private:
        std::unordered_map<std::uint32_t, std::shared_ptr<IPrimary_Reg>> m_regs; ///< Primary registers
        utils::CLogging_System& m_logging_system;                                ///< Logging system
    };

} // namespace zero_mate::coprocessor::cp15