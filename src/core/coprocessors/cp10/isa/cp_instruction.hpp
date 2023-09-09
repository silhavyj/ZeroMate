// ---------------------------------------------------------------------------------------------------------------------
/// \file cp_instruction.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a general CP10 instruction.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <cstdint>
/// \endcond

namespace zero_mate::coprocessor::cp10::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP_Instruction
    /// \brief This class represents a general CP10 instruction.
    // -----------------------------------------------------------------------------------------------------------------
    class CCP_Instruction
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TInstruction_Lookup_Record
        /// \brief A single row in the instruction type look-up table.
        /// \tparam Type Instruction type
        // -------------------------------------------------------------------------------------------------------------
        template<typename Type>
        struct TInstruction_Lookup_Record
        {
            std::uint32_t mask;     ///< Instruction mask (known bits)
            std::uint32_t expected; ///< Expected value after the mask is applied
            Type type;              ///< Corresponding instruction type
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Encoded instruction as 32-bit integer
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP_Instruction(std::uint32_t value) noexcept
        : m_value{ value }
        {
        }

    protected:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the instruction.
        /// \tparam Type Custom types of instructions (data processing, data transfer, etc.)
        /// \tparam Lookup_Table Type of the lookup table
        /// \param lookup_table Reference to the lookup table that will be used
        /// \return Type of the instruction
        // -------------------------------------------------------------------------------------------------------------
        template<typename Type, typename Lookup_Table>
        Type Get_Type(const Lookup_Table& lookup_table) const noexcept
        {
            for (const auto& [mask, expected, type] : lookup_table)
            {
                // Apply the mask to the instruction (32-bit value) and check if it matches the expected value.
                if ((m_value & mask) == expected)
                {
                    return type;
                }
            }

            // The type of the instruction could not be determined.
            return Type::Unknown;
        }

    protected:
        std::uint32_t m_value; ///< Encoded instruction as a 32-bit integer
    };

} // namespace zero_mate::coprocessor::cp10::isa