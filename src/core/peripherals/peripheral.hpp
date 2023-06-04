// ---------------------------------------------------------------------------------------------------------------------
/// \file peripheral.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an interface for a memory-mapped peripheral.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class IPeripheral
    /// \brief This class represents a general interface of a memory-mapped peripheral.
    // -----------------------------------------------------------------------------------------------------------------
    class IPeripheral
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class (default non-parameterized constructor).
        // -------------------------------------------------------------------------------------------------------------
        IPeripheral() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~IPeripheral() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IPeripheral(const IPeripheral&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IPeripheral& operator=(const IPeripheral&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        IPeripheral(IPeripheral&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        IPeripheral& operator=(IPeripheral&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the peripheral.
        ///
        /// Every class/struct that inherits from the IPeripheral class must implement this function.
        // -------------------------------------------------------------------------------------------------------------
        virtual void Reset() noexcept = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the size of the peripheral.
        ///
        /// Every class/struct that inherits from the IPeripheral class must implement this function.
        ///
        /// \return number of register * register size
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] virtual std::uint32_t Get_Size() const noexcept = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Writes data to the peripheral.
        ///
        /// Every class/struct that inherits from the IPeripheral class must implement this function.
        ///
        /// \param addr Relative address (from the peripheral's perspective) where the data will be written
        /// \param data Pointer to the data to be written to the peripheral
        /// \param size Size of the data to be written to the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        virtual void Write(std::uint32_t addr, const char* data, std::uint32_t size) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads data from the peripheral.
        ///
        /// Every class/struct that inherits from the IPeripheral class must implement this function.
        ///
        /// \param addr Relative address (from the peripheral's perspective) from which the data will be read
        /// \param data Pointer to a buffer the data will be copied into
        /// \param size Size of the data to read from the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        virtual void Read(std::uint32_t addr, char* data, std::uint32_t size) = 0;
    };

} // namespace zero_mate::peripheral