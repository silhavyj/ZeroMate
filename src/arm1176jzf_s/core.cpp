#include <bit>
#include <variant>

#include "alu.hpp"
#include "mac.hpp"
#include "core.hpp"
#include "exceptions.hpp"

namespace zero_mate::arm1176jzf_s
{
    CCPU_Core::CCPU_Core() noexcept
    : CCPU_Core(0, nullptr)
    {
    }

    CCPU_Core::CCPU_Core(std::uint32_t pc, std::shared_ptr<CBus> bus) noexcept
    : m_regs{}
    , m_cspr{ 0 }
    , m_bus{ bus }
    {
        PC() = pc;
    }

    void CCPU_Core::Run(std::uint32_t last_execution_addr)
    {
        while (PC() != last_execution_addr)
        {
            Step();
        }
    }

    void CCPU_Core::Step(std::size_t count)
    {
        while (count > 0)
        {
            Step();
            --count;
        }
    }

    void CCPU_Core::Step()
    {
        assert(m_bus != nullptr);

        const auto instruction = Fetch_Instruction();
        Execute(instruction);
    }

    isa::CInstruction CCPU_Core::Fetch_Instruction()
    {
        const std::unsigned_integral auto instruction = m_bus->Read<std::uint32_t>(PC());
        PC() += sizeof(std::uint32_t);
        return instruction;
    }

    std::uint32_t& CCPU_Core::PC() noexcept
    {
        return m_regs[PC_REG_IDX];
    }

    std::uint32_t& CCPU_Core::LR() noexcept
    {
        return m_regs[LR_REG_IDX];
    }

    bool CCPU_Core::Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept
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

    void CCPU_Core::Execute(std::initializer_list<isa::CInstruction> instructions)
    {
        for (const auto& instruction : instructions)
        {
            try
            {
                Execute(instruction);
            }
            catch (const exceptions::CSoftware_Interrupt& ex)
            {
                // TODO
            }
            catch (const exceptions::CUndefined_Instruction& ex)
            {
                // TODO
            }
            catch (const exceptions::CData_Abort& ex)
            {
                // TODO
            }
        }
    }

    void CCPU_Core::Execute(isa::CInstruction instruction)
    {
        if (!Is_Instruction_Condition_Met(instruction))
        {
            return;
        }

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

            case isa::CInstruction::NType::Branch_And_Exchange:
                Execute(isa::CBranch_And_Exchange{ instruction });
                break;

            case isa::CInstruction::NType::Halfword_Data_Transfer:
                Execute(isa::CHalfword_Data_Transfer{ instruction });
                break;

            case isa::CInstruction::NType::Single_Data_Transfer:
                Execute(isa::CSingle_Data_Transfer{ instruction });
                break;

            case isa::CInstruction::NType::Undefined:
                throw exceptions::CUndefined_Instruction{};

            case isa::CInstruction::NType::Block_Data_Transfer:
                Execute(isa::CBlock_Data_Transfer{ instruction });
                break;

            case isa::CInstruction::NType::Branch:
                Execute(isa::CBranch{ instruction });
                break;

            case isa::CInstruction::NType::Coprocessor_Data_Transfer:
                [[fallthrough]];
            case isa::CInstruction::NType::Coprocessor_Data_Operation:
            case isa::CInstruction::NType::Coprocessor_Register_Transfer:
                break;

            case isa::CInstruction::NType::Software_Interrupt:
                Execute(isa::CSW_Interrupt{ instruction });
                break;

            case isa::CInstruction::NType::Unknown:
                throw exceptions::CUndefined_Instruction{};
        }
    }

    std::uint32_t CCPU_Core::Get_Shift_Amount(isa::CData_Processing instruction) const noexcept
    {
        if (instruction.Is_Immediate_Shift())
        {
            return instruction.Get_Shift_Amount();
        }

        return m_regs.at(instruction.Get_Rs()) & 0xFFU;
    }

    utils::math::TShift_Result<std::uint32_t> CCPU_Core::Get_Second_Operand_Imm(isa::CData_Processing instruction) const noexcept
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

    utils::math::TShift_Result<std::uint32_t> CCPU_Core::Perform_Shift(isa::CInstruction::NShift_Type shift_type, std::uint32_t shift_amount, std::uint32_t shift_reg) const noexcept
    {
        switch (shift_type)
        {
            case isa::CData_Processing::NShift_Type::LSL:
                return utils::math::LSL<std::uint32_t>(shift_reg, shift_amount, m_cspr.Is_Flag_Set(CCSPR::NFlag::C));

            case isa::CData_Processing::NShift_Type::LSR:
                return utils::math::LSR<std::uint32_t>(shift_reg, shift_amount);

            case isa::CData_Processing::NShift_Type::ASR:
                return utils::math::ASR<std::uint32_t>(shift_reg, shift_amount);

            case isa::CData_Processing::NShift_Type::ROR:
                return utils::math::ROR<std::uint32_t>(shift_reg, shift_amount, m_cspr.Is_Flag_Set(CCSPR::NFlag::C));
        }

        return {};
    }

    utils::math::TShift_Result<std::uint32_t> CCPU_Core::Get_Second_Operand(isa::CData_Processing instruction) const noexcept
    {
        if (instruction.Is_I_Bit_Set())
        {
            return Get_Second_Operand_Imm(instruction);
        }

        const std::uint32_t shift_amount = Get_Shift_Amount(instruction);
        const auto shift_type = instruction.Get_Shift_Type();
        const auto shift_reg = m_regs.at(instruction.Get_Rm());

        return Perform_Shift(shift_type, shift_amount, shift_reg);
    }

    void CCPU_Core::Execute(isa::CData_Processing instruction)
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

    void CCPU_Core::Execute(isa::CBranch_And_Exchange instruction) noexcept
    {
        if (instruction.Get_Instruction_Mode() == isa::CBranch_And_Exchange::NCPU_Instruction_Mode::Thumb)
        {
            // TODO print an info message saying that thumb instructions are not supported
        }

        if (instruction.Is_L_Bit_Set())
        {
            LR() = PC();
        }

        PC() = m_regs.at(instruction.Get_Rm()) & 0xFFFFFFFEU;
    }

    void CCPU_Core::Execute(isa::CBranch instruction)
    {
        if (instruction.Is_L_Bit_Set())
        {
            LR() = PC();
        }

        const auto offset = instruction.Get_Offset();

        if (offset < 0)
        {
            PC() -= static_cast<std::uint32_t>(-offset);
        }
        else
        {
            PC() += static_cast<std::uint32_t>(offset);
        }

        // PC is already pointing at the next instruction. Hence, +4 and not +8.
        PC() += sizeof(std::uint32_t);
    }

    void CCPU_Core::Execute(isa::CMultiply instruction)
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

    void CCPU_Core::Execute(isa::CMultiply_Long instruction)
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

    std::int64_t CCPU_Core::Get_Offset(isa::CSingle_Data_Transfer instruction) const noexcept
    {
        std::int64_t offset{};

        if (!instruction.Is_I_Bit_Set())
        {
            offset = static_cast<std::int64_t>(instruction.Get_Immediate_Offset());
        }
        else
        {
            const auto shift_type = instruction.Get_Shift_Type();
            const auto shift_amount = instruction.Get_Shift_Amount();
            const auto shift_reg = m_regs.at(instruction.Get_Rm());

            offset = static_cast<std::int64_t>(Perform_Shift(shift_type, shift_amount, shift_reg).result);
        }
        if (!instruction.Is_U_Bit_Set())
        {
            return -offset;
        }

        return offset;
    }

    void CCPU_Core::Execute(isa::CSingle_Data_Transfer instruction)
    {
        const auto reg_rn = instruction.Get_Rn();
        const auto base_addr = reg_rn == PC_REG_IDX ? (PC() + static_cast<std::uint32_t>(sizeof(std::uint32_t))) : m_regs.at(reg_rn);
        const auto offset = Get_Offset(instruction);

        const bool pre_indexed = instruction.Is_P_Bit_Set();
        const auto indexed_addr = static_cast<std::uint32_t>(static_cast<std::int64_t>(base_addr) + offset);
        const auto addr = pre_indexed ? indexed_addr : base_addr;

        if (instruction.Is_B_Bit_Set())
        {
            Read_Write_Value<std::uint8_t>(instruction, addr, instruction.Get_Rd());
        }
        else
        {
            Read_Write_Value<std::uint32_t>(instruction, addr, instruction.Get_Rd());
        }

        if (!pre_indexed || instruction.Is_W_Bit_Set())
        {
            m_regs.at(instruction.Get_Rn()) = indexed_addr;
        }
    }

    void CCPU_Core::Execute(isa::CBlock_Data_Transfer instruction)
    {
        const auto register_list = instruction.Get_Register_List();
        const auto number_of_regs = static_cast<std::uint32_t>(std::popcount(register_list));
        const auto base_reg = instruction.Get_Rn();

        auto addr = [&]() -> std::uint32_t {
            switch (instruction.Get_Addressing_Mode())
            {
                case isa::CBlock_Data_Transfer::NAddressing_Mode::IB:
                    return m_regs.at(base_reg) + REG_SIZE;

                case isa::CBlock_Data_Transfer::NAddressing_Mode::IA:
                    return m_regs.at(base_reg);

                case isa::CBlock_Data_Transfer::NAddressing_Mode::DB:
                    return m_regs.at(base_reg) - (number_of_regs * REG_SIZE);

                case isa::CBlock_Data_Transfer::NAddressing_Mode::DA:
                    return m_regs.at(base_reg) - (number_of_regs * REG_SIZE) + REG_SIZE;
            }

            return {};
        }();

        // TODO handle PSR

        const bool store_value = !instruction.Is_L_Bit_Set();

        for (std::size_t reg_idx = 0; reg_idx < NUMBER_OF_REGS; ++reg_idx)
        {
            if (utils::math::Is_Bit_Set<std::uint32_t>(register_list, static_cast<std::uint32_t>(reg_idx)))
            {
                if (store_value)
                {
                    m_bus->Write<std::uint32_t>(addr, m_regs.at(reg_idx));
                }
                else
                {
                    m_regs.at(reg_idx) = m_bus->Read<std::uint32_t>(addr);
                }

                addr += REG_SIZE;
            }
        }

        if (instruction.Is_W_Bit_Set())
        {
            const std::uint32_t total_size_transferred{ REG_SIZE * number_of_regs };

            if (!instruction.Is_U_Bit_Set())
            {
                m_regs.at(base_reg) -= total_size_transferred;
            }
            else
            {
                m_regs.at(base_reg) += total_size_transferred;
            }
        }
    }

    std::uint32_t CCPU_Core::Get_Offset(isa::CHalfword_Data_Transfer instruction) const noexcept
    {
        if (instruction.Is_Immediate_Offset())
        {
            const auto high_4_bits = instruction.Get_Immediate_Offset_High();
            const auto low_4_bits = instruction.Get_Immediate_Offset_Low();

            return (high_4_bits << 4U) | low_4_bits;
        }

        return m_regs.at(instruction.Get_Rm());
    }

    void CCPU_Core::Perform_Halfword_Data_Transfer_Read(isa::CHalfword_Data_Transfer::NType type, std::uint32_t addr, std::uint32_t dest_reg)
    {
        std::variant<std::uint8_t, std::uint16_t> read_value;

        switch (type)
        {
            case isa::CHalfword_Data_Transfer::NType::SWP:
                // TODO what does this do?
                break;

            case isa::CHalfword_Data_Transfer::NType::Unsigned_Halfwords:
                m_regs.at(dest_reg) = m_bus->Read<std::uint16_t>(addr);
                break;

            case isa::CHalfword_Data_Transfer::NType::Signed_Byte:
                read_value = m_bus->Read<std::uint8_t>(addr);
                m_regs.at(dest_reg) = utils::math::Sign_Extend_Value(std::get<std::uint8_t>(read_value));
                break;

            case isa::CHalfword_Data_Transfer::NType::Signed_Halfwords:
                read_value = m_bus->Read<std::uint16_t>(addr);
                m_regs.at(dest_reg) = utils::math::Sign_Extend_Value(std::get<std::uint16_t>(read_value));
                break;
        }
    }

    void CCPU_Core::Perform_Halfword_Data_Transfer_Write(isa::CHalfword_Data_Transfer::NType type, std::uint32_t addr, std::uint32_t src_reg)
    {
        std::uint16_t value{};

        switch (type)
        {
            case isa::CHalfword_Data_Transfer::NType::Unsigned_Halfwords:
                value = static_cast<std::uint16_t>(m_regs.at(src_reg) & 0x0000FFFFU);
                m_bus->Write<std::uint16_t>(addr, value);
                break;

            case isa::CHalfword_Data_Transfer::NType::SWP:
                [[fallthrough]];
            case isa::CHalfword_Data_Transfer::NType::Signed_Byte:
            case isa::CHalfword_Data_Transfer::NType::Signed_Halfwords:
                // TODO print out a warning even though this should not happen?
                break;
        }
    }

    void CCPU_Core::Execute(isa::CHalfword_Data_Transfer instruction)
    {
        const auto offset = Get_Offset(instruction);
        const auto src_dest_reg = instruction.Get_Rd();
        const auto operation_type = instruction.Get_Type();
        auto base_addr = m_regs.at(instruction.Get_Rn());
        const bool pre_indexed = instruction.Is_P_Bit_Set();
        std::uint32_t pre_indexed_addr{ base_addr };

        if (instruction.Is_U_Bit_Set())
        {
            pre_indexed_addr += offset;
        }
        else
        {
            pre_indexed_addr -= offset;
        }

        const auto addr = pre_indexed ? pre_indexed_addr : base_addr;

        if (instruction.Is_L_Bit_Set())
        {
            Perform_Halfword_Data_Transfer_Read(operation_type, addr, src_dest_reg);
        }
        else
        {
            Perform_Halfword_Data_Transfer_Write(operation_type, addr, src_dest_reg);
        }

        if (!pre_indexed || instruction.Is_W_Bit_Set())
        {
            m_regs.at(instruction.Get_Rn()) = pre_indexed_addr;
        }
    }

    void CCPU_Core::Execute(isa::CSW_Interrupt instruction)
    {
        // TODO
        static_cast<void>(instruction);
    }
}