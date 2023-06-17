// ---------------------------------------------------------------------------------------------------------------------
/// \file trng.hpp
/// \date 10. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the TRNG (random number generator) used in BCM2835.
///
/// To find more information about this peripheral, please visit
/// http://home.zcu.cz/~ublm/files/os/bcm2835_trng_doc.html
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <random>
/// \endcond

// Project file imports

#include "peripheral.hpp"

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CTRNG
    /// \brief This class represents a TRNG (random number generator).
    // -----------------------------------------------------------------------------------------------------------------
    class CTRNG final : public IPeripheral
    {
    public:
        /// Size of a single register
        static constexpr auto Reg_Size = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NRegister
        /// \brief Enumeration of different registers which are used to interact the random number generator.
        // -------------------------------------------------------------------------------------------------------------
        enum class NRegister : std::uint32_t
        {
            Control,        ///< Control register (enable/disable)
            Status,         ///< Status register
            Data,           ///< Data register (random number itself)
            Threshold,      ///< Threshold for generating an interrupt (not supported)
            Interrupt_Mask, ///< Enable/disable interrupts (not supported)
            Count           ///< Total number of registers (helper enum record)
        };

        /// Total number of TRNG registers
        static constexpr auto Number_Of_Registers = static_cast<std::uint32_t>(NRegister::Count);

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CTRNG();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets/re-initializes the random number generator (IPeripheral interface).
        // -------------------------------------------------------------------------------------------------------------
        void Reset() noexcept override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the size of the peripheral (IPeripheral interface).
        /// \return number of register * register size
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Writes data to the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) where the data will be written
        /// \param data Pointer to the data to be written to the peripheral
        /// \param size Size of the data to be written to the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads data from the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) from which the data will be read
        /// \param data Pointer to a buffer the data will be copied into
        /// \param size Size of the data to read from the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether the random number generator is enabled or not.
        ///
        /// The peripheral is enabled by writing a 1 to the NRegister::Control register.
        ///
        /// \return true, if the peripheral is enabled. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Enabled() const;

    private:
        std::array<std::uint32_t, Number_Of_Registers> m_regs;       ///< Peripheral's registers
        std::random_device m_rand_dev;                               ///< Random device used to generate rnd numbers
        std::uniform_int_distribution<std::uint32_t> m_uniform_dist; ///< Uniform std::uint32_t distribution
    };

} // namespace zero_mate::peripheral