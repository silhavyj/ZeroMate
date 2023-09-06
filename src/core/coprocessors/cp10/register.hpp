#pragma once

#include <cstdint>
#include <numeric>

namespace zero_mate::coprocessor::cp10
{
    class CRegister final
    {
    public:
        static constexpr float Epsilon = 0.00001F;

    public:
        CRegister() = default;
        CRegister(float value);
        CRegister(std::uint32_t value);
        ~CRegister() = default;
        CRegister(const CRegister& other) = default;
        CRegister(CRegister&& other) = default;

        CRegister& operator=(const CRegister& other) = default;
        CRegister& operator=(CRegister&& other) = default;

        CRegister& operator+(const CRegister& other) noexcept;
        CRegister& operator-(const CRegister& other) noexcept;
        CRegister& operator*(const CRegister& other) noexcept;
        CRegister& operator/(const CRegister& other) noexcept;
        [[nodiscard]] bool operator>(const CRegister& other) const noexcept;
        [[nodiscard]] bool operator<(const CRegister& other) const noexcept;

        CRegister& operator+=(const CRegister& other) noexcept;
        CRegister& operator-=(const CRegister& other) noexcept;

        CRegister& operator=(float value);
        CRegister& operator=(std::uint32_t value);

        [[nodiscard]] bool operator==(const CRegister& other) const;

        template<typename Type>
        [[nodiscard]] Type Get_Value_As() const
        {
            return std::bit_cast<Type>(m_value);
        }

        [[nodiscard]] CRegister Get_ABS() const noexcept;
        [[nodiscard]] CRegister Get_NEG() const noexcept;
        [[nodiscard]] CRegister Get_SQRT() const noexcept;

    private:
        template<typename Operation>
        void Perform_Operation(const CRegister& other, const Operation op);

    private:
        std::uint32_t m_value;
    };
}
