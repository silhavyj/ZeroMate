#include <functional>

#include "alu.hpp"

namespace zero_mate::arm1176jzf_s::alu
{
    struct TALU_Settings
    {
        isa::CData_Processing instruction{ 0 };
        std::uint32_t op1{};
        std::uint32_t op2{};
        bool carry_out{};
        bool write_back{ true };
        bool subtraction{ false };
        bool reversed_operands{ false };
        bool account_for_carry{ false };
        bool is_logical_op{ true };
        std::function<std::uint32_t(std::uint32_t, std::uint32_t)> logical_op{};
        std::function<std::uint64_t(std::uint64_t, std::uint64_t, std::uint64_t)> arithmetic_op{};
    };

    namespace
    {
        [[nodiscard]] TResult Execute_Logical_Operation(const CCPU_Core& cpu, const TALU_Settings& params) noexcept
        {
            TResult result{};

            result.value = params.logical_op(params.op1, params.op2);
            result.write_back = params.write_back;
            result.set_flags = params.instruction.Is_S_Bit_Set();

            if (result.set_flags)
            {
                result.n_flag = utils::math::Is_Negative<std::uint32_t>(result.value);
                result.z_flag = result.value == 0;
                result.c_flag = params.carry_out;
                result.v_flag = cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V);
            }

            return result;
        }

        [[nodiscard]] std::int32_t Get_Carry(const TALU_Settings& params, bool c_flag) noexcept
        {
            std::int32_t carry{ 0 };

            if (params.account_for_carry)
            {
                if (params.subtraction)
                {
                    carry = static_cast<std::int32_t>(!c_flag);
                }
                else
                {
                    carry = static_cast<std::int32_t>(c_flag);
                }
            }

            return carry;
        }

        [[nodiscard]] TResult Execute_Arithmetic_Operation(const CCPU_Core& cpu, const TALU_Settings& params) noexcept
        {
            TResult result{};

            const auto c_flag = cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C);

            const auto op1_64u = static_cast<std::uint64_t>(params.op1);
            const auto op2_64u = static_cast<std::uint64_t>(params.op2);
            const auto result_64u = params.arithmetic_op(op1_64u, op2_64u, static_cast<std::uint64_t>(c_flag));

            result.value = static_cast<std::uint32_t>(result_64u);
            result.write_back = params.write_back;
            result.set_flags = params.instruction.Is_S_Bit_Set();

            const auto op1_32s = static_cast<std::int32_t>(params.reversed_operands ? params.op2 : params.op1);
            const auto op2_32s = static_cast<std::int32_t>(params.reversed_operands ? params.op1 : params.op2);
            const bool overflow = utils::math::Check_Overflow<std::int32_t>(op1_32s, op2_32s, params.subtraction, Get_Carry(params, c_flag));

            const bool carry = utils::math::Is_Bit_Set<std::uint64_t>(result_64u, std::numeric_limits<std::uint32_t>::digits);

            if (result.set_flags)
            {
                result.n_flag = utils::math::Is_Negative<std::uint64_t, std::uint32_t>(result_64u);
                result.z_flag = result.value == 0;
                result.c_flag = params.subtraction ? !carry : carry;
                result.v_flag = overflow;
            }

            return result;
        }

        [[nodiscard]] TResult Execute(const CCPU_Core& cpu, const TALU_Settings& params) noexcept
        {
            if (params.is_logical_op)
            {
                return Execute_Logical_Operation(cpu, params);
            }

            return Execute_Arithmetic_Operation(cpu, params);
        }
    }

    TResult Execute(const CCPU_Core& cpu, isa::CData_Processing instruction, std::uint32_t first_operand, std::uint32_t second_operand, bool carry_out) noexcept
    {
        TALU_Settings params{
            .instruction = instruction,
            .op1 = first_operand,
            .op2 = second_operand,
            .carry_out = carry_out
        };

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

        return Execute(cpu, params);
    }
}