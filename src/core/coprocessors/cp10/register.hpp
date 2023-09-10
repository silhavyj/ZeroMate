// ---------------------------------------------------------------------------------------------------------------------
/// \file register.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a custom single-precision floating point register.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
#include <numeric>
/// \endcond

namespace zero_mate::coprocessor::cp10
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CRegister
    /// \brief This class represents a custom single-precision floating point register of coprocessor CP10.
    // -----------------------------------------------------------------------------------------------------------------
    class CRegister final
    {
    public:
        /// Epsilon value used for comparison of two floating point values.
        static constexpr float Epsilon = 0.00001F;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CRegister() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Initial value of the register
        // -------------------------------------------------------------------------------------------------------------
        CRegister(float value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param value Initial value of the register
        // -------------------------------------------------------------------------------------------------------------
        CRegister(std::uint32_t value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deletes the instance from memory.
        // -------------------------------------------------------------------------------------------------------------
        ~CRegister() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Copy constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CRegister(const CRegister&) = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Move constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CRegister(CRegister&&) = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Assignment operator of the class.
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator=(const CRegister&) = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Assignment operator of the class (r-value reference).
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator=(CRegister&&) = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded + operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator+(const CRegister& other) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded - operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator-(const CRegister& other) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded * operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator*(const CRegister& other) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded / operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator/(const CRegister& other) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded > operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool operator>(const CRegister& other) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded < operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool operator<(const CRegister& other) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded += operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator+=(const CRegister& other) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded -= operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator-=(const CRegister& other) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded == operator.
        /// \param other Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool operator==(const CRegister& other) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded = operator (with a float value as a parameter).
        /// \param value Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator=(float value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Overloaded = operator (with an std::uint32_t value as a parameter).
        /// \param value Another instance of CRegister
        /// \return Reference to this instance
        // -------------------------------------------------------------------------------------------------------------
        CRegister& operator=(std::uint32_t value);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the register value as a desired data type.
        /// \tparam Type Type the register value will be returned as
        /// \return Register value bit-cast into the given type
        // -------------------------------------------------------------------------------------------------------------
        template<typename Type>
        [[nodiscard]] Type Get_Value_As() const
        {
            return std::bit_cast<Type>(m_value);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the absolute value of the register value.
        /// \return New instance of CRegister holding the result of the operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CRegister Get_ABS() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the register value multiplied by -1.
        /// \return New instance of CRegister holding the result of the operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CRegister Get_NEG() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the square root value of the register value.
        /// \return New instance of CRegister holding the result of the operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CRegister Get_SQRT() const noexcept;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a given arithmetic operation and stores the result into this register.
        /// \tparam Operation Type of operation to be performed
        /// \param other Another instance of CRegister
        /// \param op Arithmetic operation to be performed
        // -------------------------------------------------------------------------------------------------------------
        template<typename Operation>
        void Perform_Operation(const CRegister& other, const Operation op);

    private:
        std::uint32_t m_value; ///< Register value
    };

} // namespace zero_mate::coprocessor::cp10
