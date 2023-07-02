// ---------------------------------------------------------------------------------------------------------------------
/// \file mmu.cpp
/// \date 01. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the MMU (memory management unit) of the CPU
///
/// Its sole purpose to perform address translations prior to each memory access executed by the CPU.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
/// \endcond

// Project file imports

#include "mmu.hpp"

namespace zero_mate::arm1176jzf_s::mmu
{
    CMMU::CMMU(std::shared_ptr<CBus> bus, std::shared_ptr<coprocessor::cp15::CCP15> cp15)
    : m_bus{ bus }
    , m_cp15{ cp15 }
    , m_TTBR0_addr{ 0 }
    , m_TTBR1_addr{ 0 }
    {
    }

    void CMMU::Reset()
    {
        // If paging is enabled, the page tables will be fetched from
        // the actual addresses upon the next read/write.
        m_TTBR0_addr = 0;
        m_TTBR1_addr = 0;

        // Clear the TLB cache
        m_TLB_cache.clear();
    }

    bool CMMU::Is_Enabled() noexcept
    {
        // Get the control register of CP15.
        const auto cp15_c1 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC1>(coprocessor::cp15::NPrimary_Register::C1);

        // Check if MMU is enabled.
        return cp15_c1->Is_Control_Flag_Set(coprocessor::cp15::CC1::NC0_Control_Flags::MMU_Enable);
    }

    void CMMU::Fetch_DL1_From_RAM()
    {
        // Base address of translation tables are stored in the CP15's C2 register.
        const auto cp15_c2 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC2>(coprocessor::cp15::NPrimary_Register::C2);

        // Retrieve the current address of page table 0.
        const std::uint32_t tbbr0_addr =
        cp15_c2->Get_TTB_Address(coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_0);

        // Check if it needs to updated (fetched from the RAM).
        if (tbbr0_addr != m_TTBR0_addr)
        {
            m_TTBR0_addr = tbbr0_addr;
            m_page_table_0 = m_bus->Read<CPage_Table>(m_TTBR0_addr);
        }

        // Retrieve the current address of page table 1.
        const std::uint32_t tbbr1_addr =
        cp15_c2->Get_TTB_Address(coprocessor::cp15::CC2::NCRm_C0_Register::Translation_Table_Base_1);

        // Check if it needs to updated (fetched from the RAM).
        if (tbbr1_addr != m_TTBR1_addr)
        {
            m_TTBR0_addr = tbbr1_addr;
            m_page_table_1 = m_bus->Read<CPage_Table>(m_TTBR1_addr);
        }
    }

    CMMU::TPage_Table_Record CMMU::Get_Page_Table_Record(CPage_Table& page_table, std::uint32_t virtual_addr) const
    {
        // The fist 20 bits represent an index to page table (the rest if the offset) within the page itself.
        static constexpr std::uint32_t Page_Offset_Mask = 0xFFFFFU;
        static constexpr std::uint32_t Page_Offset_Bit_Count = std::popcount(Page_Offset_Mask);

        // Page offset.
        const std::uint32_t page_offset = virtual_addr & Page_Offset_Mask;

        // Retrieve the corresponding page from the page table;
        const CPage_Entry page = page_table[virtual_addr >> Page_Offset_Bit_Count];

        // Calculate the physical address.
        std::uint32_t physical_addr = page.Get_Value();
        physical_addr &= (~Page_Offset_Mask);
        physical_addr |= page_offset;

        return { .page = page, .physical_addr = physical_addr };
    }

    void CMMU::Verify_Access_Privileges(const CPage_Entry& page,
                                        std::uint32_t virtual_add,
                                        const CCPU_Context& cpu_context,
                                        bool write_access)
    {
        switch (page.Get_Access_Privileges())
        {
            // No access should be performed.
            case CPage_Entry::NAccess_Privileges::None:
                throw exceptions::CData_Abort{ virtual_add, "Page access violation (None Access)" };
                break;

            // Privileged mode: RW, user mode None.
            case CPage_Entry::NAccess_Privileges::RW_User_None:
                if (!cpu_context.Is_In_Privileged_Mode())
                {
                    throw exceptions::CData_Abort{ virtual_add, "Page access violation (RW_User_None)" };
                }
                break;

            // Privileged mode: RW, user mode R.
            case CPage_Entry::NAccess_Privileges::RW_User_R:
                if (!cpu_context.Is_In_Privileged_Mode() && write_access)
                {
                    throw exceptions::CData_Abort{ virtual_add, "Page access violation (RW_User_R)" };
                }
                break;

            // Anyone can read/write to the page.
            case CPage_Entry::NAccess_Privileges::Full_RW:
                break;
        }

        // Check if there are any RW restrictions for a privileged mode.
        if (cpu_context.Is_In_Privileged_Mode() && page.Get_NAPX() == CPage_Entry::NAPX::R && write_access)
        {
            throw exceptions::CData_Abort{ virtual_add, "Page access violation (NAPX_RW)" };
        }
    }

    void CMMU::Verify_Access_Type(const CPage_Entry& page, std::uint32_t virtual_add, bool write_access)
    {
        switch (page.Get_Access_Type())
        {
            // The page is not present in the RAM.
            case CPage_Entry::NAccess_Type::Translation_Fault:
                if (write_access)
                {
                    throw exceptions::CData_Abort{ virtual_add, "Page fault" };
                }
                else
                {
                    throw exceptions::CPrefetch_Abort{ virtual_add, "Page fault" };
                }
                break;

            // TODO load a second level page table from RAM
            case CPage_Entry::NAccess_Type::Page_Base_Addr:
                break;

            // The page refers to a physical frame
            case CPage_Entry::NAccess_Type::Section_Addr:
                break;
        }
    }

    void CMMU::Verify_Access(const CPage_Entry& page,
                             std::uint32_t virtual_addr,
                             const CCPU_Context& cpu_context,
                             bool write_access)
    {
        Verify_Access_Type(page, virtual_addr, write_access);
        Verify_Access_Privileges(page, virtual_addr, cpu_context, write_access);
    }

    void CMMU::Flush_TLB_If_Needed()
    {
        // Get the C8 primary registers of CP15.
        auto cp15_c8 = m_cp15->Get_Primary_Register<coprocessor::cp15::CC8>(coprocessor::cp15::NPrimary_Register::C8);

        // Should the TLB be cleared?
        if (cp15_c8->Is_Invalidate_Unified_TLB_Unlocked_Entries_Set())
        {
            m_TLB_cache.clear();
            cp15_c8->TLB_Has_Been_Invalidated();
        }
    }

    CPage_Table& CMMU::Get_Page_Table(std::uint32_t virtual_addr)
    {
        // Get the C2 primary register.
        const auto cp15_c2 =
        m_cp15->Get_Primary_Register<coprocessor::cp15::CC2>(coprocessor::cp15::NPrimary_Register::C2);

        // TODO something to reason about
        // https://stackoverflow.com/questions/14460752/linux-kernel-arm-translation-table-base-ttb0-and-ttb1
        if ((cp15_c2->Get_Boundary() * (1 * 1024 * 1024 / 4)) > virtual_addr) [[unlikely]]
        {
            return m_page_table_1;
        }

        return m_page_table_0;
    }

    std::uint32_t
    CMMU::Get_Physical_Addr(std::uint32_t virtual_addr, const CCPU_Context& cpu_context, bool write_access)
    {
        // Check the TLB should be cleared.
        Flush_TLB_If_Needed();

        // Check if the page tables should be updated.
        Fetch_DL1_From_RAM();

        // TODO should Verify_Access be called here as well? The TTBR may have been changed without flushing the TLB
        // (security issue)
        // Check if the virtual address has already been cached.
        if (m_TLB_cache.contains(virtual_addr))
        {
            return m_TLB_cache.at(virtual_addr);
        }

        // Retrieve the corresponding page as well as the physical address.
        const auto [page, physical_addr] = Get_Page_Table_Record(Get_Page_Table(virtual_addr), virtual_addr);

        // Check no access rules have been violated
        Verify_Access(page, virtual_addr, cpu_context, write_access);

        // Store the address into the TLB.
        m_TLB_cache[virtual_addr] = physical_addr;

        // Return the physical address.
        return physical_addr;
    }

} // namespace zero_mate::arm1176jzf_s::mmu