// ---------------------------------------------------------------------------------------------------------------------
/// \file page_table.cpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a page table.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "page_table.hpp"

namespace zero_mate::arm1176jzf_s::mmu
{
    const CPage_Entry& CPage_Table::operator[](std::uint32_t idx) const
    {
        return m_entries.at(idx);
    }

} // namespace zero_mate::arm1176jzf_s::mmu