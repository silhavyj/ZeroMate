#pragma once

#include <bit>
#include <set>
#include <mutex>
#include <limits>
#include <cstdint>
#include <memory>

#include "coprocessors/cp15.hpp"
#include "peripherals/peripheral.hpp"
#include "arm1176jzf_s/exceptions.hpp"

namespace zero_mate
{
    class CBus final
    {
    public:
        using Peripheral_t = std::shared_ptr<peripheral::IPeripheral>;

        enum class NStatus
        {
            OK,
            Addr_Collision,
            Out_Of_Addr_Space
        };

    private:
        struct TMapped_Peripheral
        {
            std::uint32_t start_addr;
            Peripheral_t peripheral;

            [[nodiscard]] bool operator<(const TMapped_Peripheral& other) const noexcept;
        };

        using Peripherals_t = std::set<TMapped_Peripheral>;

    public:
        CBus();

        void Set_CP15(std::shared_ptr<coprocessor::CCP15> cp15);

        // NOTE: The bus width size is usually fixed.
        // The generic type is supported only for emulation purposes (simplifications)
        template<typename Type>
        void Write(std::uint32_t addr, Type value)
        {
            const std::lock_guard<std::mutex> lock(m_mtx);

            auto peripheral_iter = Get_Peripheral<Type>(addr);
            const auto relative_addr = addr - peripheral_iter->start_addr;

            peripheral_iter->peripheral->Write(relative_addr, std::bit_cast<const char*>(&value), sizeof(Type));
        }

        // NOTE: The bus width size is usually fixed.
        // The generic type is supported only for emulation purposes (simplifications)
        template<typename Type>
        [[nodiscard]] Type Read(std::uint32_t addr)
        {
            const std::lock_guard<std::mutex> lock(m_mtx);

            Type value{};
            auto peripheral_iter = Get_Peripheral<Type>(addr);
            const auto relative_addr = addr - peripheral_iter->start_addr;

            peripheral_iter->peripheral->Read(relative_addr, std::bit_cast<char*>(&value), sizeof(Type));

            return value;
        }

        [[nodiscard]] NStatus Attach_Peripheral(std::uint32_t addr, const Peripheral_t& peripheral);

    private:
        template<typename Type>
        [[nodiscard]] inline bool Unaligned_Access_Violation(std::uint32_t addr) const
        {
            return m_cp15 != nullptr && !m_cp15->Is_Unaligned_Access_Permitted() && (addr % sizeof(Type)) != 0;
        }

        template<typename Type>
        [[nodiscard]] Peripherals_t::iterator Get_Peripheral(std::uint32_t addr) const
        {
            if (Unaligned_Access_Violation<Type>(addr))
            {
                throw arm1176jzf_s::exceptions::CData_Abort{ addr, "Unaligned memory access" };
            }

            auto peripheral_iter = Get_Peripheral(addr);
            if (!Is_Peripheral_Accessible(addr, peripheral_iter))
            {
                throw arm1176jzf_s::exceptions::CData_Abort{ addr, "No peripheral is mapped to this region" };
            }

            return peripheral_iter;
        }

        [[nodiscard]] bool Is_Peripheral_Accessible(std::uint32_t addr, const Peripherals_t::iterator& peripheral_iter) const
        {
            if (peripheral_iter == m_peripherals.end())
            {
                return false;
            }
            if ((peripheral_iter->start_addr + peripheral_iter->peripheral->Get_Size()) <= addr)
            {
                return false;
            }

            return true;
        }

        [[nodiscard]] Peripherals_t::iterator Get_Peripheral(std::uint32_t addr) const
        {
            auto peripheral_iter = std::lower_bound(m_peripherals.begin(),
                                                    m_peripherals.end(),
                                                    addr,
                                                    [&](const auto& peripheral, std::uint32_t addr_cmp) -> bool {
                                                        return peripheral.start_addr < addr_cmp;
                                                    });

            if (peripheral_iter != m_peripherals.end() && peripheral_iter->start_addr == addr)
            {
                return peripheral_iter;
            }

            if (peripheral_iter != m_peripherals.begin())
            {
                --peripheral_iter;
            }

            return peripheral_iter;
        }

    private:
        Peripherals_t m_peripherals;
        std::mutex m_mtx;
        std::shared_ptr<coprocessor::CCP15> m_cp15;
    };
}