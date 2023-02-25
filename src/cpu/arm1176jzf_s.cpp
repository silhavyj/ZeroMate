#include "alu.hpp"
#include "mac.hpp"
#include "arm1176jzf_s.hpp"

namespace zero_mate::cpu
{
    CARM1176JZF_S::CARM1176JZF_S() noexcept
    : CARM1176JZF_S(MAX_ADDR, nullptr)
    {
    }

    CARM1176JZF_S::CARM1176JZF_S(std::uint32_t pc, std::shared_ptr<mocks::CRAM> ram)
    : m_regs{}
    , m_cspr{ 0 }
    , m_ram{ ram }
    {
        LR() = MAX_ADDR;
        PC() = pc;
    }

    void CARM1176JZF_S::Step(std::size_t count)
    {
        while (count > 0)
        {
            Step();
            --count;
        }
    }

    void CARM1176JZF_S::Step()
    {
        if (PC() != MAX_ADDR && m_ram != nullptr)
        {
            const auto instruction = Fetch_Instruction();
            Execute({ instruction });
        }
    }

    isa::CInstruction CARM1176JZF_S::Fetch_Instruction()
    {
        const auto instruction = m_ram->Read<std::uint32_t>(PC());
        PC() += sizeof(std::uint32_t);
        return instruction;
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
                Execute(isa::CBranch_And_Exchange{ instruction });
                break;

            case isa::CInstruction::NType::Halfword_Data_Transfer_Register_Offset:
            case isa::CInstruction::NType::Halfword_Data_Transfer_Immediate_Offset:
            case isa::CInstruction::NType::Single_Data_Transfer:
            case isa::CInstruction::NType::Undefined:
            case isa::CInstruction::NType::Block_Data_Transfer:
            case isa::CInstruction::NType::Branch:
                Execute(isa::CBranch{ instruction });
                break;

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

    void CARM1176JZF_S::Execute(isa::CData_Processing instruction) noexcept
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

    void CARM1176JZF_S::Execute(isa::CBranch_And_Exchange instruction) noexcept
    {
        if (instruction.Switch_To_Thumb())
        {
            // TODO print an info message saying that thumb instructions are not supported
        }

        if (instruction.Is_L_Bit_Set())
        {
            LR() = PC();
        }

        PC() = m_regs.at(instruction.Get_Rm());
    }

    void CARM1176JZF_S::Execute(isa::CBranch instruction) noexcept
    {
        static_cast<void>(instruction);

        // if (instruction.Is_L_Bit_Set())
        // {
        //    LR() = PC();
        // }

        // TODO
        // PC() += instruction.Get_Offset() << 2;
    }

    void CARM1176JZF_S::Execute(isa::CMultiply instruction) noexcept
    {
        const auto result = mac::Execute(instruction,
                                         m_regs.at(instruction.Get_Rm()),
                                         m_regs.at(instruction.Get_Rs()),
                                         m_regs.at(instruction.Get_Rn()));

        if (result.set_fags)
        {
            m_cspr.Set_Flag(CCSPR::NFlag::N, result.n_flag);
            m_cspr.Set_Flag(CCSPR::NFlag::Z, result.z_flag);
        }

        m_regs.at(instruction.Get_Rd()) = result.value_lo;
    }

    void CARM1176JZF_S::Execute(isa::CMultiply_Long instruction) noexcept
    {
        const auto reg_rd_lo = instruction.Get_Rd_Lo();
        const auto reg_rd_hi = instruction.Get_Rd_Hi();

        const auto result = mac::Execute(instruction,
                                         m_regs.at(instruction.Get_Rm()),
                                         m_regs.at(instruction.Get_Rs()),
                                         m_regs.at(reg_rd_lo),
                                         m_regs.at(reg_rd_hi));

        if (result.set_fags)
        {
            m_cspr.Set_Flag(CCSPR::NFlag::N, result.n_flag);
            m_cspr.Set_Flag(CCSPR::NFlag::Z, result.z_flag);
        }

        m_regs.at(reg_rd_lo) = result.value_lo;
        m_regs.at(reg_rd_hi) = result.value_hi;
    }
}