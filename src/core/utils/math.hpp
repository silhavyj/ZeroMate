#pragma once

#include <cstdint>
#include <limits>
#include <concepts>

namespace zero_mate::utils::math
{
    template<std::unsigned_integral Type>
    void Set_Bit(Type& value, Type idx, bool set) noexcept
    {
        if (set)
        {
            value |= static_cast<Type>(1U << idx);
        }
        else
        {
            value &= static_cast<Type>(~(1U << idx));
        }
    }

    template<std::unsigned_integral Type>
    [[nodiscard]] bool Is_Bit_Set(Type value, Type idx) noexcept
    {
        return static_cast<bool>(static_cast<Type>(value >> idx) & 0b1U);
    }

    template<std::unsigned_integral Type>
    struct TShift_Result
    {
        bool carry_flag{};
        Type result{};
    };

    template<std::unsigned_integral Type>
    [[nodiscard]] TShift_Result<Type> LSL(Type value, Type shift_size, bool carry_flag) noexcept
    {
        bool updated_carry_flag{};
        Type result{};

        if (shift_size == 0)
        {
            updated_carry_flag = carry_flag;
            result = value;
        }
        else
        {
            updated_carry_flag = Is_Bit_Set<Type>(value, (std::numeric_limits<Type>::digits - shift_size));
            result = static_cast<Type>(value << shift_size);
        }

        return { updated_carry_flag, result };
    }

    template<std::unsigned_integral Type>
    [[nodiscard]] TShift_Result<Type> LSR(Type value, Type shift_size) noexcept
    {
        bool carry_flag{};
        Type result{};

        if (shift_size == 0)
        {
            carry_flag = Is_Bit_Set<Type>(value, std::numeric_limits<Type>::digits - 1U);
            result = 0;
        }
        else
        {
            carry_flag = Is_Bit_Set<Type>(value, (shift_size - 1));
            result = static_cast<Type>(value >> shift_size);
        }

        return { carry_flag, result };
    }

    template<std::unsigned_integral Type>
    [[nodiscard]] TShift_Result<Type> ASR(Type value, Type shift_size) noexcept
    {
        bool carry_flag{};
        Type result{};

        if (shift_size == 0)
        {
            bool is_negative = Is_Bit_Set<Type>(value, std::numeric_limits<Type>::digits - 1U);
            carry_flag = is_negative;

            if (is_negative)
            {
                result = static_cast<Type>(-1);
            }
            else
            {
                result = 0;
            }
        }
        else
        {
            carry_flag = Is_Bit_Set<Type>(value, (shift_size - 1));
            result = static_cast<Type>(static_cast<std::make_signed<Type>::type>(value) >> shift_size);
        }

        return { carry_flag, result };
    }

    template<std::unsigned_integral Type>
    [[nodiscard]] TShift_Result<Type> ROR(Type value, Type shift_size, bool carry_flag = false) noexcept
    {
        bool updated_carry_flag{};
        Type result{};

        if (shift_size == 0)
        {
            updated_carry_flag = Is_Bit_Set<Type>(value, 0);
            result = static_cast<Type>((static_cast<Type>(carry_flag) << (std::numeric_limits<Type>::digits - 1U))) | (value >> 1U);
        }
        else
        {
            updated_carry_flag = Is_Bit_Set<Type>(value, (shift_size - 1));
            result = static_cast<Type>(value >> shift_size) | static_cast<Type>(value << (std::numeric_limits<Type>::digits - shift_size));
        }

        return { updated_carry_flag, result };
    }

    template<std::unsigned_integral Type>
    [[nodiscard]] bool Is_Negative(Type value) noexcept
    {
        return Is_Bit_Set<Type>(value, std::numeric_limits<Type>::digits - 1U);
    }

    template<std::unsigned_integral Type, std::unsigned_integral Type_Narrower>
    [[nodiscard]] bool Is_Negative(Type value) noexcept
    {
        static_assert(std::numeric_limits<Type_Narrower>::digits <= std::numeric_limits<Type>::digits);
        return Is_Bit_Set<Type>(value, std::numeric_limits<Type_Narrower>::digits - 1U);
    }

    template<std::signed_integral Type>
    [[nodiscard]] bool Check_Overflow_Subtraction(Type op1, Type op2) noexcept
    {
        if (op2 < 0 && op1 > (std::numeric_limits<Type>::max() + op2))
        {
            return true; // overflow
        }
        if (op2 > 0 && op1 < (std::numeric_limits<Type>::lowest() + op2))
        {
            return true; // underflow
        }

        return false;
    }

    template<std::signed_integral Type>
    [[nodiscard]] bool Check_Overflow_Addition(Type op1, Type op2) noexcept
    {
        if (op1 > 0 && op2 > (std::numeric_limits<Type>::max() - op1))
        {
            return true; // overflow
        }
        if (op1 < 0 && op2 < (std::numeric_limits<Type>::lowest() - op1))
        {
            return true; // underflow
        }

        return false;
    }

    template<std::signed_integral Type>
    [[nodiscard]] bool Check_Overflow(Type op1, Type op2, bool subtraction, Type carry) noexcept
    {
        if (Check_Overflow_Addition<Type>(op2, carry))
        {
            return true;
        }

        op2 += carry;

        if (subtraction)
        {
            return Check_Overflow_Subtraction<Type>(op1, op2);
        }

        return Check_Overflow_Addition<Type>(op1, op2);
    }

    template<std::unsigned_integral Type>
    [[nodiscard]] Type Get_Number_Of_Set_Bits(Type value) noexcept
    {
        Type count{ 0 };

        for (Type idx = 0; idx < std::numeric_limits<Type>::digits; ++idx)
        {
            if (Is_Bit_Set<Type>(value, idx))
            {
                ++count;
            }
        }

        return count;
    }

    template<std::unsigned_integral Type>
    [[nodiscard]] std::uint32_t Sign_Extend_Value(Type value) noexcept
    {
        static_assert(std::numeric_limits<Type>::digits < std::numeric_limits<std::uint32_t>::digits);

        if (utils::math::Is_Negative<Type>(value))
        {
            auto mask = static_cast<std::uint32_t>(-1);

            for (std::size_t i = 0; i < sizeof(Type); ++i)
            {
                mask <<= static_cast<std::uint32_t>(std::numeric_limits<std::uint8_t>::digits);
            }

            return mask | static_cast<std::uint32_t>(value);
        }

        return static_cast<std::uint32_t>(value);
    }
}