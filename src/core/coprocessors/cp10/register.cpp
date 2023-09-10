// ---------------------------------------------------------------------------------------------------------------------
/// \file register.cpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements a custom single-precision floating point register.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <cmath>
/// \endcond

// Project file imports

#include "register.hpp"

namespace zero_mate::coprocessor::cp10
{
    CRegister::CRegister()
    : CRegister(0U)
    {
    }

    CRegister::CRegister(float value)
    : CRegister{ std::bit_cast<std::uint32_t>(value) }
    {
    }

    CRegister::CRegister(std::uint32_t value)
    : m_value{ value }
    {
    }

    CRegister& CRegister::operator+(const CRegister& other) noexcept
    {
        Perform_Operation(other, [](float f1, float f2) -> float { return f1 + f2; });
        return *this;
    }

    CRegister& CRegister::operator-(const CRegister& other) noexcept
    {
        Perform_Operation(other, [](float f1, float f2) -> float { return f1 - f2; });
        return *this;
    }

    CRegister& CRegister::operator*(const CRegister& other) noexcept
    {
        Perform_Operation(other, [](float f1, float f2) -> float { return f1 * f2; });
        return *this;
    }

    CRegister& CRegister::operator/(const CRegister& other) noexcept
    {
        Perform_Operation(other, [](float f1, float f2) -> float { return f1 / f2; });
        return *this;
    }

    bool CRegister::operator>(const CRegister& other) const noexcept
    {
        // Get the two operands as single-precision floating point values.
        const auto f1 = Get_Value_As<float>();
        const auto f2 = other.Get_Value_As<float>();

        // Perform the operation.
        return f1 > f2;
    }

    bool CRegister::operator<(const CRegister& other) const noexcept
    {
        // Get the two operands as single-precision floating point values.
        const auto f1 = Get_Value_As<float>();
        const auto f2 = other.Get_Value_As<float>();

        // Perform the operation.
        return f1 < f2;
    }

    template<typename Operation>
    void CRegister::Perform_Operation(const CRegister& other, const Operation op)
    {
        // Get the two operands as single-precision floating point values.
        const auto f1 = Get_Value_As<float>();
        const auto f2 = other.Get_Value_As<float>();

        // Perform the operation.
        const auto result = op(f1, f2);

        // Store the result of the operation (a float) as an std::uint32_t.
        m_value = std::bit_cast<std::uint32_t>(result);
    }

    CRegister& CRegister::operator=(float value)
    {
        // Cast the value into an std::uint32_t before storing it.
        m_value = std::bit_cast<std::uint32_t>(value);
        return *this;
    }

    CRegister& CRegister::operator=(std::uint32_t value)
    {
        m_value = value; // No bit casting is needed.
        return *this;
    }

    CRegister& CRegister::operator+=(const CRegister& other) noexcept
    {
        // Add the other value (as a float) to the value (as a float) of this register.
        const auto result = Get_Value_As<float>() + other.Get_Value_As<float>();

        // Store the result as an std::uint32_t.
        m_value = std::bit_cast<std::uint32_t>(result);

        // Return a referent to this instance.
        return *this;
    }

    CRegister& CRegister::operator-=(const CRegister& other) noexcept
    {
        // Subtract the other value (as a float) from the value (as a float) of this register.
        const auto result = Get_Value_As<float>() - other.Get_Value_As<float>();

        // Store the result as an std::uint32_t.
        m_value = std::bit_cast<std::uint32_t>(result);

        // Return a referent to this instance.
        return *this;
    }

    bool CRegister::operator==(const CRegister& other) const
    {
        // Get the two operands as single-precision floating point values.
        const auto f1 = Get_Value_As<float>();
        const auto f2 = other.Get_Value_As<float>();

        // Compare two floating point values.
        return std::abs(f1 - f2) < Epsilon;
    }

    CRegister CRegister::Get_ABS() const noexcept
    {
        return CRegister{ std::abs(Get_Value_As<float>()) };
    }

    CRegister CRegister::Get_NEG() const noexcept
    {
        return CRegister{ -Get_Value_As<float>() };
    }

    CRegister CRegister::Get_SQRT() const noexcept
    {
        return CRegister{ std::sqrt(Get_Value_As<float>()) };
    }

} // namespace zero_mate::coprocessor::cp10