// ---------------------------------------------------------------------------------------------------------------------
/// \file ram.hpp
/// \date 28. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the RAM (random access memory) used in BCM2835.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <array>
#include <vector>
#include <memory>
#include <cstdint>
/// \endcond

// Project file imports

#include "peripheral.hpp"

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CRAM
    /// \brief This class represents the RAM used in BCM2835.
    // -----------------------------------------------------------------------------------------------------------------
    class CRAM final : public IPeripheral
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        ///
        /// The RAM is initialized by calling the #Init function.
        ///
        /// \param size Size of the RAM
        // -------------------------------------------------------------------------------------------------------------
        explicit CRAM(std::uint32_t size);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        ///
        /// This constructor is used to initialize the RAM with a pre-defined content (typically the kernel code).
        /// It is mainly used for testing purposes.
        ///
        /// \param size Size of the RAM
        /// \param addr Address where the content should be placed (address of the first instruction)
        /// \param instructions Content itself (list of 32-bit instructions to be placed into the RAM)
        // -------------------------------------------------------------------------------------------------------------
        explicit CRAM(std::uint32_t size, std::uint32_t addr, const std::vector<std::uint32_t>& instructions);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the size of the peripheral (IPeripheral interface).
        /// \return Size of the RAM
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
        /// \brief Returns the raw content of the RAM (visualization purposes).
        /// \return Content of the RAM
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] char* Get_Raw_Data() const;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the RAM.
        ///
        /// This function is called upon construction. It allocates and clears out required space on the heap.
        // -------------------------------------------------------------------------------------------------------------
        void Init();

    private:
        std::uint32_t m_size;                      ///< Size of the RAM
        std::unique_ptr<char[]> m_data{ nullptr }; ///< Content of the RAM
    };

} // namespace zero_mate::peripheral