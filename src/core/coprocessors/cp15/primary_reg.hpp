// ---------------------------------------------------------------------------------------------------------------------
/// \file primary_reg.hpp
/// \date 26. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a primary register interface of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
#include <unordered_map>
/// \endcond

namespace zero_mate::coprocessor::cp15
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \enum NPrimary_Register
    /// \brief Lists out all primary registers that are supported/implemented by the emulator.
    // -----------------------------------------------------------------------------------------------------------------
    enum class NPrimary_Register : std::uint32_t
    {
        C1 = 1 ///< C1 primary register
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class IPrimary_Reg
    /// \brief This interface defines common functionality of every primary register of coprocessor CP15.
    // -----------------------------------------------------------------------------------------------------------------
    class IPrimary_Reg
    {
    public:
        /// Alias for the structure of the register of the primary register (just to make the code less wordy).
        using Registers_t = std::unordered_map<std::uint32_t, std::unordered_map<std::uint32_t, std::uint32_t>>;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        IPrimary_Reg() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~IPrimary_Reg() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IPrimary_Reg(const IPrimary_Reg&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IPrimary_Reg& operator=(const IPrimary_Reg&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IPrimary_Reg(IPrimary_Reg&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IPrimary_Reg& operator=(IPrimary_Reg&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to the register addressed by a secondary register index and op2
        /// \note If the register does not exist or has not been implemented yet, an error message is printed out
        /// and a default value of Invalid_Reg_Value is returned.
        /// \param crm_idx Index of the secondary register
        /// \param op2 Index of the register of the secondary register (e.g. Control, AUX, etc.)
        /// \return Reference to the desired register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] virtual std::uint32_t& Get_Reg(std::uint32_t crm_idx, std::uint32_t op2) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns const a reference to the register addressed by a secondary register index and op2
        /// \note If the register does not exist or has not been implemented yet, an error message is printed out
        /// and a default value of Invalid_Reg_Value is returned.
        /// \param crm_idx Index of the secondary register
        /// \param op2 Index of the register of the secondary register (e.g. Control, AUX, etc.)
        /// \return Const reference to the desired register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] virtual const std::uint32_t& Get_Reg(std::uint32_t crm_idx, std::uint32_t op2) const = 0;

    protected:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a flag is set in a given register
        /// \param reg Value store in the register
        /// \param flag Flag to be checked
        /// \return true, if the flag is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static bool Is_Flag_Set(std::uint32_t reg, std::uint32_t flag);
    };

} // namespace zero_mate::coprocessor::cp15