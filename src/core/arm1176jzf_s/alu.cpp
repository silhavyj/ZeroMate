// ---------------------------------------------------------------------------------------------------------------------
/// \file alu.cpp
/// \date 22. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the functionality of the arithmetic logic unit (ALU).
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <functional>
/// \endcond

// Project file imports

#include "alu.hpp"
#include "zero_mate/utils/math.hpp"

namespace zero_mate::arm1176jzf_s::alu
{
    // Anonymous namespace to make its content visible only to this translation unit.
    namespace
    {
        /// Alias for an arithmetic operation (just to make the code less wordy)
        using Arithmetical_Operation = std::function<std::uint64_t(std::uint64_t, std::uint64_t, std::uint64_t)>;

        /// Alias for a logical operation (just to make the code less wordy)
        using Logical_Operation = std::function<std::uint32_t(std::uint32_t, std::uint32_t)>;

        // -------------------------------------------------------------------------------------------------------------
        /// \struct TALU_Settings
        /// \brief ALU settings (alternative to passing everything as a parameter)
        // -------------------------------------------------------------------------------------------------------------
        struct TALU_Settings
        {
            isa::CData_Processing instruction{ 0 }; ///< Data processing instruction
            std::uint32_t op1{};                    ///< First operand
            std::uint32_t op2{};                    ///< Second operand
            bool carry_out{};                       ///< Carry out used in a logical operation
            bool write_back{ true };                ///< Should the result be written back?
            bool subtraction{ false };              ///< Is the operation a subtraction? (inverted carry)
            bool reversed_operands{ false };        ///< Should the ALU swap the operands?
            bool account_for_carry{ false };        ///< Should the ALU account for the carry flag
            bool is_logical_op{ true };             ///< Distinction between the two type of operation
            Logical_Operation logical_op{};         ///< Logical operation
            Arithmetical_Operation arithmetic_op{}; ///< Arithmetical operation
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a logical operation.
        ///
        /// The following instructions are classified as logical operations:
        /// AND, EOR, TST, TEQ, ORR, MOV, BIC, and MVN
        ///
        /// \param params ALU parameters (settings)
        /// \param cpu_v_flag Current value of the V flag (overflow) in the CPSR register
        /// \return Result of he logical operations
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] TResult Execute_Logical_Operation(const TALU_Settings& params, bool cpu_v_flag) noexcept
        {
            TResult result{};

            result.write_back = params.write_back;
            result.set_flags = params.instruction.Is_S_Bit_Set();

            // Perform the operation itself.
            result.value = params.logical_op(params.op1, params.op2);

            // Check if any flags should be set.
            if (result.set_flags)
            {
                result.n_flag = utils::math::Is_Negative<std::uint32_t>(result.value);
                result.z_flag = result.value == 0;
                result.c_flag = params.carry_out;
                result.v_flag = cpu_v_flag;
            }

            return result;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Calculates the carry bit.
        ///
        /// If the operation to be performed by the ALU is subtraction, it returns the opposite value to whatever the
        /// \p cpu_c_flag is set to. If the ALU should not account for carry (specified by \p params), 0 is returned.
        ///
        /// \param params ALU parameters (settings)
        /// \param cpu_c_flag Current value of the C flag (carry) in the CPSR register
        /// \return Calculated carry bit
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::int32_t Get_Carry(const TALU_Settings& params, bool cpu_c_flag) noexcept
        {
            std::int32_t carry{ 0 };

            // Check if we should account for carry in the first place.
            if (params.account_for_carry)
            {
                if (params.subtraction)
                {
                    // Invert the value (subtraction operation).
                    carry = static_cast<std::int32_t>(!cpu_c_flag);
                }
                else
                {
                    carry = static_cast<std::int32_t>(cpu_c_flag);
                }
            }

            return carry;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs an arithmetic operation.
        ///
        /// The following instructions are classified as arithmetic operations:
        /// SUB, RSB, ADD, ADC, SBC, RSC, CMP, and CMN
        ///
        /// \param cpu_c_flag Current value of the C flag (carry) in the CPSR register
        /// \param params ALU parameters (settings)
        /// \return Result of the operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] TResult Execute_Arithmetic_Operation(const TALU_Settings& params, bool cpu_c_flag) noexcept
        {
            TResult result{};

            // Convert the operands to 64-bit unsigned integers.
            const auto op1_64u = static_cast<std::uint64_t>(params.op1);
            const auto op2_64u = static_cast<std::uint64_t>(params.op2);

            // Perform the operation.
            const auto result_64u = params.arithmetic_op(op1_64u, op2_64u, static_cast<std::uint64_t>(cpu_c_flag));

            // Store the result of the operation into the TResult data structure.
            result.value = static_cast<std::uint32_t>(result_64u);
            result.write_back = params.write_back;
            result.set_flags = params.instruction.Is_S_Bit_Set();

            // Convert the operands to a 32-bit signed integers, so we can check for a possible overflow.
            const auto op1_32s = static_cast<std::int32_t>(params.reversed_operands ? params.op2 : params.op1);
            const auto op2_32s = static_cast<std::int32_t>(params.reversed_operands ? params.op1 : params.op2);

            // Check if an overflow/underflow took place during the operation.
            const bool overflow = utils::math::Check_Overflow<std::int32_t>(op1_32s,
                                                                            op2_32s,
                                                                            params.subtraction,
                                                                            Get_Carry(params, cpu_c_flag));

            // Check if the operation set the carry bit.
            const bool carry =
            utils::math::Is_Bit_Set<std::uint64_t>(result_64u, std::numeric_limits<std::uint32_t>::digits);

            // Check if the CPU flags should be updated.
            if (result.set_flags)
            {
                result.n_flag = utils::math::Is_Negative<std::uint64_t, std::uint32_t>(result_64u);
                result.z_flag = result.value == 0;
                result.v_flag = overflow;

                // If it is a subtraction operation, the carry flag is inverted.
                result.c_flag = params.subtraction == !carry;
            }

            return result;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs an ALU operations.
        ///
        /// The exact type of the operation (logical/arithmetic) is determined by the ALU settings passed in as a
        /// parameter.
        ///
        /// \param cpu_c_flag Current value of the C flag (carry) in the CPSR register
        /// \param cpu_v_flag Current value of the V flag (overflow) in the CPSR register
        /// \param params ALU parameters (settings)
        /// \return Result of the operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] TResult Execute(bool cpu_c_flag, bool cpu_v_flag, const TALU_Settings& params) noexcept
        {
            if (params.is_logical_op)
            {
                // Perform a logical operation.
                return Execute_Logical_Operation(params, cpu_v_flag);
            }

            // Perform an arithmetic operations.
            return Execute_Arithmetic_Operation(params, cpu_c_flag);
        }
    }

    TResult Execute(isa::CData_Processing instruction,
                    std::uint32_t first_operand,
                    std::uint32_t second_operand,
                    bool carry_out,
                    bool cpu_c_flag,
                    bool cpu_v_flag) noexcept
    {
        // Create ALU settings
        TALU_Settings params{ .instruction = instruction,
                              .op1 = first_operand,
                              .op2 = second_operand,
                              .carry_out = carry_out };

        // Define the operation to be performed.
        switch (instruction.Get_Opcode())
        {
            case isa::CData_Processing::NOpcode::AND:
                params.logical_op = [](auto op1, auto op2) { return op1 & op2; };
                break;

            case isa::CData_Processing::NOpcode::EOR:
                params.logical_op = [](auto op1, auto op2) { return op1 ^ op2; };
                break;

            case isa::CData_Processing::NOpcode::TST:
                params.write_back = false;
                params.logical_op = [](auto op1, auto op2) { return op1 & op2; };
                break;

            case isa::CData_Processing::NOpcode::TEQ:
                params.write_back = false;
                params.logical_op = [](auto op1, auto op2) { return op1 ^ op2; };
                break;

            case isa::CData_Processing::NOpcode::ORR:
                params.logical_op = [](auto op1, auto op2) { return op1 | op2; };
                break;

            case isa::CData_Processing::NOpcode::MOV:
                params.logical_op = []([[maybe_unused]] auto op1, auto op2) { return op2; };
                break;

            case isa::CData_Processing::NOpcode::BIC:
                params.logical_op = [](auto op1, auto op2) { return op1 & (~op2); };
                break;

            case isa::CData_Processing::NOpcode::MVN:
                params.logical_op = []([[maybe_unused]] auto op1, auto op2) { return ~op2; };
                break;

            case isa::CData_Processing::NOpcode::SUB:
                params.is_logical_op = false;
                params.subtraction = true;
                params.arithmetic_op = [](auto op1, auto op2, [[maybe_unused]] auto carry) { return op1 - op2; };
                break;

            case isa::CData_Processing::NOpcode::RSB:
                params.is_logical_op = false;
                params.subtraction = true;
                params.reversed_operands = true;
                params.arithmetic_op = [](auto op1, auto op2, [[maybe_unused]] auto carry) { return op2 - op1; };
                break;

            case isa::CData_Processing::NOpcode::ADD:
                params.is_logical_op = false;
                params.arithmetic_op = [](auto op1, auto op2, [[maybe_unused]] auto carry) { return op1 + op2; };
                break;

            case isa::CData_Processing::NOpcode::ADC:
                params.is_logical_op = false;
                params.account_for_carry = true;
                params.arithmetic_op = [](auto op1, auto op2, auto carry) { return op1 + op2 + carry; };
                break;

            case isa::CData_Processing::NOpcode::SBC:
                params.is_logical_op = false;
                params.account_for_carry = true;
                params.subtraction = true;
                params.arithmetic_op = [](auto op1, auto op2, auto carry) { return op1 - op2 + carry - 1; };
                break;

            case isa::CData_Processing::NOpcode::RSC:
                params.is_logical_op = false;
                params.account_for_carry = true;
                params.subtraction = true;
                params.reversed_operands = true;
                params.arithmetic_op = [](auto op1, auto op2, auto carry) { return op2 - op1 + carry - 1; };
                break;

            case isa::CData_Processing::NOpcode::CMP:
                params.is_logical_op = false;
                params.subtraction = true;
                params.write_back = false;
                params.arithmetic_op = [](auto op1, auto op2, [[maybe_unused]] auto carry) { return op1 - op2; };
                break;

            case isa::CData_Processing::NOpcode::CMN:
                params.is_logical_op = false;
                params.write_back = false;
                params.arithmetic_op = [](auto op1, auto op2, [[maybe_unused]] auto carry) { return op1 + op2; };
                break;
        }

        // Perform the operation.
        return Execute(cpu_c_flag, cpu_v_flag, params);
    }

} // namespace zero_mate::arm1176jzf_s::alu