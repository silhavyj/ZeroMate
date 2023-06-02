// ---------------------------------------------------------------------------------------------------------------------
/// \file math.hpp
/// \date 14. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines and implements a variety of handy helper functions that are used throughout the project.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
#include <limits>
#include <concepts>
/// \endcond

namespace zero_mate::utils::math
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sets a bit in the given integral variable.
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value whose bit is going to be set
    /// \param idx Index of the bit to be set
    /// \param set Indication of whether the bit should be set to a 1 or 0
    // -----------------------------------------------------------------------------------------------------------------
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

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Tests whether a bit is set in the given integral variable.
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value whose bit is going to be tested
    /// \param idx Index of the bit to be tested for a 1
    /// \return true, if the bit is set to a 1. false, otherwise
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type>
    [[nodiscard]] bool Is_Bit_Set(Type value, Type idx) noexcept
    {
        return static_cast<bool>(static_cast<Type>(value >> idx) & 0b1U);
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \struct TShift_Result
    /// \brief Helper structure to hold the result of the LSL, LSR, ASR, and ROR operations (functions).
    /// \tparam Type Type of the variable the function is called with
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type>
    struct TShift_Result
    {
        bool carry_flag{}; ///< Indication of whether a carry flag is set
        Type result{};     ///< Result itself
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Performs an LSL (logical shift left) operation on the given integral value.
    ///
    /// The following tool can be used to see how these kinds of shifts/rotations work:
    /// https://onlinetoolz.net/bitshift. Their implementation is also explained in the ARM instruction set manual:
    /// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (section 4.5.2 - Shifts)
    ///
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value used in the operation
    /// \param shift_size Number of positions the value will be shifted by
    /// \param carry_flag Carry flag from the CPSR register
    /// \return TShift_Result, result of the shift operation
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type>
    [[nodiscard]] TShift_Result<Type> LSL(Type value, Type shift_size, bool carry_flag) noexcept
    {
        bool updated_carry_flag{}; // New value of the carry flag (after the operation)
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

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Performs an LSR (logical shift right) operation on the given integral value.
    ///
    /// The following tool can be used to see how these kinds of shifts/rotations work:
    /// https://onlinetoolz.net/bitshift. Their implementation is also explained in the ARM instruction set manual:
    /// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (section 4.5.2 - Shifts)
    ///
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value used in the operation
    /// \param shift_size Number of positions the value will be shifted by
    /// \return TShift_Result, result of the shift operation
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type>
    [[nodiscard]] TShift_Result<Type> LSR(Type value, Type shift_size) noexcept
    {
        bool carry_flag{};
        Type result{};

        if (shift_size == 0)
        {
            carry_flag = Is_Negative<Type>(value);
            result = value;
        }
        else
        {
            carry_flag = Is_Bit_Set<Type>(value, (shift_size - 1));
            result = static_cast<Type>(value >> shift_size);
        }

        return { carry_flag, result };
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Performs an ASR (arithmetic shift right) operation on the given integral value.
    ///
    /// The following tool can be used to see how these kinds of shifts/rotations work:
    /// https://onlinetoolz.net/bitshift. Their implementation is also explained in the ARM instruction set manual:
    /// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (section 4.5.2 - Shifts)
    ///
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value used in the operation
    /// \param shift_size Number of positions the value will be shifted by
    /// \return TShift_Result, result of the shift operation
    // -----------------------------------------------------------------------------------------------------------------
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
                result = value;
            }
        }
        else
        {
            carry_flag = Is_Bit_Set<Type>(value, (shift_size - 1));
            result = static_cast<Type>(static_cast<std::make_signed<Type>::type>(value) >> shift_size);
        }

        return { carry_flag, result };
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Performs an ROR (rotate right extended) operation on the given integral value.
    ///
    /// The following tool can be used to see how these kinds of shifts/rotations work:
    /// https://onlinetoolz.net/bitshift. Their implementation is also explained in the ARM instruction set manual:
    /// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (section 4.5.2 - Shifts)
    ///
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value used in the operation
    /// \param shift_size Number of positions the value will be rotated by
    /// \param carry_flag Carry flag from the CPSR register
    /// \return TShift_Result, result of the shift operation
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type>
    [[nodiscard]] TShift_Result<Type> ROR(Type value, Type shift_size, bool carry_flag) noexcept
    {
        bool updated_carry_flag{};
        Type result{};

        if (shift_size == 0)
        {
            updated_carry_flag = Is_Bit_Set<Type>(value, 0);
            result = static_cast<Type>((static_cast<Type>(carry_flag) << (std::numeric_limits<Type>::digits - 1U))) |
                     (value >> 1U);
        }
        else
        {
            updated_carry_flag = Is_Bit_Set<Type>(value, (shift_size - 1));
            result = static_cast<Type>(value >> shift_size) |
                     static_cast<Type>(value << (std::numeric_limits<Type>::digits - shift_size));
        }

        return { updated_carry_flag, result };
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Performs a rotate right operation on the given integral value.
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value to be rotated
    /// \param rot Number of positions the value will be rotated by
    /// \return Result of the rotation
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type>
    [[nodiscard]] Type ROR(Type value, Type rot) noexcept
    {
        if (rot == 0 || rot >= std::numeric_limits<Type>::digits)
        {
            return value;
        }

        return static_cast<Type>(value >> rot) | static_cast<Type>(value << (std::numeric_limits<Type>::digits - rot));
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Checks whether the given integral value is negative by examining the MSB
    /// \tparam Type Type of the variable the function is called with
    /// \param value Value to be check for being negative
    /// \return true, if the MSB is set (the value is negative). false, otherwise.
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type>
    [[nodiscard]] bool Is_Negative(Type value) noexcept
    {
        return Is_Bit_Set<Type>(value, std::numeric_limits<Type>::digits - 1U);
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Checks if the value is negative or not.
    ///
    /// The position of the MSB is determined by Type_Narrower. For example, if Is_Negative<std::uint32_t, std::uint8_t>
    /// is called, the 7th bit (starting from 0) of the value is treated as the most significant bit (MSB).
    ///
    /// \tparam Type Type of the variable the function is called with
    /// \tparam Type_Narrower This determines the MSB position in the value that is supposed to be of a larger datatype
    /// \param value Value to be check for being negative
    /// \return true, if the value is negative. false, otherwise.
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Type, std::unsigned_integral Type_Narrower>
    [[nodiscard]] bool Is_Negative(Type value) noexcept
    {
        // Make sure that Type is made up of more bits than Type_Narrower.
        static_assert(std::numeric_limits<Type_Narrower>::digits <= std::numeric_limits<Type>::digits);

        return Is_Bit_Set<Type>(value, std::numeric_limits<Type_Narrower>::digits - 1U);
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Checks if performing op1 - op2 would either an overflow or underflow.
    /// \tparam Type Type of the two operands the function is called with
    /// \param op1 First operand
    /// \param op2 Second operand
    /// \return true, if subtracting the two operands causes an overflow or underflow. false, if it is safe to perform
    ///         the operation.
    // -----------------------------------------------------------------------------------------------------------------
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

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Checks if performing op1 + op2 would either an overflow or underflow.
    /// \tparam Type Type of the two operands the function is called with
    /// \param op1 First operand
    /// \param op2 Second operand
    /// \return true, if adding up the two operands causes an overflow or underflow. false, if it is safe to perform
    ///         the operation.
    // -----------------------------------------------------------------------------------------------------------------
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

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Checks if adding or subtracting the two operands (including the carry flag) causes an overflow/underflow.
    /// \tparam Type Type of the two operands
    /// \param op1 First operand
    /// \param op2 Second operand
    /// \param subtraction Flag indicating whether the operands should be subtracted or added up
    /// \param carry Carry flag
    /// \return true, if the operation causes an overflow/underflow. false, otherwise.
    // -----------------------------------------------------------------------------------------------------------------
    template<std::signed_integral Type>
    [[nodiscard]] bool Check_Overflow(Type op1, Type op2, bool subtraction, Type carry) noexcept
    {
        // Check if adding the carry bit would cause an overflow.
        if (Check_Overflow_Addition<Type>(op2, carry))
        {
            return true;
        }

        // Add the carry bit.
        op2 += carry;

        if (subtraction)
        {
            return Check_Overflow_Subtraction<Type>(op1, op2);
        }

        return Check_Overflow_Addition<Type>(op1, op2);
    }

    // -----------------------------------------------------------------------------------------------------------------
    /// \brief Sign-extends the given integral value.
    ///
    /// If the value is positive, it is simple extended to the large datatype. If the is negative, the final result is
    /// made up of all 0xF, except for the least significant bits which hold the representation of the given value.
    ///
    /// \tparam Small_Type Type of the value passed in as a parameter
    /// \tparam Large_Type Type to which the value will be sign-extended
    /// \param value Value to be sign-extended
    /// \return sign-extended value
    // -----------------------------------------------------------------------------------------------------------------
    template<std::unsigned_integral Small_Type, std::unsigned_integral Large_Type = std::uint32_t>
    [[nodiscard]] Large_Type Sign_Extend_Value(Small_Type value) noexcept
    {
        // Make sure Small_Type consists of fewer bits than Large_Type.
        static_assert(std::numeric_limits<Small_Type>::digits < std::numeric_limits<Large_Type>::digits);

        if (utils::math::Is_Negative<Small_Type>(value))
        {
            // mask = 0xFFFF...
            auto mask = static_cast<Large_Type>(-1);

            // Create room for the value by shifting the mask to the left by 8 (adding zeros)
            for (std::size_t i = 0; i < sizeof(Small_Type); ++i)
            {
                mask =
                static_cast<Large_Type>(mask << static_cast<Large_Type>(std::numeric_limits<std::uint8_t>::digits));
            }

            // Insert the value into the final value (modifies the least significant bits).
            return static_cast<Large_Type>(mask | static_cast<Large_Type>(value));
        }

        // If the value is not negative, we can simply cast it.
        return static_cast<Large_Type>(value);
    }

} // namespace zero_mate::utils::math
