#include <bit>
#include <cmath>

#include "register.hpp"

namespace zero_mate::coprocessor::cp10
{
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
        const auto f1 = std::bit_cast<float>(m_value);
        const auto f2 = std::bit_cast<float>(other.m_value);

        return f1 > f2;
    }

    bool CRegister::operator<(const CRegister& other) const noexcept
    {
        const auto f1 = std::bit_cast<float>(m_value);
        const auto f2 = std::bit_cast<float>(other.m_value);

        return f1 < f2;
    }

    template<typename Operation>
    void CRegister::Perform_Operation(const CRegister& other, const Operation op)
    {
        const auto f1 = std::bit_cast<float>(m_value);
        const auto f2 = std::bit_cast<float>(other.m_value);

        const auto result = op(f1, f2);

        m_value = std::bit_cast<std::uint32_t>(result);
    }

    CRegister& CRegister::operator=(float value)
    {
        m_value = std::bit_cast<std::uint32_t>(value);
        return *this;
    }

    CRegister& CRegister::operator=(std::uint32_t value)
    {
        m_value = value;
        return *this;
    }

    CRegister& CRegister::operator+=(const CRegister& other) noexcept
    {
        auto f1 = std::bit_cast<float>(m_value);

        f1 += std::bit_cast<float>(other.m_value);
        m_value = std::bit_cast<std::uint32_t>(f1);

        return *this;
    }

    CRegister& CRegister::operator-=(const CRegister& other) noexcept
    {
        auto f1 = std::bit_cast<float>(m_value);

        f1 -= std::bit_cast<float>(other.m_value);
        m_value = std::bit_cast<std::uint32_t>(f1);

        return *this;
    }

    bool CRegister::operator==(const CRegister& other) const
    {
        const auto f1 = Get_Value_As<float>();
        const auto f2 = other.Get_Value_As<float>();

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
}