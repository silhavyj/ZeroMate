// ---------------------------------------------------------------------------------------------------------------------
/// \file monitor.hpp
/// \date 28. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an 80x25 8-bit memory-mapped monitor which is used as a debug output.
/// \note This peripheral is not included in BCM2835
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <string>
/// \endcond

// Project file imports

#include "peripheral.hpp"

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CMonitor
    /// \brief This class represents a memory-mapped monitor used to print out debug messages.
    // -----------------------------------------------------------------------------------------------------------------
    class CMonitor final : public IPeripheral
    {
    public:
        /// Width of the monitor
        static constexpr std::uint32_t WIDTH = 80;

        /// Height of the monitor
        static constexpr std::uint32_t HEIGHT = 25;

        /// Total size of the monitor in 8-bit characters
        static constexpr std::uint32_t SIZE = WIDTH * HEIGHT;

        /// Default character used to fill out the monitor with
        static constexpr char DEFAULT_CHARACTER = '0';

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        ///
        /// It uses #DEFAULT_CHARACTER as the default character (the user is supposed to initially clear the monitor).
        // -------------------------------------------------------------------------------------------------------------
        CMonitor();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the size of the peripheral (IPeripheral interface).
        /// \return #SIZE
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
        /// \brief Returns the contents of the monitor (data).
        /// \return Data written to the monitor
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::string& Get_Data() const;

    private:
        std::string m_data; ///< Contents of the monitor (data)
    };

} // namespace zero_mate::peripheral