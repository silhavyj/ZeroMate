// =====================================================================================================================
/// \file bus.hpp
/// \date 12. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an interface the CPU uses to access different memory-mapped peripherals.
// =====================================================================================================================

#pragma once

// STL imports
/// \cond
#include <bit>
#include <set>
#include <mutex>
#include <limits>
#include <memory>
#include <cstdint>
/// \endcond

// Project file imports

#include "coprocessors/cp15.hpp"
#include "peripherals/peripheral.hpp"
#include "arm1176jzf_s/exceptions.hpp"

namespace zero_mate
{
    // =================================================================================================================
    /// \class CBus
    /// \brief An interface the CPU uses to communicate with different peripherals.
    ///
    /// It holds a list of all peripherals that have been mapped to the address space.
    /// When the CPU wants to talk to a peripheral, it must know the address the peripheral
    /// is mapped to. The CBus class then forwards the data to the corresponding peripheral
    /// based on this address.
    // =================================================================================================================
    class CBus final
    {
    public:
        /// This is just a simplification to make the code less wordy.
        using Peripheral_t = std::shared_ptr<peripheral::IPeripheral>;

        // =============================================================================================================
        /// \enum NStatus
        /// \brief Return code (status) of mapping a peripheral to the address space
        // =============================================================================================================
        enum class NStatus
        {
            OK,               ///< The peripherals has been mapped successfully
            Addr_Collision,   ///< Another peripheral is already mapped to this region
            Out_Of_Addr_Space ///< The peripheral does not fit into the address space
        };

    private:
        // =============================================================================================================
        /// \struct TMapped_Peripheral
        /// \brief Representation of a memory-mapped peripheral
        // =============================================================================================================
        struct TMapped_Peripheral
        {
            std::uint32_t start_addr; ///< The starting address of the peripheral
            Peripheral_t peripheral;  ///< The peripheral itself

            // =========================================================================================================
            /// Compares two memory-mapped peripherals by their addresses
            ///
            /// This operator needs to be overloaded, so a binary search can be
            /// used to figure out what peripheral is being targeted.
            ///
            /// \param other Peripheral this peripheral is being compared to
            /// \return true, if this peripheral is mapped to a lower address than the
            ///         other peripheral. false otherwise.
            // =========================================================================================================
            [[nodiscard]] bool operator<(const TMapped_Peripheral& other) const noexcept;
        };

        /// This is just a simplification to make the code less wordy
        using Peripherals_t = std::set<TMapped_Peripheral>;

    public:
        // =============================================================================================================
        /// \brief Creates an instance of the class.
        // =============================================================================================================
        CBus();

        // =============================================================================================================
        /// \brief Sets a reference to CP15 (coprocessor 15).
        ///
        /// The bus needs to have access to this coprocessor to determine whether it should check for unaligned
        /// memory accesses or not.
        ///
        /// \param cp15 Instance of CP15
        // =============================================================================================================
        void Set_CP15(std::shared_ptr<coprocessor::CCP15> cp15);

        // =============================================================================================================
        /// \brief Writes data to the given address in the address space.
        /// \note The bus width size is usually fixed. The generic type is supported only for emulation purposes
        /// \tparam Type Data type used when calling the function (determines the number of bytes to be written)
        /// \param addr Address the data will be written to
        /// \param value The data itself
        // =============================================================================================================
        template<typename Type>
        void Write(std::uint32_t addr, Type value)
        {
            // Make calling of the function thread-safe.
            const std::lock_guard<std::mutex> lock(m_mtx);

            // Figure out what peripheral is being targeted based on the given address.
            auto peripheral_iter = Get_Peripheral<Type>(addr);

            // Calculate the relative address (the peripheral does not have any information
            // about its location in the address space).
            const auto relative_addr = addr - peripheral_iter->start_addr;

            // Write the data to the peripheral.
            peripheral_iter->peripheral->Write(relative_addr, std::bit_cast<const char*>(&value), sizeof(Type));
        }

        // =============================================================================================================
        /// \brief Reads data from the given address in the address space.
        /// \note The bus width size is usually fixed. The generic type is supported only for emulation purposes
        /// \tparam Type Data type used when calling the function (determines the number of bytes to be read)
        /// \param addr Address the data will be read from
        /// \return Data read from the given address
        // =============================================================================================================
        template<typename Type>
        [[nodiscard]] Type Read(std::uint32_t addr)
        {
            // Make calling of the function thread-safe.
            const std::lock_guard<std::mutex> lock(m_mtx);

            // Retrieve the peripheral based on the given address.
            auto peripheral_iter = Get_Peripheral<Type>(addr);
            const auto relative_addr = addr - peripheral_iter->start_addr;

            // Read the data from the peripheral.
            Type value{};
            peripheral_iter->peripheral->Read(relative_addr, std::bit_cast<char*>(&value), sizeof(Type));

            return value;
        }

        // =============================================================================================================
        /// \brief Attaches a peripheral to the bus.
        /// \param addr Address the peripheral should be mapped to
        /// \param peripheral The peripheral itself
        /// \return NStatus code indication whether the peripheral has been mapped successfully or not
        // =============================================================================================================
        [[nodiscard]] NStatus Attach_Peripheral(std::uint32_t addr, const Peripheral_t& peripheral);

    private:
        // =============================================================================================================
        /// \brief Checks for unaligned memory access.
        ///
        /// If the coprocessor 15 is not present, the function will ignore any unaligned memory access.
        /// If CP15 is present, it will check if unaligned access has been permitted and validates the
        /// access accordingly.
        ///
        /// \tparam Type Data type used in the memory access
        /// \param addr Address to be read from or written to
        /// \return true, if unaligned access takes place. false, otherwise.
        // =============================================================================================================
        template<typename Type>
        [[nodiscard]] inline bool Unaligned_Access_Violation(std::uint32_t addr) const
        {
            return m_cp15 != nullptr && !m_cp15->Is_Unaligned_Access_Permitted() && (addr % sizeof(Type)) != 0;
        }

        // =============================================================================================================
        /// \brief Returns the corresponding peripheral based on the given address.
        ///
        /// It searches for a peripheral mapped to the region determined by the given address. It also checks
        /// memory access alignment, if enabled in CP15.
        ///
        /// \tparam Type Data type used when writing or reading from the address space
        /// \param addr Relative address to be read from or written to
        /// \return Corresponding peripheral mapped to the region determined by the given address
        /// \throws CData_Abort if unaligned memory access is detected or no peripheral was mapped into the
        ///         given region
        // =============================================================================================================
        template<typename Type>
        [[nodiscard]] Peripherals_t::iterator Get_Peripheral(std::uint32_t addr) const
        {
            // Check for unaligned memory access.
            if (Unaligned_Access_Violation<Type>(addr))
            {
                throw arm1176jzf_s::exceptions::CData_Abort{ addr, "Unaligned memory access" };
            }

            // Search for a peripheral mapped to the given region.
            auto peripheral_iter = Get_Peripheral(addr);
            if (!Is_Peripheral_Accessible(addr, peripheral_iter))
            {
                throw arm1176jzf_s::exceptions::CData_Abort{ addr, "No peripheral is mapped to this region" };
            }

            return peripheral_iter;
        }

        // =============================================================================================================
        /// \brief Checks if a peripheral was found and is accessible.
        ///
        /// It checks whether there is a peripheral mapped to the given region in the address space.
        /// If a peripheral was found, it also checks if the given address exceeds the size of the peripheral
        /// or not.
        ///
        /// \param addr Relative address used to access the peripheral
        /// \param peripheral_iter Peripheral iterator from a previously applied binary search
        /// \return true if an accessible peripheral was found in the given region. false otherwise.
        // =============================================================================================================
        [[nodiscard]] inline bool Is_Peripheral_Accessible(std::uint32_t addr,
                                                           const Peripherals_t::iterator& peripheral_iter) const
        {
            // Make sure the peripheral exists.
            if (peripheral_iter == m_peripherals.end())
            {
                return false;
            }

            // Make sure the address does not exceed the size of the peripheral.
            if ((peripheral_iter->start_addr + peripheral_iter->peripheral->Get_Size()) <= addr)
            {
                return false;
            }

            return true;
        }

        // =============================================================================================================
        /// \brief Binary searches for a peripheral by the given address.
        ///
        /// Since peripheral cannot overlap, a binary search can be used to find a peripheral by the given
        /// address.
        ///
        /// \param addr Address in the address space
        /// \return Peripheral that should be mapped to the given address
        // =============================================================================================================
        [[nodiscard]] Peripherals_t::iterator Get_Peripheral(std::uint32_t addr) const
        {
            // Apply a binary search.
            // clang-format off
            auto peripheral_iter = std::lower_bound(
                m_peripherals.begin(),
                m_peripherals.end(), addr,
                [&](const auto& peripheral, std::uint32_t addr_cmp) -> bool {
                    return peripheral.start_addr < addr_cmp;
                }
            );
            // clang-format on

            // In case we access the very first address of the peripheral, we can simply return it.
            if (peripheral_iter != m_peripherals.end() && peripheral_iter->start_addr == addr)
            {
                return peripheral_iter;
            }

            // Otherwise, we have to return the peripheral that was mapped to its immediate left (lower address).
            if (peripheral_iter != m_peripherals.begin())
            {
                --peripheral_iter;
            }

            return peripheral_iter;
        }

    private:
        Peripherals_t m_peripherals;                ///< Collection of all memory-mapped peripherals
        std::mutex m_mtx;                           ///< Mutex to make memory accesses thread-safe
        std::shared_ptr<coprocessor::CCP15> m_cp15; ///< Reference to CP15 (coprocessor 15)
    };

} // namespace zero_mate
