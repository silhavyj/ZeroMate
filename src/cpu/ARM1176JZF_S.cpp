#include "ARM1176JZF_S.hpp"
#include "../utils/math.hpp"

namespace zero_mate::cpu
{
    CARM1176JZF_S::CARM1176JZF_S() noexcept
    : m_regs{}
    , m_cspr{ 0 }
    {
        LR() = MAX_ADDR;
    }

    std::uint32_t& CARM1176JZF_S::PC() noexcept
    {
        return m_regs[PC_REG_IDX];
    }

    std::uint32_t& CARM1176JZF_S::LR() noexcept
    {
        return m_regs[LR_REG_IDX];
    }

    std::uint32_t& CARM1176JZF_S::SP() noexcept
    {
        return m_regs[SP_REG_IDX];
    }

    bool CARM1176JZF_S::Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept
    {
        const auto condition = instruction.Get_Condition();

        switch (condition)
        {
            case isa::CInstruction::NCondition::EQ:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::Z);

            case isa::CInstruction::NCondition::NE:
                return !m_cspr.Is_Flag_Set(CCSPR::NFlag::Z);

            case isa::CInstruction::NCondition::HS:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::C);

            case isa::CInstruction::NCondition::LO:
                return !m_cspr.Is_Flag_Set(CCSPR::NFlag::C);

            case isa::CInstruction::NCondition::MI:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::N);

            case isa::CInstruction::NCondition::PL:
                return !m_cspr.Is_Flag_Set(CCSPR::NFlag::N);

            case isa::CInstruction::NCondition::VS:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::V);

            case isa::CInstruction::NCondition::VC:
                return !m_cspr.Is_Flag_Set(CCSPR::NFlag::V);

            case isa::CInstruction::NCondition::HI:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::C) && !m_cspr.Is_Flag_Set(CCSPR::NFlag::Z);

            case isa::CInstruction::NCondition::LS:
                return !m_cspr.Is_Flag_Set(CCSPR::NFlag::C) && m_cspr.Is_Flag_Set(CCSPR::NFlag::Z);

            case isa::CInstruction::NCondition::GE:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::N) == m_cspr.Is_Flag_Set(CCSPR::NFlag::V);

            case isa::CInstruction::NCondition::LT:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::N) != m_cspr.Is_Flag_Set(CCSPR::NFlag::V);

            case isa::CInstruction::NCondition::GT:
                return !m_cspr.Is_Flag_Set(CCSPR::NFlag::Z) && (m_cspr.Is_Flag_Set(CCSPR::NFlag::N) == m_cspr.Is_Flag_Set(CCSPR::NFlag::V));

            case isa::CInstruction::NCondition::LE:
                return m_cspr.Is_Flag_Set(CCSPR::NFlag::Z) || (m_cspr.Is_Flag_Set(CCSPR::NFlag::N) != m_cspr.Is_Flag_Set(CCSPR::NFlag::V));

            case isa::CInstruction::NCondition::AL:
                return true;
        }

        return false;
    }

    isa::CInstruction::NType CARM1176JZF_S::Get_Instruction_Type(isa::CInstruction instruction) noexcept
    {
        for (const auto& [mask, expected, type] : INSTRUCTION_LOOKUP_TABLE)
        {
            if ((instruction.Get_Value() & mask) == expected)
            {
                return type;
            }
        }

        return isa::CInstruction::NType::Unknown;
    }

    void CARM1176JZF_S::Execute(std::initializer_list<isa::CInstruction> instructions)
    {
        for (const auto& instruction : instructions)
        {
            if (Is_Instruction_Condition_Met(instruction))
            {
                Execute(instruction);
            }
        }
    }

    void CARM1176JZF_S::Execute(isa::CInstruction instruction)
    {
        const auto type = Get_Instruction_Type(instruction);

        switch (type)
        {
            case isa::CInstruction::NType::Data_Processing:
                Execute(isa::CData_Processing{ instruction });
                break;

            case isa::CInstruction::NType::Multiply:
            case isa::CInstruction::NType::Multiply_Long:
            case isa::CInstruction::NType::Single_Data_Swap:
            case isa::CInstruction::NType::Branch_And_Exchange:
            case isa::CInstruction::NType::Halfword_Data_Transfer_Register_Offset:
            case isa::CInstruction::NType::Halfword_Data_Transfer_Immediate_Offset:
            case isa::CInstruction::NType::Single_Data_Transfer:
            case isa::CInstruction::NType::Undefined:
            case isa::CInstruction::NType::Block_Data_Transfer:
            case isa::CInstruction::NType::Branch:
            case isa::CInstruction::NType::Coprocessor_Data_Transfer:
            case isa::CInstruction::NType::Coprocessor_Data_Operation:
            case isa::CInstruction::NType::Coprocessor_Register_Transfer:
            case isa::CInstruction::NType::Software_Interrupt:
            case isa::CInstruction::NType::Unknown:
                // TODO throw an exception once interrupts are implemented
                break;
        }
    }

    void CARM1176JZF_S::Execute(isa::CData_Processing instruction)
    {
        const auto Get_Shift_Amount = [&]() -> std::uint32_t {
            if (instruction.Is_Immediate_Shift())
            {
                return instruction.Get_Shift_Amount();
            }

            return m_regs.at(instruction.Get_Rs()) & 0xFFU;
        };

        auto Get_Second_Operand = [&]() -> utils::math::TShift_Result<std::uint32_t> {
            if (instruction.Is_I_Bit_Set())
            {
                const std::uint32_t immediate = instruction.Get_Immediate();
                const std::uint32_t shift_amount = instruction.Get_Rotate() * 2;
                std::uint32_t shifted_immediate = immediate;

                if (shift_amount != 0 && shift_amount != std::numeric_limits<std::uint32_t>::digits)
                {
                    shifted_immediate = utils::math::ROR(immediate, shift_amount, false).result;
                }

                return { m_cspr.Is_Flag_Set(CCSPR::NFlag::C), shifted_immediate };
            }

            const std::uint32_t shift_amount = Get_Shift_Amount();
            const auto shift_type = instruction.Get_Shift_Type();

            switch (shift_type)
            {
                case isa::CData_Processing::NShift_Type::LSL:
                    return utils::math::LSL<std::uint32_t>(m_regs.at(instruction.Get_Rm()), shift_amount, m_cspr.Is_Flag_Set(CCSPR::NFlag::C));

                case isa::CData_Processing::NShift_Type::LSR:
                    return utils::math::LSR<std::uint32_t>(m_regs.at(instruction.Get_Rm()), shift_amount);

                case isa::CData_Processing::NShift_Type::ASR:
                    return utils::math::ASR<std::uint32_t>(m_regs.at(instruction.Get_Rm()), shift_amount);

                case isa::CData_Processing::NShift_Type::ROR:
                    return utils::math::ROR<std::uint32_t>(m_regs.at(instruction.Get_Rm()), shift_amount, m_cspr.Is_Flag_Set(CCSPR::NFlag::C));
            }

            return {};
        };

        const std::uint32_t first_operand = m_regs.at(instruction.Get_Rn());
        const std::uint32_t destination_reg = instruction.Get_Rd();
        const auto [carry_flag, second_operand] = Get_Second_Operand();

        const auto Logical_Operation = [&](std::uint32_t result, bool write) -> void {
            if (instruction.Is_S_Bit_Set() && destination_reg != PC_REG_IDX)
            {
                m_cspr.Set_Flag(CCSPR::NFlag::N, utils::math::Is_Negative<std::uint32_t>(result));
                m_cspr.Set_Flag(CCSPR::NFlag::Z, result == 0);
                m_cspr.Set_Flag(CCSPR::NFlag::C, carry_flag);
            }

            if (write)
            {
                m_regs.at(destination_reg) = result;
            }
        };

        const auto Arithmetic_Operation = [&](bool write, bool subtraction, const auto operation) -> void {
            const auto first_operand_64 = static_cast<std::uint64_t>(first_operand);
            const auto second_operand_64 = static_cast<std::uint64_t>(first_operand);
            const std::uint64_t result_64 = operation(first_operand_64, second_operand_64, carry_flag);

            const auto result_32 = static_cast<std::uint32_t>(result_64);
            const bool carry = utils::math::Is_Bit_Set<std::uint64_t>(result_64, std::numeric_limits<std::uint32_t>::digits);

            const bool first_operand_signed = utils::math::Is_Negative<std::uint64_t, std::uint32_t>(first_operand_64);
            const bool second_operand_signed = utils::math::Is_Negative<std::uint64_t, std::uint32_t>(second_operand_64);
            const bool result_signed = utils::math::Is_Negative<std::uint64_t, std::uint32_t>(result_64);

            if (instruction.Is_S_Bit_Set() && destination_reg != PC_REG_IDX)
            {
                m_cspr.Set_Flag(CCSPR::NFlag::N, result_signed);
                m_cspr.Set_Flag(CCSPR::NFlag::Z, result_32 == 0);
                m_cspr.Set_Flag(CCSPR::NFlag::C, subtraction == !carry);
                m_cspr.Set_Flag(CCSPR::NFlag::V, (first_operand_signed == second_operand_signed) && (result_signed != first_operand_signed));
            }

            if (write)
            {
                m_regs.at(destination_reg) = result_32;
            }
        };

        const auto opcode = instruction.Get_Opcode();

        switch (opcode)
        {
            case isa::CData_Processing::NOpcode::AND:
                Logical_Operation(first_operand & second_operand, true);
                break;

            case isa::CData_Processing::NOpcode::EOR:
                Logical_Operation(first_operand ^ second_operand, true);
                break;

            case isa::CData_Processing::NOpcode::TST:
                Logical_Operation(first_operand & second_operand, false);
                break;

            case isa::CData_Processing::NOpcode::TEQ:
                Logical_Operation(first_operand ^ second_operand, false);
                break;

            case isa::CData_Processing::NOpcode::ORR:
                Logical_Operation(first_operand | second_operand, true);
                break;

            case isa::CData_Processing::NOpcode::MOV:
                Logical_Operation(second_operand, true);
                break;

            case isa::CData_Processing::NOpcode::BIC:
                Logical_Operation(first_operand & (~second_operand), true);
                break;

            case isa::CData_Processing::NOpcode::MVN:
                Logical_Operation(~second_operand, true);
                break;

            case isa::CData_Processing::NOpcode::SUB:
                Arithmetic_Operation(true, true, [](std::uint64_t op1, std::uint64_t op2, [[maybe_unused]] bool carry) -> std::uint64_t {
                    return op1 - op2;
                });
                break;

            case isa::CData_Processing::NOpcode::RSB:
                Arithmetic_Operation(true, true, [](std::uint64_t op1, std::uint64_t op2, [[maybe_unused]] bool carry) -> std::uint64_t {
                    return op2 - op1;
                });
                break;

            case isa::CData_Processing::NOpcode::ADD:
                Arithmetic_Operation(true, false, [](std::uint64_t op1, std::uint64_t op2, [[maybe_unused]] bool carry) -> std::uint64_t {
                    return op2 + op1;
                });
                break;

            case isa::CData_Processing::NOpcode::ADC:
                Arithmetic_Operation(true, false, [](std::uint64_t op1, std::uint64_t op2, bool carry) -> std::uint64_t {
                    return op2 + op1 + static_cast<std::uint64_t>(carry);
                });
                break;

            case isa::CData_Processing::NOpcode::SBC:
                Arithmetic_Operation(true, true, [](std::uint64_t op1, std::uint64_t op2, bool carry) -> std::uint64_t {
                    return op1 - op2 + static_cast<std::uint64_t>(carry) - 1;
                });
                break;

            case isa::CData_Processing::NOpcode::RSC:
                Arithmetic_Operation(true, true, [](std::uint64_t op1, std::uint64_t op2, bool carry) -> std::uint64_t {
                    return op2 - op1 + static_cast<std::uint64_t>(carry) - 1;
                });
                break;

            case isa::CData_Processing::NOpcode::CMP:
                Arithmetic_Operation(false, true, [](std::uint64_t op1, std::uint64_t op2, [[maybe_unused]] bool carry) -> std::uint64_t {
                    return op1 - op2;
                });
                break;

            case isa::CData_Processing::NOpcode::CMN:
                Arithmetic_Operation(false, false, [](std::uint64_t op1, std::uint64_t op2, [[maybe_unused]] bool carry) -> std::uint64_t {
                    return op2 + op1;
                });
                break;
        }
    }
}