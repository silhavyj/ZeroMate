#include <algorithm>

#include "bus.hpp"

namespace zero_mate
{
    bool CBus::TMapped_Peripheral::operator<(const TMapped_Peripheral& other) const noexcept
    {
        return start_addr < other.start_addr;
    }

    int CBus::Attach_Peripheral(std::uint32_t addr, const Peripheral_t& peripheral)
    {
        if (!m_peripherals.empty())
        {
            auto peripheral_iter = Get_Peripheral(addr);

            if ((peripheral_iter->start_addr + peripheral_iter->peripheral->Get_Size()) > addr)
            {
                return 1;
            }

            ++peripheral_iter;

            if (peripheral_iter != m_peripherals.end())
            {
                if ((addr + peripheral->Get_Size()) > peripheral_iter->start_addr)
                {
                    return 1;
                }
            }
        }

        m_peripherals.insert({ addr, peripheral });
        return 0;
    }
}