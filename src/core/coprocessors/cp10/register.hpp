#pragma once

#include <cstdint>

namespace zero_mate::coprocessor::cp10
{
    class CRegister final
    {
    public:
        static constexpr float Epsilon = 0.0000001F;

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

        CRegister& operator=(float value);
        CRegister& operator=(std::uint32_t value);

        [[nodiscard]] bool operator==(const CRegister& other) const;

        template<typename Type>
        [[nodiscard]] Type Get_Value_As() const
        {
            return std::bit_cast<Type>(m_value);
        }

    private:
        template<typename Operation>
        void Perform_Operation(const CRegister& other, const Operation op);

    private:
        std::uint32_t m_value;
    };
}
