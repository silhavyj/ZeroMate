// ---------------------------------------------------------------------------------------------------------------------
/// \file isa_decoder.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an instruction decoder.
///
/// It takes a 32-bit value and returns an instruction type that matches the value.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <cstdint>
/// \endcond

// Project file imports

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CISA_Decoder
    /// \brief This class represents an instruction decoder
    ///
    /// It is used in core.cpp to decode individual instructions as they are fetched from the memory.
    // -----------------------------------------------------------------------------------------------------------------
    class CISA_Decoder
    {
    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TInstruction_Lookup_Record
        /// \brief This structure represents a single row in the instruction look-up table.
        // -------------------------------------------------------------------------------------------------------------
        struct TInstruction_Lookup_Record
        {
            std::uint32_t mask;       ///< Instruction mask to mask out varying (unknown) bits
            std::uint32_t expected;   ///< Expected value of after the mask has been applied
            CInstruction::NType type; ///< Corresponding instruction type
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        ///
        /// Upon construction, it sorts out the look-up table from the most restrictive mask to the least
        /// restrictive masks.
        // -------------------------------------------------------------------------------------------------------------
        CISA_Decoder() noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Looks up an instruction type in the instruction look-up table.
        ///
        /// The look-up time of this function is O(n) as it iterates row by row through the look-up table.
        ///
        /// \param instruction 32-bit value representing an encoded instruction
        /// \return Corresponding instruction type
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static CInstruction::NType Get_Instruction_Type(CInstruction instruction) noexcept;

    private:
        /// \brief Total number of rows in the look-up table (number of different instruction masks).
        static constexpr std::size_t Instruction_Masks_Count = 25;

        /// \brief Instruction look-up table made up of CISA_Decoder::TInstruction_Lookup_Record.
        /// \note The table is not cost on purpose as it gets sorted in the constructor.
        static std::array<TInstruction_Lookup_Record, Instruction_Masks_Count> s_instruction_lookup_table;
    };

} // namespace zero_mate::arm1176jzf_s::isa
