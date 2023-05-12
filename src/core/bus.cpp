#include <algorithm>

#include "bus.hpp"

namespace zero_mate
{
    bool CBus::TMapped_Peripheral::operator<(const TMapped_Peripheral& other) const noexcept
    {
        return start_addr < other.start_addr;
    }

    CBus::CBus()
    : m_cp15{ nullptr }
    {
    }

    void CBus::Set_CP15(std::shared_ptr<coprocessor::CCP15> cp15)
    {
        m_cp15 = cp15;
    }

    CBus::NStatus CBus::Attach_Peripheral(std::uint32_t addr, const Peripheral_t& peripheral)
    {
        // Calculate the very last address the peripheral will occupy.
        const std::uint64_t last_peripheral_address = static_cast<std::uint64_t>(addr) + peripheral->Get_Size();

        // The very last address in the address space. It is stored as std::uint64_t, so we
        // can check for overflows within the address space.
        const auto last_address = static_cast<std::uint64_t>(std::numeric_limits<std::uint32_t>::max());

        // Make sure the peripheral does not "fall out of the accessible address space".
        if (last_peripheral_address >= last_address)
        {
            return NStatus::Out_Of_Addr_Space;
        }

        // If there is already at least one memory-mapped peripheral, we need to check for possible overlaps.
        if (!m_peripherals.empty())
        {
            auto peripheral_iter = Get_Peripheral(addr);

            // Check for an overlap with its previous (left) neighbor.
            if ((peripheral_iter->start_addr + peripheral_iter->peripheral->Get_Size()) > addr)
            {
                return NStatus::Addr_Collision; // with the previous peripheral
            }

            ++peripheral_iter;

            // Check for an overlap with its next (right) neighbor.
            if (peripheral_iter != m_peripherals.end())
            {
                if ((addr + peripheral->Get_Size()) > peripheral_iter->start_addr)
                {
                    return NStatus::Addr_Collision; // with the next peripheral
                }
            }
        }

        m_peripherals.insert({ addr, peripheral });

        return NStatus::OK;
    }
}