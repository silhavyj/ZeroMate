#include <algorithm>

#include "bus.hpp"

namespace zero_mate
{
    bool CBus::TMapped_Peripheral::operator<(const TMapped_Peripheral& other) const noexcept
    {
        return start_addr < other.start_addr;
    }

    CBus::NStatus CBus::Attach_Peripheral(std::uint32_t addr, const Peripheral_t& peripheral)
    {
        const std::uint64_t last_peripheral_address = static_cast<std::uint64_t>(addr) + peripheral->Get_Size();
        const auto last_address = static_cast<std::uint64_t>(std::numeric_limits<std::uint32_t>::max());

        if (last_peripheral_address >= last_address)
        {
            return NStatus::Out_Of_Addr_Space;
        }

        if (!m_peripherals.empty())
        {
            auto peripheral_iter = Get_Peripheral(addr);

            if ((peripheral_iter->start_addr + peripheral_iter->peripheral->Get_Size()) > addr)
            {
                return NStatus::Addr_Collision; // with the previous peripheral
            }

            ++peripheral_iter;

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