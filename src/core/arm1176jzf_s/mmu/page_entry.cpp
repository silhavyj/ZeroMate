// ---------------------------------------------------------------------------------------------------------------------
/// \file page_entry.cpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a page table entry.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "page_entry.hpp"

namespace zero_mate::arm1176jzf_s::mmu
{
    CPage_Entry::CPage_Entry()
    : m_value{ 0 }
    {
    }

    std::uint32_t CPage_Entry::Get_Value() const
    {
        return m_value;
    }

    CPage_Entry::NAccess_Type CPage_Entry::Get_Access_Type() const noexcept
    {
        return static_cast<NAccess_Type>(m_value & 0b11U);
    }

    bool CPage_Entry::Is_Flag_Set(NFlag flag) const noexcept
    {
        return static_cast<bool>(m_value & static_cast<std::uint32_t>(flag));
    }

    CPage_Entry::NAccess_Privileges CPage_Entry::Get_Access_Privileges() const noexcept
    {
        return static_cast<NAccess_Privileges>((m_value >> 10U) & 0b11U);
    }

    CPage_Entry::NAPX CPage_Entry::Get_NAPX() const noexcept
    {
        return static_cast<NAPX>(m_value >> 15U);
    }

} // namespace zero_mate::arm1176jzf_s::mmu