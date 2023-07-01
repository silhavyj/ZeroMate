// ---------------------------------------------------------------------------------------------------------------------
/// \file page_table.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a page table.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <cstdint>
/// \endcond

// Project file imports

#include "page_entry.hpp"

namespace zero_mate::arm1176jzf_s::mmu
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CPage_Table
    /// \brief This class represents a page table.
    // -----------------------------------------------------------------------------------------------------------------
    class CPage_Table final
    {
    public:
        /// Total number of page entries
        static constexpr std::size_t Entry_Count = 4096;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CPage_Table() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a page entry.
        /// \param idx Index of the page entry to be returned
        /// \return Page entry
        // -------------------------------------------------------------------------------------------------------------
        const CPage_Entry& operator[](std::uint32_t idx) const;

    private:
        std::array<CPage_Entry, Entry_Count> m_entries; ///< Page table entries
    };

} // namespace zero_mate::arm1176jzf_s::mmu