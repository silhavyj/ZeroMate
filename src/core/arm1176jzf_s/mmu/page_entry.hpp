// ---------------------------------------------------------------------------------------------------------------------
/// \file page_entry.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a page table entry.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::arm1176jzf_s::mmu
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CPage_Entry
    /// \brief This class represents a single page table entry.
    // -----------------------------------------------------------------------------------------------------------------
    class CPage_Entry final
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NAccess_Type
        /// \brief Enumeration of different page access types.
        // -------------------------------------------------------------------------------------------------------------
        enum class NAccess_Type : std::uint32_t
        {
            Translation_Fault = 0b00U, ///< Page is not present (page fault)
            Page_Base_Addr = 0b01U,    ///< Page holds an address to a second level page table
            Section_Addr = 0b10U       ///< Page holds an address of a frame (physical address)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NFlag
        /// \brief Enumeration of different flags of a page table entry.
        // -------------------------------------------------------------------------------------------------------------
        enum class NFlag : std::uint32_t
        {
            Cacheable = 0b1U << 2U, ///< Page can be cached
            Bufferable = 0b1U << 3U ///< Writes can be buffered
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NAccess_Privileges
        /// \brief Enumeration of different page access privileges.
        // -------------------------------------------------------------------------------------------------------------
        enum class NAccess_Privileges : std::uint32_t
        {
            None = 0b00U,         ///< No access is permitted
            RW_User_None = 0b01U, ///< Privileged mode: RW, user mode: None
            RW_User_R = 0b10U,    ///< Privileged mode: RW, user mode: Read
            Full_RW = 0b11U       ///< Anyone can access the page for both reading and writing
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NAPX
        /// \brief Enumeration of privileged mode page access restrictions.
        // -------------------------------------------------------------------------------------------------------------
        enum class NAPX : std::uint32_t
        {
            RW = 0b0U, ///< Page is RW
            R = 0b1U   ///< Page is R-only
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CPage_Entry();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the raw value of the page.
        /// \return Page value
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Value() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the page access type.
        /// \return Access type
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NAccess_Type Get_Access_Type() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if a given flag is set or not.
        /// \param flag Flag to be checked
        /// \return true, if the flag is set. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns page access privileges.
        /// \return Page access privileges
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NAccess_Privileges Get_Access_Privileges() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns privileged mode page access restrictions (R/RW).
        /// \return Privileged mode page access restrictions
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NAPX Get_NAPX() const noexcept;

    private:
        std::uint32_t m_value; ///< Value
    };

} // namespace zero_mate::arm1176jzf_s::mmu