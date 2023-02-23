#include "arm1176jzf_s.hpp"
#include "alu.hpp"

namespace zero_mate::cpu
{
    CARM1176JZF_S::CARM1176JZF_S() noexcept
    : m_regs{}
    , m_cspr{ 0 }
    , m_instruction_decoder{}
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
        const auto type = m_instruction_decoder.Get_Instruction_Type(instruction);

        switch (type)
        {
            case isa::CInstruction::NType::Data_Processing:
                Execute(isa::CData_Processing{ instruction });
                break;

            case isa::CInstruction::NType::Multiply:
                Execute(isa::CMultiply{ instruction });
                break;

            case isa::CInstruction::NType::Multiply_Long:
                Execute(isa::CMultiply_Long{ instruction });
                break;

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

    std::uint32_t CARM1176JZF_S::Get_Shift_Amount(isa::CData_Processing instruction) const noexcept
    {
        if (instruction.Is_Immediate_Shift())
        {
            return instruction.Get_Shift_Amount();
        }

        return m_regs.at(instruction.Get_Rs()) & 0xFFU;
    }

    utils::math::TShift_Result<std::uint32_t> CARM1176JZF_S::Get_Second_Operand_Imm(isa::CData_Processing instruction) const noexcept
    {
        const std::uint32_t immediate = instruction.Get_Immediate();
        const std::uint32_t shift_amount = instruction.Get_Rotate() * 2;

        utils::math::TShift_Result<std::uint32_t> second_operand{ m_cspr.Is_Flag_Set(CCSPR::NFlag::C), immediate };

        if (shift_amount != 0 && shift_amount != std::numeric_limits<std::uint32_t>::digits)
        {
            second_operand = utils::math::ROR(immediate, shift_amount);
        }

        return second_operand;
    }

    utils::math::TShift_Result<std::uint32_t> CARM1176JZF_S::Get_Second_Operand(isa::CData_Processing instruction) const noexcept
    {
        if (instruction.Is_I_Bit_Set())
        {
            return Get_Second_Operand_Imm(instruction);
        }

        const std::uint32_t shift_amount = Get_Shift_Amount(instruction);
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
    }

    void CARM1176JZF_S::Execute(isa::CData_Processing instruction)
    {
        const std::uint32_t first_operand = m_regs.at(instruction.Get_Rn());
        const auto [carry_out, second_operand] = Get_Second_Operand(instruction);
        const std::uint32_t dest_reg = instruction.Get_Rd();

        const auto result = alu::Execute(*this, instruction, first_operand, second_operand, carry_out);

        if (result.write_back)
        {
            m_regs.at(dest_reg) = result.value;
        }

        if (result.set_flags && dest_reg != PC_REG_IDX)
        {
            m_cspr.Set_Flag(CCSPR::NFlag::N, result.n_flag);
            m_cspr.Set_Flag(CCSPR::NFlag::Z, result.z_flag);
            m_cspr.Set_Flag(CCSPR::NFlag::C, result.c_flag);
            m_cspr.Set_Flag(CCSPR::NFlag::V, result.v_flag);
        }
    }

    void CARM1176JZF_S::Execute(isa::CMultiply instruction)
    {
        const std::uint32_t dest_reg = instruction.Get_Rd();
        const auto reg_rm_64u = static_cast<std::uint64_t>(m_regs.at(instruction.Get_Rm()));
        const auto reg_rs_64u = static_cast<std::uint64_t>(m_regs.at(instruction.Get_Rs()));
        std::uint64_t result_64u = reg_rm_64u * reg_rs_64u;

        if (instruction.Is_A_Bit_Set())
        {
            result_64u += static_cast<std::uint64_t>(m_regs.at(instruction.Get_Rn()));
        }

        const auto result_32u = static_cast<std::uint32_t>(result_64u);

        if (instruction.Is_S_Bit_Set() && dest_reg != PC_REG_IDX)
        {
            m_cspr.Set_Flag(CCSPR::NFlag::N, utils::math::Is_Negative<std::uint32_t>(result_32u));
            m_cspr.Set_Flag(CCSPR::NFlag::Z, result_32u == 0);
        }

        m_regs.at(dest_reg) = result_32u;
    }

    void CARM1176JZF_S::Execute(isa::CMultiply_Long instruction)
    {
        const auto reg_rs = m_regs.at(instruction.Get_Rs());
        const auto reg_rm = m_regs.at(instruction.Get_Rs());
        const auto reg_rd_lo = instruction.Get_RdLo();
        const auto reg_rd_hi = instruction.Get_RdHi();

        std::uint64_t result{};

        if (instruction.Is_U_Bit_Set())
        {
            result = static_cast<std::uint64_t>(reg_rs) * static_cast<std::uint64_t>(reg_rm);
        }
        else
        {
            result = static_cast<std::uint64_t>(static_cast<std::int64_t>(reg_rm) * static_cast<std::int64_t>(reg_rs));
        }

        if (instruction.Is_A_Bit_Set())
        {
            m_regs.at(reg_rd_hi) += static_cast<std::uint32_t>(result >> 32U);
            m_regs.at(reg_rd_lo) += static_cast<std::uint32_t>(result & 0xFFFFFFFFU);
        }
        else
        {
            m_regs.at(reg_rd_hi) = static_cast<std::uint32_t>(result >> 32U);
            m_regs.at(reg_rd_lo) = static_cast<std::uint32_t>(result & 0xFFFFFFFFU);
        }

        if (instruction.Is_S_Bit_Set())
        {
            m_cspr.Set_Flag(CCSPR::NFlag::N, utils::math::Is_Negative<std::uint64_t>(result));
            m_cspr.Set_Flag(CCSPR::NFlag::Z, result == 0);
        }
    }
}