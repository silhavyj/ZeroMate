// ---------------------------------------------------------------------------------------------------------------------
/// \file mmu.hpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the MMU (memory management unit) of the CPU
///
/// Its sole purpose to perform address translations prior to each memory access executed by the CPU.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <memory>
#include <unordered_map>
/// \endcond

// Project file imports

#include "../../bus.hpp"
#include "page_table.hpp"
#include "../context.hpp"
#include "../../coprocessors/cp15/cp15.hpp"

namespace zero_mate::arm1176jzf_s::mmu
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CMMU
    /// \brief This class represents a memory management unit (MMU).
    // -----------------------------------------------------------------------------------------------------------------
    class CMMU final
    {
    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \struct TPage_Table_Record
        /// \brief Helper structure that is used when accessing different memory pages.
        // -------------------------------------------------------------------------------------------------------------
        struct TPage_Table_Record
        {
            CPage_Entry page{};            ///< Page that is being accessed
            std::uint32_t physical_addr{}; ///< Physical address that is being accessed (page addr + offset)
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param bus Bus through which a page table can be accessed (fetched when it is needed)
        /// \param cp15 Reference to coprocessor CP15 (to access tbbr0, invalidate TLB, etc.)
        // -------------------------------------------------------------------------------------------------------------
        explicit CMMU(std::shared_ptr<CBus> bus, std::shared_ptr<coprocessor::cp15::CCP15> cp15);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether the MMU is enabled or not.
        /// \return true, if the MMU is enabled. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Enabled() noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Converts a given virtual address into a physical address.
        /// \note If the page access does not meet the requirements, exceptions::CCPU_Exception is thrown.
        /// \param virtual_addr Virtual address issued by the CPU
        /// \param cpu_context Context of the CPU (CPU mode to verify access privileges)
        /// \param write_access Read/Write access to the virtual address
        /// \return Physical address
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t
        Get_Physical_Addr(std::uint32_t virtual_addr, const CCPU_Context& cpu_context, bool write_access);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the MMU.
        // -------------------------------------------------------------------------------------------------------------
        void Reset();

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Fetches the first level page tables (tbbr0, tbbr1) from the RAM.
        ///
        /// This function is called whenever either the tbbr0 or tbbr1 register changes.
        // -------------------------------------------------------------------------------------------------------------
        inline void Fetch_DL1_From_RAM();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Retrieves a given page from a page table by a given virtual address.
        /// \param page_table Page table used for address translation
        /// \param virtual_addr Virtual address used to retrieve the corresponding page from the page table
        /// \return Page retrieved from the page table as well as the physical address (virtual address translation)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline TPage_Table_Record Get_Page_Table_Record(CPage_Table& page_table,
                                                                      std::uint32_t virtual_addr) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Verifies access privileges when accessing a page (virtual address).
        /// \note If the page access does not meet the requirements, exceptions::CCPU_Exception is thrown.
        /// \param page Page that is being accessed
        /// \param virtual_addr Virtual address used to access the page
        /// \param cpu_context
        /// \param write_access Read/Write acCPU context to retrieve the current CPU modecess to the page
        // -------------------------------------------------------------------------------------------------------------
        static inline void Verify_Access_Privileges(const CPage_Entry& page,
                                                    std::uint32_t virtual_addr,
                                                    const CCPU_Context& cpu_context,
                                                    bool write_access);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Verifies the access type.
        ///
        /// This function checks if the page is present in RAM, whether it refers to a second level page table, etc.
        ///
        /// \note If the page is not present in the RAM, exceptions::CCPU_Exception is thrown.
        /// \param page Page that is being accessed
        /// \param virtual_add Virtual address used to access the page
        /// \param write_access Read/Write access to the page
        // -------------------------------------------------------------------------------------------------------------
        static inline void Verify_Access_Type(const CPage_Entry& page, std::uint32_t virtual_add, bool write_access);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Verifies page access (calls a chain of functions that validate the access).
        /// \param page  Page that is being accessed
        /// \param virtual_addr Virtual address used to access the page
        /// \param cpu_context CPU context to retrieve the current CPU mode
        /// \param write_access Read/Write access to the page
        // -------------------------------------------------------------------------------------------------------------
        inline void Verify_Access(const CPage_Entry& page,
                                  std::uint32_t virtual_addr,
                                  const CCPU_Context& cpu_context,
                                  bool write_access);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the TLB entries should be invalidated and if so, it clears the cache.
        ///
        /// It does it by checking the flag in the c8, c7, 0 register of coprocessor CP15.
        // -------------------------------------------------------------------------------------------------------------
        void Flush_TLB_If_Needed();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the page table that will be used for address translation (boundary register C2 C0 2).
        /// \param virtual_addr Virtual address issued by the CPU (we need to determine what page table will be used)
        /// \return Page table to be used for address translation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CPage_Table& Get_Page_Table(std::uint32_t virtual_addr);

    private:
        std::shared_ptr<CBus> m_bus;                                  ///< Bus
        std::shared_ptr<coprocessor::cp15::CCP15> m_cp15;             ///< Coprocessor CP15
        std::uint32_t m_TTBR0_addr;                                   ///< Address of page table 0
        CPage_Table m_page_table_0;                                   ///< Page table 0
        std::uint32_t m_TTBR1_addr;                                   ///< Address of page table 1
        CPage_Table m_page_table_1;                                   ///< Page table 1
        std::unordered_map<std::uint32_t, std::uint32_t> m_TLB_cache; ///< TLB cache
    };

} // namespace zero_mate::arm1176jzf_s::mmu