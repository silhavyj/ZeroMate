#include <bit>
#include <variant>
#include <algorithm>

#include <magic_enum.hpp>

#include "alu.hpp"
#include "mac.hpp"
#include "core.hpp"
#include "../utils/singleton.hpp"

namespace zero_mate::arm1176jzf_s
{
    CCPU_Core::CCPU_Core() noexcept
    : CCPU_Core(0, nullptr)
    {
    }

    CCPU_Core::CCPU_Core(std::uint32_t pc, std::shared_ptr<CBus> bus) noexcept
    : m_context{}
    , m_bus{ bus }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_entry_point{ DEFAULT_ENTRY_POINT }
    , m_interrupt_controller{ nullptr }
    {
        Set_PC(pc);
    }

    void CCPU_Core::Add_Coprocessor(std::uint32_t id, const std::shared_ptr<coprocessor::ICoprocessor>& coprocessor)
    {
        m_coprocessors[id] = coprocessor;
    }

    CCPU_Context& CCPU_Core::Get_CPU_Context()
    {
        return m_context;
    }

    const CCPU_Context& CCPU_Core::Get_CPU_Context() const
    {
        return m_context;
    }

    void CCPU_Core::Reset_Context()
    {
        m_context.Reset();
        Set_PC(m_entry_point);
    }

    void CCPU_Core::Set_PC(std::uint32_t pc)
    {
        m_entry_point = pc;
        PC() = pc;
    }

    void CCPU_Core::Set_Interrupt_Controller(std::shared_ptr<peripheral::CInterrupt_Controller> interrupt_controller)
    {
        m_interrupt_controller = interrupt_controller;
    }

    void CCPU_Core::Add_System_Clock_Listener(const System_Clock_Listener_t& listener)
    {
        m_system_clock_listeners.push_back(listener);
    }

    void CCPU_Core::Add_Breakpoint(std::uint32_t addr)
    {
        m_breakpoints.insert(addr);
    }

    void CCPU_Core::Remove_Breakpoint(std::uint32_t addr)
    {
        if (m_breakpoints.contains(addr))
        {
            m_breakpoints.erase(addr);
        }
    }

    void CCPU_Core::Run()
    {
        while (!m_breakpoints.contains(PC()))
        {
            Step();
        }
    }

    void CCPU_Core::Steps(std::size_t count)
    {
        while (count > 0)
        {
            Step();
            --count;
        }
    }

    bool CCPU_Core::Step(bool ignore_breakpoint)
    {
        assert(m_bus != nullptr);

        if (ignore_breakpoint || !m_breakpoints.contains(PC()))
        {
            const std::optional<isa::CInstruction> instruction = Fetch_Instruction();

            if (instruction.has_value())
            {
                Execute(instruction.value());
            }

            return true;
        }

        return false;
    }

    std::optional<isa::CInstruction> CCPU_Core::Fetch_Instruction()
    {
        try
        {
            const std::unsigned_integral auto instruction = m_bus->Read<std::uint32_t>(PC());
            PC() += CCPU_Context::REG_SIZE;
            return std::optional<isa::CInstruction>{ instruction };
        }
        catch ([[maybe_unused]] const exceptions::CCPU_Exception& ex)
        {
            const exceptions::CPrefetch_Abort prefetch_ex{ PC() - CCPU_Context::REG_SIZE };
            Execute_Exception(prefetch_ex);
            return std::nullopt;
        }
    }

    std::uint32_t& CCPU_Core::PC() noexcept
    {
        return m_context[CCPU_Context::PC_REG_IDX];
    }

    const std::uint32_t& CCPU_Core::PC() const noexcept
    {
        return m_context[CCPU_Context::PC_REG_IDX];
    }

    std::uint32_t& CCPU_Core::LR() noexcept
    {
        return m_context[CCPU_Context::LR_REG_IDX];
    }

    const std::uint32_t& CCPU_Core::LR() const noexcept
    {
        return m_context[CCPU_Context::LR_REG_IDX];
    }

    bool CCPU_Core::Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept
    {
        const auto condition = instruction.Get_Condition();

        switch (condition)
        {
            case isa::CInstruction::NCondition::EQ:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::Z);

            case isa::CInstruction::NCondition::NE:
                return !m_context.Is_Flag_Set(CCPU_Context::NFlag::Z);

            case isa::CInstruction::NCondition::HS:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::C);

            case isa::CInstruction::NCondition::LO:
                return !m_context.Is_Flag_Set(CCPU_Context::NFlag::C);

            case isa::CInstruction::NCondition::MI:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::N);

            case isa::CInstruction::NCondition::PL:
                return !m_context.Is_Flag_Set(CCPU_Context::NFlag::N);

            case isa::CInstruction::NCondition::VS:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::V);

            case isa::CInstruction::NCondition::VC:
                return !m_context.Is_Flag_Set(CCPU_Context::NFlag::V);

            case isa::CInstruction::NCondition::HI:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::C) && !m_context.Is_Flag_Set(CCPU_Context::NFlag::Z);

            case isa::CInstruction::NCondition::LS:
                return !m_context.Is_Flag_Set(CCPU_Context::NFlag::C) || m_context.Is_Flag_Set(CCPU_Context::NFlag::Z);

            case isa::CInstruction::NCondition::GE:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::N) == m_context.Is_Flag_Set(CCPU_Context::NFlag::V);

            case isa::CInstruction::NCondition::LT:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::N) != m_context.Is_Flag_Set(CCPU_Context::NFlag::V);

            case isa::CInstruction::NCondition::GT:
                return !m_context.Is_Flag_Set(CCPU_Context::NFlag::Z) && (m_context.Is_Flag_Set(CCPU_Context::NFlag::N) == m_context.Is_Flag_Set(CCPU_Context::NFlag::V));

            case isa::CInstruction::NCondition::LE:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::Z) || (m_context.Is_Flag_Set(CCPU_Context::NFlag::N) != m_context.Is_Flag_Set(CCPU_Context::NFlag::V));

            case isa::CInstruction::NCondition::AL:
                [[fallthrough]];
            case isa::CInstruction::NCondition::Unconditioned:
                return true;
        }

        return false;
    }

    void CCPU_Core::Execute(std::initializer_list<isa::CInstruction> instructions)
    {
        for (const auto& instruction : instructions)
        {
            Execute(instruction);
        }
    }

    void CCPU_Core::Execute(isa::CInstruction instruction)
    {
        if (!Is_Instruction_Condition_Met(instruction))
        {
            return;
        }

        const auto type = m_instruction_decoder.Get_Instruction_Type(instruction);

        try
        {
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
                    Execute(isa::CCoprocessor_Data_Transfer{ instruction });
                    break;

                case isa::CInstruction::NType::Coprocessor_Data_Operation:
                    Execute(isa::CCoprocessor_Data_Operation{ instruction });
                    break;

                case isa::CInstruction::NType::Coprocessor_Register_Transfer:
                    Execute(isa::CCoprocessor_Reg_Transfer{ instruction });
                    break;

                case isa::CInstruction::NType::Software_Interrupt:
                    throw exceptions::CSoftware_Interrupt{};

                case isa::CInstruction::NType::Unknown:
                    throw exceptions::CUndefined_Instruction{};

                case isa::CInstruction::NType::Extend:
                    Execute(isa::CExtend{ instruction });
                    break;

                case isa::CInstruction::NType::PSR_Transfer:
                    Execute(isa::CPSR_Transfer{ instruction });
                    break;

                case isa::CInstruction::NType::CPS:
                    Execute(isa::CCPS{ instruction });
                    break;

                case isa::CInstruction::NType::NOP:
                    break;

                case isa::CInstruction::NType::SRS:
                    Execute(isa::CSRS{ instruction });
                    break;

                case isa::CInstruction::NType::RFE:
                    Execute(isa::CRFE{ instruction });
                    break;

                case isa::CInstruction::NType::CLZ:
                    Execute(isa::CCLZ{ instruction });
                    break;
            }

            Update_Cycle_Listeners();
            Check_For_Pending_IRQ();
        }
        catch (const exceptions::CCPU_Exception& ex)
        {
            Execute_Exception(ex);
        }
    }

    void CCPU_Core::Update_Cycle_Listeners()
    {
        std::for_each(m_system_clock_listeners.begin(), m_system_clock_listeners.end(), [](auto& listener) -> void {
            listener->Increment_Passed_Cycles(isa::CInstruction::AVERAGE_CPI);
        });
    }

    void CCPU_Core::Check_For_Pending_IRQ()
    {
        if (m_interrupt_controller != nullptr && m_interrupt_controller->Has_Pending_Interrupt())
        {
            throw exceptions::CIRQ{};
        }
    }

    void CCPU_Core::Execute_Exception(const exceptions::CCPU_Exception& exception)
    {
        m_logging_system.Warning(exception.what());

        // TODO do the same for FIQ?
        if (exception.Get_Type() == exceptions::CCPU_Exception::NType::IRQ)
        {
            // The compiler subtracts #4 from the LR register, so we need to compensate for that
            PC() += CCPU_Context::REG_SIZE;
        }

        m_context.Set_CPU_Mode(exception.Get_CPU_Mode());
        m_context[CCPU_Context::LR_REG_IDX] = PC();
        PC() = exception.Get_Exception_Vector();
    }

    std::uint32_t CCPU_Core::Get_Shift_Amount(isa::CData_Processing instruction) const noexcept
    {
        if (instruction.Is_Immediate_Shift())
        {
            return instruction.Get_Shift_Amount();
        }

        const auto shift_amount_reg_idx = instruction.Get_Rs();
        auto shift_amount_reg_value = m_context[shift_amount_reg_idx];

        if (shift_amount_reg_idx == CCPU_Context::PC_REG_IDX)
        {
            shift_amount_reg_value += CCPU_Context::REG_SIZE;
        }

        return shift_amount_reg_value & 0xFFU;
    }

    utils::math::TShift_Result<std::uint32_t> CCPU_Core::Perform_Shift(isa::CInstruction::NShift_Type shift_type, std::uint32_t shift_amount, std::uint32_t shift_reg) const noexcept
    {
        switch (shift_type)
        {
            case isa::CData_Processing::NShift_Type::LSL:
                return utils::math::LSL<std::uint32_t>(shift_reg, shift_amount, m_context.Is_Flag_Set(CCPU_Context::NFlag::C));

            case isa::CData_Processing::NShift_Type::LSR:
                return utils::math::LSR<std::uint32_t>(shift_reg, shift_amount);

            case isa::CData_Processing::NShift_Type::ASR:
                return utils::math::ASR<std::uint32_t>(shift_reg, shift_amount);

            case isa::CData_Processing::NShift_Type::ROR:
                return utils::math::ROR<std::uint32_t>(shift_reg, shift_amount, m_context.Is_Flag_Set(CCPU_Context::NFlag::C));
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
        const auto shift_reg = m_context[instruction.Get_Rm()];

        return Perform_Shift(shift_type, shift_amount, shift_reg);
    }

    void CCPU_Core::Execute(isa::CData_Processing instruction)
    {
        const auto rn_reg_idx = instruction.Get_Rn();
        std::uint32_t first_operand = m_context[rn_reg_idx];

        if (rn_reg_idx == CCPU_Context::PC_REG_IDX)
        {
            // PC is already pointing at the next instruction. Hence, +4 and not +8.
            first_operand += CCPU_Context::REG_SIZE;
        }

        const auto [carry_out, second_operand] = Get_Second_Operand(instruction);
        const std::uint32_t dest_reg_idx = instruction.Get_Rd();

        const auto result = alu::Execute(*this, instruction, first_operand, second_operand, carry_out);

        if (result.write_back)
        {
            m_context[dest_reg_idx] = result.value;
        }

        if (result.set_flags)
        {
            if (dest_reg_idx == CCPU_Context::PC_REG_IDX)
            {
                if (m_context.Is_Mode_With_No_SPSR(m_context.Get_CPU_Mode()))
                {
                    m_logging_system.Error(fmt::format("Attempt to write SPSR to CPSR from a mode where SPSR is not supported ({})", magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
                    return;
                }
                m_context.Set_CPSR(m_context.Get_SPSR());
            }
            else
            {
                m_context.Set_Flag(CCPU_Context::NFlag::N, result.n_flag);
                m_context.Set_Flag(CCPU_Context::NFlag::Z, result.z_flag);
                m_context.Set_Flag(CCPU_Context::NFlag::C, result.c_flag);
                m_context.Set_Flag(CCPU_Context::NFlag::V, result.v_flag);
            }
        }
    }

    void CCPU_Core::Execute(isa::CBranch_And_Exchange instruction) noexcept
    {
        const auto rm_reg_value = m_context[instruction.Get_Rm()];

        if (instruction.Get_Instruction_Mode(rm_reg_value) == isa::CBranch_And_Exchange::NCPU_Instruction_Mode::Thumb)
        {
            m_logging_system.Error("Thumb instructions are not supported by the emulator");
        }

        if (instruction.Is_L_Bit_Set())
        {
            LR() = PC();
        }

        PC() = rm_reg_value & 0xFFFFFFFEU;
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
        PC() += CCPU_Context::REG_SIZE;
    }

    void CCPU_Core::Execute(isa::CMultiply instruction)
    {
        const auto result = mac::Execute(instruction,
                                         m_context[instruction.Get_Rm()],
                                         m_context[instruction.Get_Rs()],
                                         m_context[instruction.Get_Rn()]);

        if (result.set_fags)
        {
            m_context.Set_Flag(CCPU_Context::NFlag::N, result.n_flag);
            m_context.Set_Flag(CCPU_Context::NFlag::Z, result.z_flag);
        }

        m_context[instruction.Get_Rd()] = result.value_lo;
    }

    void CCPU_Core::Execute(isa::CMultiply_Long instruction)
    {
        const auto reg_rd_lo = instruction.Get_Rd_Lo();
        const auto reg_rd_hi = instruction.Get_Rd_Hi();

        const auto result = mac::Execute(instruction,
                                         m_context[instruction.Get_Rm()],
                                         m_context[instruction.Get_Rs()],
                                         m_context[reg_rd_lo],
                                         m_context[reg_rd_hi]);

        if (result.set_fags)
        {
            m_context.Set_Flag(CCPU_Context::NFlag::N, result.n_flag);
            m_context.Set_Flag(CCPU_Context::NFlag::Z, result.z_flag);
        }

        m_context[reg_rd_lo] = result.value_lo;
        m_context[reg_rd_hi] = result.value_hi;
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
            const auto shift_reg = m_context[instruction.Get_Rm()];

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
        const auto reg_rn_idx = instruction.Get_Rn();
        const auto base_addr = reg_rn_idx == CCPU_Context::PC_REG_IDX ? (PC() + CCPU_Context::REG_SIZE) : m_context[reg_rn_idx];
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
            m_context[instruction.Get_Rn()] = indexed_addr;
        }
    }

    CCPU_Context::NCPU_Mode CCPU_Core::Determine_CPU_Mode(isa::CBlock_Data_Transfer instruction) const
    {
        const bool store_value = !instruction.Is_L_Bit_Set();
        const bool s_bit = instruction.Is_S_Bit_Set();
        const auto register_list = instruction.Get_Register_List();
        const bool r15_is_listed = utils::math::Is_Bit_Set<std::uint32_t>(register_list, CCPU_Context::PC_REG_IDX);

        if ((!r15_is_listed && s_bit) || (store_value && r15_is_listed && s_bit))
        {
            return CCPU_Context::NCPU_Mode::User;
        }

        return m_context.Get_CPU_Mode();
    }

    void CCPU_Core::Execute(isa::CBlock_Data_Transfer instruction)
    {
        const auto register_list = instruction.Get_Register_List();
        const auto number_of_regs = static_cast<std::uint32_t>(std::popcount(register_list));
        const auto base_reg_idx = instruction.Get_Rn();

        const bool store_value = !instruction.Is_L_Bit_Set();
        const bool s_bit = instruction.Is_S_Bit_Set();
        const auto cpu_mode = Determine_CPU_Mode(instruction);
        auto addr = Calculate_Base_Address(instruction, base_reg_idx, cpu_mode, number_of_regs);

        for (std::uint32_t reg_idx = 0; reg_idx < CCPU_Context::NUMBER_OF_REGS; ++reg_idx)
        {
            if (!utils::math::Is_Bit_Set<std::uint32_t>(register_list, reg_idx))
            {
                continue;
            }

            if (store_value)
            {
                m_bus->Write<std::uint32_t>(addr, m_context.Get_Register(reg_idx, cpu_mode));
            }
            else
            {
                m_context.Get_Register(reg_idx, cpu_mode) = m_bus->Read<std::uint32_t>(addr);

                if (s_bit && reg_idx == CCPU_Context::PC_REG_IDX)
                {
                    if (m_context.Is_Mode_With_No_SPSR(m_context.Get_CPU_Mode()))
                    {
                        m_logging_system.Error(fmt::format("There is no SPSR register in the {} mode", magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
                        throw exceptions::CReset{};
                    }

                    m_context.Set_CPSR(m_context.Get_SPSR());
                }
            }

            addr += CCPU_Context::REG_SIZE;
        }

        if (instruction.Is_W_Bit_Set())
        {
            const std::uint32_t total_size_transferred{ CCPU_Context::REG_SIZE * number_of_regs };

            if (!instruction.Is_U_Bit_Set())
            {
                m_context.Get_Register(base_reg_idx, cpu_mode) -= total_size_transferred;
            }
            else
            {
                m_context.Get_Register(base_reg_idx, cpu_mode) += total_size_transferred;
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

        return m_context[instruction.Get_Rm()];
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
                m_context[dest_reg] = m_bus->Read<std::uint16_t>(addr);
                break;

            case isa::CHalfword_Data_Transfer::NType::Signed_Byte:
                read_value = m_bus->Read<std::uint8_t>(addr);
                m_context[dest_reg] = utils::math::Sign_Extend_Value(std::get<std::uint8_t>(read_value));
                break;

            case isa::CHalfword_Data_Transfer::NType::Signed_Halfwords:
                read_value = m_bus->Read<std::uint16_t>(addr);
                m_context[dest_reg] = utils::math::Sign_Extend_Value(std::get<std::uint16_t>(read_value));
                break;
        }
    }

    void CCPU_Core::Perform_Halfword_Data_Transfer_Write(isa::CHalfword_Data_Transfer::NType type, std::uint32_t addr, std::uint32_t src_reg)
    {
        std::uint16_t value{};

        switch (type)
        {
            case isa::CHalfword_Data_Transfer::NType::Unsigned_Halfwords:
                value = static_cast<std::uint16_t>(m_context[src_reg] & 0x0000FFFFU);
                m_bus->Write<std::uint16_t>(addr, value);
                break;

            case isa::CHalfword_Data_Transfer::NType::SWP:
                [[fallthrough]];
            case isa::CHalfword_Data_Transfer::NType::Signed_Byte:
            case isa::CHalfword_Data_Transfer::NType::Signed_Halfwords:
                m_logging_system.Warning("Only unsigned halfwords should be used when performing a halfword data write");
                break;
        }
    }

    void CCPU_Core::Execute(isa::CHalfword_Data_Transfer instruction)
    {
        const auto offset = Get_Offset(instruction);
        const auto src_dest_reg = instruction.Get_Rd();
        const auto operation_type = instruction.Get_Type();
        auto base_addr = m_context[instruction.Get_Rn()];
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
            m_context[instruction.Get_Rn()] = pre_indexed_addr;
        }
    }

    void CCPU_Core::Execute(isa::CExtend instruction)
    {
        const auto type = instruction.Get_Type();
        const auto reg_rd_idx = instruction.Get_Rd();
        const auto reg_rm_idx = instruction.Get_Rm();
        const auto reg_rn_idx = instruction.Get_Rn();
        const auto rot = instruction.Get_Rot();

        const std::unsigned_integral auto rotated_value = utils::math::ROR(m_context[reg_rm_idx], rot);

        const std::uint16_t sign_extended_lower_8_to_16 = utils::math::Sign_Extend_Value<std::uint8_t, std::uint16_t>(rotated_value & 0xFFU);
        const std::uint16_t sign_extended_higher_8_to_16 = utils::math::Sign_Extend_Value<std::uint8_t, std::uint16_t>(((rotated_value & 0xFF0000U) >> 16U) & 0xFFU);

        const std::uint32_t sign_extended_8_to_32 = utils::math::Sign_Extend_Value<std::uint8_t, std::uint32_t>(rotated_value & 0xFFU);
        const std::uint32_t sign_extended_16_to_32 = utils::math::Sign_Extend_Value<std::uint16_t, std::uint32_t>(rotated_value & 0xFFFFU);

        const std::uint16_t lower_16_bits_unsigned = static_cast<std::uint16_t>(rotated_value & 0xFFU) + static_cast<std::uint16_t>(m_context[reg_rn_idx] & 0xFFFFU);
        const std::uint16_t higher_16_bits_unsigned = static_cast<std::uint16_t>((rotated_value & 0xFF0000U) >> 16U) + static_cast<std::uint16_t>((m_context[reg_rn_idx] & 0xFFFF0000U) >> 16U);

        const std::uint16_t lower_16_bits_signed = sign_extended_lower_8_to_16 + static_cast<std::uint16_t>(m_context[reg_rn_idx] & 0xFFFFU);
        const std::uint16_t higher_16_bits_singed = sign_extended_higher_8_to_16 + static_cast<std::uint16_t>((m_context[reg_rn_idx] & 0xFFFF0000) >> 16U);

        switch (type)
        {
            case isa::CExtend::NType::SXTAB16:
                m_context[reg_rd_idx] = static_cast<std::uint32_t>(lower_16_bits_signed) | (static_cast<std::uint32_t>(higher_16_bits_singed) << 16U);
                break;

            case isa::CExtend::NType::UXTAB16:
                m_context[reg_rd_idx] = static_cast<std::uint32_t>(lower_16_bits_unsigned) | (static_cast<std::uint32_t>(higher_16_bits_unsigned) << 16U);
                break;

            case isa::CExtend::NType::SXTB16:
                m_context[reg_rd_idx] = static_cast<std::uint32_t>(sign_extended_lower_8_to_16) | static_cast<std::uint32_t>(sign_extended_higher_8_to_16) << 16U;
                break;

            case isa::CExtend::NType::UXTB16:
                m_context[reg_rd_idx] = (rotated_value & 0xFFU) | (rotated_value & 0xFF0000U);
                break;

            case isa::CExtend::NType::SXTAB:
                m_context[reg_rd_idx] = sign_extended_8_to_32 + m_context[reg_rn_idx];
                break;

            case isa::CExtend::NType::UXTAB:
                m_context[reg_rd_idx] = (rotated_value & 0xFFU) + m_context[reg_rn_idx];
                break;

            case isa::CExtend::NType::SXTB:
                m_context[reg_rd_idx] = sign_extended_8_to_32;
                break;

            case isa::CExtend::NType::UXTB:
                m_context[reg_rd_idx] = rotated_value & 0xFFU;
                break;

            case isa::CExtend::NType::SXTAH:
                m_context[reg_rd_idx] = sign_extended_16_to_32 + m_context[reg_rn_idx];
                break;

            case isa::CExtend::NType::UXTAH:
                m_context[reg_rd_idx] = (rotated_value & 0xFFFFU) + m_context[reg_rn_idx];
                break;

            case isa::CExtend::NType::SXTH:
                m_context[reg_rd_idx] = sign_extended_16_to_32;
                break;

            case isa::CExtend::NType::UXTH:
                m_context[reg_rd_idx] = rotated_value & 0xFFFFU;
                break;
        }
    }

    void CCPU_Core::Execute_MSR(isa::CPSR_Transfer instruction)
    {
        const auto mask = instruction.Get_Mask();
        const auto new_value = instruction.Is_Immediate() ? Get_Second_Operand_Imm(instruction).result : m_context[instruction.Get_Rm()];

        const auto Update_Special_Register = [&mask, &new_value](std::uint32_t reg_value) -> std::uint32_t {
            reg_value &= ~mask;
            reg_value |= (new_value & mask);
            return reg_value;
        };

        switch (instruction.Get_Register_Type())
        {
            case isa::CPSR_Transfer::NRegister::CPSR:
                m_context.Set_CPSR(Update_Special_Register(m_context.Get_CPSR()));
                break;

            case isa::CPSR_Transfer::NRegister::SPSR:
                m_context.Set_SPSR(Update_Special_Register(m_context.Get_SPSR()));
                break;
        }
    }

    void CCPU_Core::Execute_MRS(isa::CPSR_Transfer instruction)
    {
        const auto reg_rd_idx = instruction.Get_Rd();

        switch (instruction.Get_Register_Type())
        {
            case isa::CPSR_Transfer::NRegister::CPSR:
                m_context[reg_rd_idx] = m_context.Get_CPSR();
                break;

            case isa::CPSR_Transfer::NRegister::SPSR:
                m_context[reg_rd_idx] = m_context.Get_SPSR();
                break;
        }
    }

    void CCPU_Core::Execute(isa::CPSR_Transfer instruction)
    {
        switch (instruction.Get_Type())
        {
            case isa::CPSR_Transfer::NType::MRS:
                Execute_MRS(instruction);
                break;

            case isa::CPSR_Transfer::NType::MSR:
                Execute_MSR(instruction);
                break;
        }
    }

    std::uint32_t CCPU_Core::Set_Interrupt_Mask_Bits(std::uint32_t cpsr, isa::CCPS instruction, bool set)
    {
        if (instruction.Is_A_Bit_Set())
        {
            CCPU_Context::Set_Flag(cpsr, CCPU_Context::NFlag::A, !set);
        }

        if (instruction.Is_I_Bit_Set())
        {
            CCPU_Context::Set_Flag(cpsr, CCPU_Context::NFlag::I, !set);
        }

        if (instruction.Is_F_Bit_Set())
        {
            CCPU_Context::Set_Flag(cpsr, CCPU_Context::NFlag::F, !set);
        }

        return cpsr;
    }

    void CCPU_Core::Execute(isa::CCPS instruction)
    {
        if (!m_context.Is_In_Privileged_Mode())
        {
            m_logging_system.Error("Attempt to execute instruction CPS in a non-privileged mode");
            return;
        }

        auto cpsr = m_context.Get_CPSR();

        switch (instruction.Get_Type())
        {
            case isa::CCPS::NType::CPSIE:
                cpsr = Set_Interrupt_Mask_Bits(cpsr, instruction, true);
                break;

            case isa::CCPS::NType::CPSID:
                cpsr = Set_Interrupt_Mask_Bits(cpsr, instruction, false);
                break;
        }

        if (instruction.Is_M_Bit_Set())
        {
            cpsr &= ~CCPU_Context::CPU_MODE_MASK;
            cpsr |= instruction.Get_Mode();
        }

        m_context.Set_CPSR(cpsr);
    }

    void CCPU_Core::Check_Coprocessor_Existence(std::uint32_t coprocessor_id)
    {
        if (!m_coprocessors.contains(coprocessor_id))
        {
            m_logging_system.Error(fmt::format("CP{} is not present", coprocessor_id).c_str());
            throw exceptions::CUndefined_Instruction{};
        }
    }

    void CCPU_Core::Execute(isa::CCoprocessor_Reg_Transfer instruction)
    {
        const auto coprocessor_id = instruction.Get_Coprocessor_ID();

        Check_Coprocessor_Existence(coprocessor_id);
        m_coprocessors[coprocessor_id]->Perform_Register_Transfer(instruction);
    }

    void CCPU_Core::Execute(isa::CCoprocessor_Data_Transfer instruction)
    {
        const auto coprocessor_id = instruction.Get_Coprocessor_ID();

        Check_Coprocessor_Existence(coprocessor_id);
        m_coprocessors[coprocessor_id]->Perform_Data_Transfer(instruction);
    }

    void CCPU_Core::Execute(isa::CCoprocessor_Data_Operation instruction)
    {
        const auto coprocessor_id = instruction.Get_Coprocessor_ID();

        Check_Coprocessor_Existence(coprocessor_id);
        m_coprocessors[coprocessor_id]->Perform_Data_Operation(instruction);
    }

    void CCPU_Core::Execute(isa::CSRS instruction)
    {
        static constexpr std::size_t NUMBER_OF_REGS_TO_TRANSFER = 2;

        if (!m_context.Is_In_Privileged_Mode())
        {
            m_logging_system.Error(fmt::format("Attempt execute an SRS instruction in a non-privileged mode", magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
            return;
        }

        const auto cpu_mode = static_cast<CCPU_Context::NCPU_Mode>(instruction.Get_CPU_Mode());
        auto addr = Calculate_Base_Address(instruction, CCPU_Context::SP_REG_IDX, cpu_mode, NUMBER_OF_REGS_TO_TRANSFER);

        m_bus->Write<std::uint32_t>(addr, m_context[CCPU_Context::LR_REG_IDX]);
        m_bus->Write<std::uint32_t>(addr + CCPU_Context::REG_SIZE, m_context.Get_SPSR());

        if (instruction.Is_W_Bit_Set())
        {
            const std::uint32_t total_size_transferred{ CCPU_Context::REG_SIZE * NUMBER_OF_REGS_TO_TRANSFER };

            if (instruction.Should_SP_Be_Decremented())
            {
                m_context.Get_Register(CCPU_Context::SP_REG_IDX, cpu_mode) -= total_size_transferred;
            }
            else
            {
                m_context.Get_Register(CCPU_Context::SP_REG_IDX, cpu_mode) += total_size_transferred;
            }
        }
    }

    void CCPU_Core::Execute(isa::CRFE instruction)
    {
        static constexpr std::size_t NUMBER_OF_REGS_TO_TRANSFER = 2;

        if (!m_context.Is_In_Privileged_Mode())
        {
            m_logging_system.Error(fmt::format("Attempt execute an RFE instruction in a non-privileged mode", magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
            return;
        }

        const auto reg_rn_idx = instruction.Get_Rn();
        const auto cpu_mode = m_context.Get_CPU_Mode();

        auto addr = Calculate_Base_Address(instruction, reg_rn_idx, cpu_mode, NUMBER_OF_REGS_TO_TRANSFER);

        const auto lr = m_bus->Read<std::uint32_t>(addr);
        const auto spsr = m_bus->Read<std::uint32_t>(addr + CCPU_Context::REG_SIZE);

        if (instruction.Is_W_Bit_Set())
        {
            const std::uint32_t total_size_transferred{ CCPU_Context::REG_SIZE * NUMBER_OF_REGS_TO_TRANSFER };

            // TODO make sure Rn gets written back in the correct CPU mode

            if (instruction.Should_Rn_Be_Decremented())
            {
                m_context.Get_Register(reg_rn_idx, cpu_mode) -= total_size_transferred;
            }
            else
            {
                m_context.Get_Register(reg_rn_idx, cpu_mode) += total_size_transferred;
            }
        }

        PC() = lr;
        m_context.Set_CPSR(spsr);
    }

    void CCPU_Core::Execute(isa::CCLZ instruction)
    {
        const auto rm_reg = m_context[instruction.Get_Rm()];
        std::uint32_t leading_zeros{ 0 };

        for (std::int32_t i = std::numeric_limits<std::uint32_t>::digits - 1; i >= 0; --i)
        {
            if (utils::math::Is_Bit_Set(rm_reg, static_cast<std::uint32_t>(i)))
            {
                break;
            }

            ++leading_zeros;
        }

        m_context[instruction.Get_Rd()] = leading_zeros;
    }
}