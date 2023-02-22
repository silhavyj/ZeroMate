#include "alu.hpp"

namespace zero_mate::cpu::alu
{
    struct TParams
    {
        isa::CData_Processing instruction{ 0 };
        std::uint32_t op1{};
        std::uint32_t op2{};
        std::uint32_t dest_reg{};
        bool carry_out{};
        bool write_back{ true };
        bool subtraction{ false };
        bool reversed_operands{ false };
        bool account_for_carry{ false };
    };

    [[nodiscard]] static TResult Execute_Logical_Operation(const CARM1176JZF_S& cpu, const TParams& params, const auto operation)
    {
        TResult result{};

        result.value = operation(params.op1, params.op2);
        result.write_back = params.write_back;
        result.set_flags = params.instruction.Is_S_Bit_Set() && params.dest_reg != CARM1176JZF_S::PC_REG_IDX;

        if (result.set_flags)
        {
            result.n_flag = utils::math::Is_Negative<std::uint32_t>(result.value);
            result.z_flag = result.value == 0;
            result.c_flag = params.carry_out;
            result.v_flag = cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V);
        }

        return result;
    }

    [[nodiscard]] std::int32_t Get_Carry(const TParams& params, bool c_flag)
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

    [[nodiscard]] static TResult Execute_Arithmetic_Operation(const CARM1176JZF_S& cpu, const TParams& params, const auto operation)
    {
        TResult result{};

        const auto c_flag = cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C);

        const auto op1_64u = static_cast<std::uint64_t>(params.op1);
        const auto op2_64u = static_cast<std::uint64_t>(params.op2);
        const auto result_64u = operation(op1_64u, op2_64u, static_cast<std::uint64_t>(c_flag));

        result.value = static_cast<std::uint32_t>(result_64u);
        result.write_back = params.write_back;
        result.set_flags = params.instruction.Is_S_Bit_Set() && params.dest_reg != CARM1176JZF_S::PC_REG_IDX;

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

    TResult Execute(const CARM1176JZF_S& cpu, isa::CData_Processing instruction, std::uint32_t first_operand, std::uint32_t second_operand, std::uint32_t dest_reg, bool carry_out)
    {
        TParams params{ .instruction = instruction, .op1 = first_operand, .op2 = second_operand, .dest_reg = dest_reg, .carry_out = carry_out };

        switch (instruction.Get_Opcode())
        {
            case isa::CData_Processing::NOpcode::AND:
                return Execute_Logical_Operation(cpu, params, [](const auto op1, const auto op2) { return op1 & op2; });

            case isa::CData_Processing::NOpcode::EOR:
                return Execute_Logical_Operation(cpu, params, [](const auto op1, const auto op2) { return op1 ^ op2; });

            case isa::CData_Processing::NOpcode::TST:
                params.write_back = false;
                return Execute_Logical_Operation(cpu, params, [](const auto op1, const auto op2) { return op1 & op2; });

            case isa::CData_Processing::NOpcode::TEQ:
                params.write_back = false;
                return Execute_Logical_Operation(cpu, params, [](const auto op1, const auto op2) { return op1 ^ op2; });

            case isa::CData_Processing::NOpcode::ORR:
                return Execute_Logical_Operation(cpu, params, [](const auto op1, auto op2) { return op1 | op2; });

            case isa::CData_Processing::NOpcode::MOV:
                return Execute_Logical_Operation(cpu, params, []([[maybe_unused]] const auto op1, const auto op2) { return op2; });

            case isa::CData_Processing::NOpcode::BIC:
                return Execute_Logical_Operation(cpu, params, [](const auto op1, const auto op2) { return op1 & (~op2); });

            case isa::CData_Processing::NOpcode::MVN:
                return Execute_Logical_Operation(cpu, params, []([[maybe_unused]] const auto op1, const auto op2) { return ~op2; });

            case isa::CData_Processing::NOpcode::SUB:
                params.subtraction = true;
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, [[maybe_unused]] const auto carry) { return op1 - op2; });

            case isa::CData_Processing::NOpcode::RSB:
                params.subtraction = true;
                params.reversed_operands = true;
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, [[maybe_unused]] const auto carry) { return op2 - op1; });

            case isa::CData_Processing::NOpcode::ADD:
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, [[maybe_unused]] const auto carry) { return op1 + op2; });

            case isa::CData_Processing::NOpcode::ADC:
                params.account_for_carry = true;
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, const auto carry) { return op1 + op2 + carry; });

            case isa::CData_Processing::NOpcode::SBC:
                params.account_for_carry = true;
                params.subtraction = true;
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, const auto carry) { return op1 - op2 + carry - 1; });

            case isa::CData_Processing::NOpcode::RSC:
                params.account_for_carry = true;
                params.subtraction = true;
                params.reversed_operands = true;
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, const auto carry) { return op2 - op1 + carry - 1; });

            case isa::CData_Processing::NOpcode::CMP:
                params.subtraction = true;
                params.write_back = false;
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, [[maybe_unused]] const auto carry) { return op1 - op2; });

            case isa::CData_Processing::NOpcode::CMN:
                params.write_back = false;
                return Execute_Arithmetic_Operation(cpu, params, [](const auto op1, const auto op2, [[maybe_unused]] const auto carry) { return op1 + op2; });
        }

        return {};
    }
}