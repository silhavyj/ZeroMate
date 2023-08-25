// ---------------------------------------------------------------------------------------------------------------------
/// \file core.cpp
/// \date 20. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the CCPU_Core class defined in core.hpp
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <bit>
#include <variant>
#include <algorithm>
#include <type_traits>
/// \endcond

// 3rd party library includes

#include <magic_enum.hpp>

// Project file imports

#include "alu.hpp"
#include "mac.hpp"
#include "core.hpp"

#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::arm1176jzf_s
{
    CCPU_Core::CCPU_Core() noexcept
    : CCPU_Core(0, nullptr)
    {
    }

    CCPU_Core::CCPU_Core(std::uint32_t pc, std::shared_ptr<CBus> bus) noexcept
    : m_context{}
    , m_bus{ bus }
    , m_mmu{ nullptr }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_entry_point{ Default_Entry_Point_Addr }
    , m_interrupt_controller{ nullptr }
    , m_external_peripherals{ nullptr }
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
        // Reset all coprocessors.
        for (auto& [id, coprocessor] : m_coprocessors)
        {
            coprocessor->Reset();
        }

        // Reset the MMU.
        if (m_mmu != nullptr)
        {
            m_mmu->Reset();
        }

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

    void CCPU_Core::Set_MMU(std::shared_ptr<mmu::CMMU> mmu)
    {
        m_mmu = mmu;
    }

    void CCPU_Core::Register_System_Clock_Listener(const System_Clock_Listener_t& listener)
    {
        m_system_clock_listeners.push_back(listener);
    }

    void CCPU_Core::Set_External_Peripherals(std::vector<IExternal_Peripheral*>* external_peripherals)
    {
        m_external_peripherals = external_peripherals;
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
        // Keep executing instructions until you hit a breakpoint.
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
        // Make sure the CPU is connected to the bus.
        assert(m_bus != nullptr);

        if (ignore_breakpoint || !m_breakpoints.contains(PC()))
        {
            // Attempt to fetch the next instruction.
            const std::optional<isa::CInstruction> instruction = Fetch_Instruction();

            // If the instruction has been successfully fetched, execute it.
            if (instruction.has_value())
            {
                Execute(instruction.value());
            }

            return true;
        }

        return false; // Breakpoint hit.
    }

    std::optional<isa::CInstruction> CCPU_Core::Fetch_Instruction()
    {
        try
        {
            // Reading from the bus may throw an exception (e.g. when there is an error
            // in the code and the PC register is set to a nonsense value).
            const std::unsigned_integral auto instruction = Read<std::uint32_t>(PC());

            PC() += CCPU_Context::Reg_Size;

            return std::optional<isa::CInstruction>{ instruction };
        }
        catch ([[maybe_unused]] const exceptions::CCPU_Exception& ex)
        {
            // "Convert" the exception caused by reading data from the bus into a prefetch abort exception.
            const exceptions::CPrefetch_Abort prefetch_ex{ PC() - CCPU_Context::Reg_Size };
            Execute_Exception(prefetch_ex);
            return std::nullopt;
        }
    }

    std::uint32_t& CCPU_Core::PC() noexcept
    {
        return m_context[CCPU_Context::PC_Reg_Idx];
    }

    const std::uint32_t& CCPU_Core::PC() const noexcept
    {
        return m_context[CCPU_Context::PC_Reg_Idx];
    }

    std::uint32_t& CCPU_Core::LR() noexcept
    {
        return m_context[CCPU_Context::LR_Reg_Idx];
    }

    const std::uint32_t& CCPU_Core::LR() const noexcept
    {
        return m_context[CCPU_Context::LR_Reg_Idx];
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
                return !m_context.Is_Flag_Set(CCPU_Context::NFlag::Z) &&
                       (m_context.Is_Flag_Set(CCPU_Context::NFlag::N) == m_context.Is_Flag_Set(CCPU_Context::NFlag::V));

            case isa::CInstruction::NCondition::LE:
                return m_context.Is_Flag_Set(CCPU_Context::NFlag::Z) ||
                       (m_context.Is_Flag_Set(CCPU_Context::NFlag::N) != m_context.Is_Flag_Set(CCPU_Context::NFlag::V));

            case isa::CInstruction::NCondition::AL:
                [[fallthrough]];
            case isa::CInstruction::NCondition::Unconditioned:
                return true;
        }

        return false; // Just so the compiler does not gripe about a missing return value.
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
        // Check the flags to determine whether the instruction should be executed or not.
        if (!Is_Instruction_Condition_Met(instruction))
        {
            return;
        }

        try
        {
            // Execute the instruction based on its type.
            switch (m_instruction_decoder.Get_Instruction_Type(instruction))
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

                case isa::CInstruction::NType::SMULxy:
                    Execute(isa::CSMULxy{ instruction });
                    break;

                case isa::CInstruction::NType::SMULWy:
                    Execute(isa::CSMULWy{ instruction });
                    break;

                case isa::CInstruction::NType::SMLAxy:
                    Execute(isa::CSMLAxy{ instruction });
                    break;

                case isa::CInstruction::NType::SMLAWy:
                    Execute(isa::CSMLAWy{ instruction });
                    break;
            }

            // Check if there is a pending IRQ.
            Check_For_Pending_IRQ();
        }
        catch (const exceptions::CCPU_Exception& ex)
        {
            Execute_Exception(ex);
        }

        // Update all system clock listeners about how many clock cycles it took to execute the instruction.
        Update_Cycle_Listeners();
    }

    void CCPU_Core::Update_Cycle_Listeners()
    {
        // TODO calculate how many CPU cycles it actually took to execute the instruction
        std::for_each(m_system_clock_listeners.begin(), m_system_clock_listeners.end(), [](auto& listener) -> void {
            listener->Increment_Passed_Cycles(isa::CInstruction::Average_CPI);
        });

        // Notify all external peripherals about how many CPU cycles have passed by.
        if (m_external_peripherals != nullptr)
        {
            for (auto* listener : *m_external_peripherals)
            {
                listener->Increment_Passed_Cycles(isa::CInstruction::Average_CPI);
            }
        }
    }

    void CCPU_Core::Check_For_Pending_IRQ()
    {
        if (m_interrupt_controller != nullptr && m_interrupt_controller->Has_Pending_Interrupt())
        {
            throw exceptions::CIRQ{};
        }
    }

    bool CCPU_Core::Is_IVT_Reallocated_To_High_Addr()
    {
        // Coprocessor CP15 must exist.
        if (!m_coprocessors.contains(coprocessor::cp15::CCP15::ID))
        {
            return false;
        }

        // Get the CP15 register
        auto cp15 = std::static_pointer_cast<coprocessor::cp15::CCP15>(m_coprocessors.at(coprocessor::cp15::CCP15::ID));

        // Retrieve the C1 register - Control register.
        const auto cp15_c1 =
        cp15->Get_Primary_Register<coprocessor::cp15::CC1>(coprocessor::cp15::NPrimary_Register::C1);

        // Check if the exception handler should be looked for at higher addresses.
        return cp15_c1->Is_Control_Flag_Set(coprocessor::cp15::CC1::NC0_Control_Flags::High_Exception_Vectors);
    }

    void CCPU_Core::Execute_Exception(const exceptions::CCPU_Exception& exception)
    {
        m_logging_system.Warning(exception.what());

        // TODO do the same for FIQ?
        if (exception.Get_Type() == exceptions::CCPU_Exception::NType::IRQ)
        {
            // The compiler subtracts #4 from the LR register, so we need to compensate for that.
            PC() += CCPU_Context::Reg_Size;
        }

        // Set the mode of the CPU based on the thrown exception.
        m_context.Set_CPU_Mode(exception.Get_CPU_Mode());

        // LR = PC
        m_context[CCPU_Context::LR_Reg_Idx] = PC();

        // Retrieve the exception vector (address of the exception handler).
        std::uint32_t exception_vector = exception.Get_Exception_Vector();

        // Check if the exception vector is located at higher addresses.
        if (Is_IVT_Reallocated_To_High_Addr())
        {
            exception_vector += exceptions::CCPU_Exception::IVT_High_Base_Addr;
        }

        // PC = &exception_handler
        PC() = exception_vector;
    }

    std::uint32_t CCPU_Core::Get_Shift_Amount(isa::CData_Processing instruction) const noexcept
    {
        // If it is an immediate shift and not a shift by a register.
        if (instruction.Is_Immediate_Shift())
        {
            return instruction.Get_Shift_Amount();
        }

        const auto shift_amount_reg_idx = instruction.Get_Rs_Idx();
        auto shift_amount_reg_value = m_context[shift_amount_reg_idx];

        // R15 (PC) is used as the Rs register.
        if (shift_amount_reg_idx == CCPU_Context::PC_Reg_Idx)
        {
            // PC is already pointing at the next instruction. Hence, +4 and not +8.
            shift_amount_reg_value += CCPU_Context::Reg_Size;
        }

        // Only the lowest 8 bits represent the shift amount.
        return shift_amount_reg_value & 0xFFU;
    }

    utils::math::TShift_Result<std::uint32_t> CCPU_Core::Perform_Shift(isa::CInstruction::NShift_Type shift_type,
                                                                       std::uint32_t shift_amount,
                                                                       std::uint32_t value) const noexcept
    {
        switch (shift_type)
        {
            // Logical shift left
            case isa::CData_Processing::NShift_Type::LSL:
                return utils::math::LSL<std::uint32_t>(value,
                                                       shift_amount,
                                                       m_context.Is_Flag_Set(CCPU_Context::NFlag::C));

            // Logical shift right
            case isa::CData_Processing::NShift_Type::LSR:
                return utils::math::LSR<std::uint32_t>(value, shift_amount);

            // Arithmetic shift right
            case isa::CData_Processing::NShift_Type::ASR:
                return utils::math::ASR<std::uint32_t>(value, shift_amount);

            // Rotate right extended
            case isa::CData_Processing::NShift_Type::ROR:
                return utils::math::ROR<std::uint32_t>(value,
                                                       shift_amount,
                                                       m_context.Is_Flag_Set(CCPU_Context::NFlag::C));
        }

        return {}; // Just so the compiler does not gripe about a missing return value.
    }

    utils::math::TShift_Result<std::uint32_t>
    CCPU_Core::Get_Second_Operand(isa::CData_Processing instruction) const noexcept
    {
        // Is the second operand immediate operand?
        if (instruction.Is_I_Bit_Set())
        {
            return Get_Second_Operand_Imm(instruction);
        }

        // Perform a shift operation on the Rm register.
        return Perform_Shift(instruction.Get_Shift_Type(),
                             Get_Shift_Amount(instruction),
                             m_context[instruction.Get_Rm_Idx()]);
    }

    void CCPU_Core::Execute(isa::CData_Processing instruction)
    {
        const auto rn_reg_idx = instruction.Get_Rn_Idx();
        std::uint32_t first_operand = m_context[rn_reg_idx];

        if (rn_reg_idx == CCPU_Context::PC_Reg_Idx)
        {
            // PC is already pointing at the next instruction. Hence, +4 and not +8.
            first_operand += CCPU_Context::Reg_Size;
        }

        const auto [carry_out, second_operand] = Get_Second_Operand(instruction);
        const std::uint32_t dest_reg_idx = instruction.Get_Rd_Idx();

        // Execute the operation using the ALU
        const auto result = alu::Execute(instruction,
                                         first_operand,
                                         second_operand,
                                         carry_out,
                                         m_context.Is_Flag_Set(CCPU_Context::NFlag::C),
                                         m_context.Is_Flag_Set(CCPU_Context::NFlag::V));

        // Write the result back to the destination register.
        if (result.write_back)
        {
            m_context[dest_reg_idx] = result.value;
        }

        if (result.set_flags)
        {
            //  R15 (PC) is used as the destination register.
            if (dest_reg_idx == CCPU_Context::PC_Reg_Idx)
            {
                if (m_context.Is_Mode_With_No_SPSR(m_context.Get_CPU_Mode()))
                {
                    // clang-format off
                    m_logging_system.Error(fmt::format("Attempt to write SPSR to CPSR from a "
                                                       "mode where SPSR is not supported ({})",
                                                       magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
                    // clang-format on

                    // Reset the CPU (SPSR is not supported in the current CPU mode).
                    throw exceptions::CReset{};
                }
                m_context.Set_CPSR(m_context.Get_SPSR());
            }
            else
            {
                // Set the flags set by the operation to the CPSR register.
                m_context.Set_Flag(CCPU_Context::NFlag::N, result.n_flag);
                m_context.Set_Flag(CCPU_Context::NFlag::Z, result.z_flag);
                m_context.Set_Flag(CCPU_Context::NFlag::C, result.c_flag);
                m_context.Set_Flag(CCPU_Context::NFlag::V, result.v_flag);
            }
        }
    }

    void CCPU_Core::Execute(isa::CBranch_And_Exchange instruction)
    {
        const auto rm_reg_value = m_context[instruction.Get_Rm_Idx()];

        // Make sure the CPU will not switch to the Thumb mode.
        if (instruction.Get_Instruction_Mode(rm_reg_value) == isa::CBranch_And_Exchange::NCPU_Instruction_Mode::Thumb)
        {
            m_logging_system.Error("Thumb instructions are not supported by the emulator");
        }

        // Check if we should branch with link.
        if (instruction.Is_L_Bit_Set())
        {
            LR() = PC();
        }

        // Ignore the LSB (if the LSB == 1, the CPU switches off to a thumb mode).
        PC() = rm_reg_value & 0xFFFFFFFEU;
    }

    void CCPU_Core::Execute(isa::CBranch instruction)
    {
        // Check if we should branch with link.
        if (instruction.Is_L_Bit_Set())
        {
            LR() = PC();
        }

        // Get the offset to be added to the PC register.
        const auto offset = instruction.Get_Offset();

        // Calculate the destination address.
        if (offset < 0)
        {
            PC() -= static_cast<std::uint32_t>(-offset);
        }
        else
        {
            PC() += static_cast<std::uint32_t>(offset);
        }

        // PC is already pointing at the next instruction. Hence, +4 and not +8.
        PC() += CCPU_Context::Reg_Size;
    }

    void CCPU_Core::Execute(isa::CMultiply instruction)
    {
        // Execute the operation on the MAC.
        const auto result = mac::Execute(instruction,
                                         m_context[instruction.Get_Rm_Idx()],
                                         m_context[instruction.Get_Rs_Idx()],
                                         m_context[instruction.Get_Rn_Idx()]);

        // Set the flags in the CPSR register.
        if (result.set_fags)
        {
            m_context.Set_Flag(CCPU_Context::NFlag::N, result.n_flag);
            m_context.Set_Flag(CCPU_Context::NFlag::Z, result.z_flag);
        }

        // Store the result of the multiplication to the destination register.
        m_context[instruction.Get_Rd_Idx()] = result.value_lo;
    }

    void CCPU_Core::Execute(isa::CMultiply_Long instruction)
    {
        const auto reg_rd_lo = instruction.Get_Rd_Lo_Idx();
        const auto reg_rd_hi = instruction.Get_Rd_Hi_Idx();

        // Execute the operation on the MAC.
        const auto result = mac::Execute(instruction,
                                         m_context[instruction.Get_Rm_Idx()],
                                         m_context[instruction.Get_Rs_Idx()],
                                         m_context[reg_rd_lo],
                                         m_context[reg_rd_hi]);

        // Set the flags in the CPSR register.
        if (result.set_fags)
        {
            m_context.Set_Flag(CCPU_Context::NFlag::N, result.n_flag);
            m_context.Set_Flag(CCPU_Context::NFlag::Z, result.z_flag);
        }

        // Store the result of the multiplication to the destination registers.
        m_context[reg_rd_lo] = result.value_lo; // lower 32-bits
        m_context[reg_rd_hi] = result.value_hi; // upper 32-bits
    }

    std::int64_t CCPU_Core::Get_Offset(isa::CSingle_Data_Transfer instruction) const noexcept
    {
        std::int64_t offset{};

        // Immediate offset?
        if (!instruction.Is_I_Bit_Set())
        {
            offset = static_cast<std::int64_t>(instruction.Get_Immediate_Offset());
        }
        else
        {
            // Apply a shift operation to the Rm register.
            // clang-format off
            offset = static_cast<std::int64_t>(Perform_Shift(instruction.Get_Shift_Type(),
                                                             instruction.Get_Shift_Amount(),
                                                             m_context[instruction.Get_Rm_Idx()]).result);
            // clang-format on
        }

        // Check whether the offset should be added or subtracted from the base register.
        if (!instruction.Is_U_Bit_Set())
        {
            return -offset;
        }

        return offset;
    }

    void CCPU_Core::Execute(isa::CSingle_Data_Transfer instruction)
    {
        const bool pre_indexed = instruction.Is_P_Bit_Set();
        const auto reg_rn_idx = instruction.Get_Rn_Idx();
        const auto base_addr =
        reg_rn_idx == CCPU_Context::PC_Reg_Idx ? (PC() + CCPU_Context::Reg_Size) : m_context[reg_rn_idx];

        // Calculate the offset to be added to the base register.
        const auto offset = Get_Offset(instruction);
        const auto indexed_addr = static_cast<std::uint32_t>(static_cast<std::int64_t>(base_addr) + offset);

        // Calculate the base address based on the pre/post indexing bit.
        const auto addr = pre_indexed ? indexed_addr : base_addr;

        if (instruction.Is_B_Bit_Set())
        {
            // 8-bit data transfer
            Read_Write_Value<std::uint8_t>(instruction, addr, instruction.Get_Rd_Idx());
        }
        else
        {
            // 32-bit data transfer
            Read_Write_Value<std::uint32_t>(instruction, addr, instruction.Get_Rd_Idx());
        }

        // Update the Rn register.
        if (!pre_indexed || instruction.Is_W_Bit_Set())
        {
            m_context[instruction.Get_Rn_Idx()] = indexed_addr;
        }
    }

    CCPU_Context::NCPU_Mode CCPU_Core::Determine_CPU_Mode(isa::CBlock_Data_Transfer instruction) const
    {
        const bool store_value = !instruction.Is_L_Bit_Set();
        const bool s_bit = instruction.Is_S_Bit_Set();
        const auto register_list = instruction.Get_Register_List();
        const bool r15_is_listed = utils::math::Is_Bit_Set<std::uint32_t>(register_list, CCPU_Context::PC_Reg_Idx);

        if ((!r15_is_listed && s_bit) || (store_value && r15_is_listed && s_bit))
        {
            // Use the USER mode.
            return CCPU_Context::NCPU_Mode::User;
        }

        // Use whatever mode the CPU is currently in.
        return m_context.Get_CPU_Mode();
    }

    void CCPU_Core::Execute(isa::CBlock_Data_Transfer instruction)
    {
        const auto register_list = instruction.Get_Register_List();
        const auto number_of_regs = static_cast<std::uint32_t>(std::popcount(register_list));
        const auto base_reg_idx = instruction.Get_Rn_Idx();

        const bool store_value = !instruction.Is_L_Bit_Set();
        const bool s_bit = instruction.Is_S_Bit_Set();
        const auto cpu_mode = Determine_CPU_Mode(instruction);

        // Calculate the base address.
        auto addr = Calculate_Base_Address(instruction, base_reg_idx, cpu_mode, number_of_regs);

        // Iterate over all registers and check whether they are on the list.
        for (std::uint32_t reg_idx = 0; reg_idx < CCPU_Context::Number_Of_Regs; ++reg_idx)
        {
            // Skip the current register if it is not on the list.
            if (!utils::math::Is_Bit_Set<std::uint32_t>(register_list, reg_idx))
            {
                continue;
            }

            if (store_value)
            {
                // Write data to the bus.
                Write<std::uint32_t>(addr, m_context.Get_Register(reg_idx, cpu_mode));
            }
            else
            {
                // Read data from the bus.
                m_context.Get_Register(reg_idx, cpu_mode) = Read<std::uint32_t>(addr);

                if (s_bit && reg_idx == CCPU_Context::PC_Reg_Idx)
                {
                    if (m_context.Is_Mode_With_No_SPSR(m_context.Get_CPU_Mode()))
                    {
                        // clang-format off
                        m_logging_system.Error(fmt::format("There is no SPSR register in the {} mode",
                                                           magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
                        // clang-format on

                        // Reset the CPU (SPSR is not supported in the current CPU mode).
                        throw exceptions::CReset{};
                    }

                    m_context.Set_CPSR(m_context.Get_SPSR());
                }
            }

            // Move on to the next address (+4B).
            addr += CCPU_Context::Reg_Size;
        }

        if (instruction.Is_W_Bit_Set())
        {
            const std::uint32_t total_size_transferred{ CCPU_Context::Reg_Size * number_of_regs };

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
        // Is it an immediate offset (4 + 4 bits)?
        if (instruction.Is_Immediate_Offset())
        {
            const auto high_4_bits = instruction.Get_Immediate_Offset_High();
            const auto low_4_bits = instruction.Get_Immediate_Offset_Low();

            return (high_4_bits << 4U) | low_4_bits;
        }

        // Return the contents of the Rm register.
        return m_context[instruction.Get_Rm_Idx()];
    }

    void CCPU_Core::Perform_Halfword_Data_Transfer_Read(isa::CHalfword_Data_Transfer::NType type,
                                                        std::uint32_t addr,
                                                        std::uint32_t dest_reg_idx)
    {
        // Value read from the bus (either 8 or 16 bits).
        std::variant<std::uint8_t, std::uint16_t> read_value;

        switch (type)
        {
            case isa::CHalfword_Data_Transfer::NType::SWP:
                // TODO what does this do - it is not be supported in ARMv6?
                break;

            // Read an unsigned 16-bit value from the bus.
            case isa::CHalfword_Data_Transfer::NType::Unsigned_Halfwords:
                m_context[dest_reg_idx] = Read<std::uint16_t>(addr);
                break;

            // Read a signed 8-bit value from the bus.
            case isa::CHalfword_Data_Transfer::NType::Signed_Byte:
                read_value = Read<std::uint8_t>(addr);
                m_context[dest_reg_idx] = utils::math::Sign_Extend_Value(std::get<std::uint8_t>(read_value));
                break;

            // Read a signed 16-bit value from the bus.
            case isa::CHalfword_Data_Transfer::NType::Signed_Halfwords:
                read_value = Read<std::uint16_t>(addr);
                m_context[dest_reg_idx] = utils::math::Sign_Extend_Value(std::get<std::uint16_t>(read_value));
                break;
        }
    }

    void CCPU_Core::Perform_Halfword_Data_Transfer_Write(isa::CHalfword_Data_Transfer::NType type,
                                                         std::uint32_t addr,
                                                         std::uint32_t src_reg_idx)
    {
        switch (type)
        {
            // TODO verify this
            // Only Unsigned_Halfwords can be written to the bus.
            case isa::CHalfword_Data_Transfer::NType::Unsigned_Halfwords:
                Write<std::uint16_t>(addr, static_cast<std::uint16_t>(m_context[src_reg_idx] & 0x0000FFFFU));
                break;

            case isa::CHalfword_Data_Transfer::NType::SWP:
                [[fallthrough]];
            case isa::CHalfword_Data_Transfer::NType::Signed_Byte:
            case isa::CHalfword_Data_Transfer::NType::Signed_Halfwords:
                // Something went wrong if the execution gets here.
                // clang-format off
                m_logging_system.Warning("Only unsigned halfwords should be used "
                                         "when performing a halfword data write");
                // clang-format on
                break;
        }
    }

    void CCPU_Core::Execute(isa::CHalfword_Data_Transfer instruction)
    {
        const auto offset = Get_Offset(instruction);
        const auto src_dest_reg_idx = instruction.Get_Rd_Idx();
        const auto operation_type = instruction.Get_Type();
        const bool pre_indexed = instruction.Is_P_Bit_Set();

        auto base_addr = m_context[instruction.Get_Rn_Idx()];
        std::uint32_t pre_indexed_addr{ base_addr };

        // Add the offset to the base address.
        if (instruction.Is_U_Bit_Set())
        {
            pre_indexed_addr += offset;
        }
        else
        {
            pre_indexed_addr -= offset;
        }

        // Determine what base should be used (pre-index or not?)
        const auto addr = pre_indexed ? pre_indexed_addr : base_addr;

        if (instruction.Is_L_Bit_Set())
        {
            // Read data from the bus.
            Perform_Halfword_Data_Transfer_Read(operation_type, addr, src_dest_reg_idx);
        }
        else
        {
            // Write data to the bus.
            Perform_Halfword_Data_Transfer_Write(operation_type, addr, src_dest_reg_idx);
        }

        // Write the base address back to the Rn register.
        if (!pre_indexed || instruction.Is_W_Bit_Set())
        {
            m_context[instruction.Get_Rn_Idx()] = pre_indexed_addr;
        }
    }

    void CCPU_Core::Execute(isa::CExtend instruction)
    {
        // Register indexes.
        const auto reg_rd_idx = instruction.Get_Rd_Idx();
        const auto reg_rm_idx = instruction.Get_Rm_Idx();
        const auto reg_rn_idx = instruction.Get_Rn_Idx();

        // Perform ROR (right rotation) on the Rm register.
        // clang-format off
        const std::unsigned_integral auto rotated_value = utils::math::ROR(m_context[reg_rm_idx],
                                                                           instruction.Get_Rot());
        // clang-format on

        // Sign-extend the value from 8 to 16 bits (lower 8 and higher 8).
        const std::uint16_t sign_extended_lower_8_to_16 =
        utils::math::Sign_Extend_Value<std::uint8_t, std::uint16_t>(rotated_value & 0xFFU);
        const std::uint16_t sign_extended_higher_8_to_16 =
        utils::math::Sign_Extend_Value<std::uint8_t, std::uint16_t>(((rotated_value & 0xFF0000U) >> 16U) & 0xFFU);

        // Sign-extend the value from 8 to 32 bits.
        const std::uint32_t sign_extended_8_to_32 =
        utils::math::Sign_Extend_Value<std::uint8_t, std::uint32_t>(rotated_value & 0xFFU);

        // Sign-extend the value from 16 to 32 bits.
        const std::uint32_t sign_extended_16_to_32 =
        utils::math::Sign_Extend_Value<std::uint16_t, std::uint32_t>(rotated_value & 0xFFFFU);

        // Calculate the result lower and higher 16 bits (unsigned)
        const std::uint16_t lower_16_bits_unsigned =
        static_cast<std::uint16_t>(rotated_value & 0xFFU) + static_cast<std::uint16_t>(m_context[reg_rn_idx] & 0xFFFFU);
        const std::uint16_t higher_16_bits_unsigned =
        static_cast<std::uint16_t>((rotated_value & 0xFF0000U) >> 16U) +
        static_cast<std::uint16_t>((m_context[reg_rn_idx] & 0xFFFF0000U) >> 16U);

        // Calculate the result lower and higher 16 bits (signed)
        const std::uint16_t lower_16_bits_signed =
        sign_extended_lower_8_to_16 + static_cast<std::uint16_t>(m_context[reg_rn_idx] & 0xFFFFU);
        const std::uint16_t higher_16_bits_singed =
        sign_extended_higher_8_to_16 + static_cast<std::uint16_t>((m_context[reg_rn_idx] & 0xFFFF0000) >> 16U);

        // Execute the instruction based on its type.
        switch (instruction.Get_Type())
        {
            case isa::CExtend::NType::SXTAB16:
                m_context[reg_rd_idx] = static_cast<std::uint32_t>(lower_16_bits_signed) |
                                        (static_cast<std::uint32_t>(higher_16_bits_singed) << 16U);
                break;

            case isa::CExtend::NType::UXTAB16:
                m_context[reg_rd_idx] = static_cast<std::uint32_t>(lower_16_bits_unsigned) |
                                        (static_cast<std::uint32_t>(higher_16_bits_unsigned) << 16U);
                break;

            case isa::CExtend::NType::SXTB16:
                m_context[reg_rd_idx] = static_cast<std::uint32_t>(sign_extended_lower_8_to_16) |
                                        static_cast<std::uint32_t>(sign_extended_higher_8_to_16) << 16U;
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
        // Get the mask (protection of different parts of the special register).
        const auto mask = instruction.Get_Mask();

        // Value to be moved to the special register (immediate or register).
        const auto new_value =
        instruction.Is_Immediate() ? Get_Second_Operand_Imm(instruction).result : m_context[instruction.Get_Rm_Idx()];

        // Update the special register in regard to the given mask - some parts (flag bits,
        // status bits, extension bits, control bits) might be protected, so they remain unchanged.
        const auto Update_Special_Register = [&mask, &new_value](std::uint32_t reg_value) -> std::uint32_t {
            reg_value &= ~mask;
            reg_value |= (new_value & mask);

            return reg_value;
        };

        switch (instruction.Get_Register_Type())
        {
            // Update the CPSR register.
            case isa::CPSR_Transfer::NRegister::CPSR:
                m_context.Set_CPSR(Update_Special_Register(m_context.Get_CPSR()));
                break;

            // Update the SPSR register.
            case isa::CPSR_Transfer::NRegister::SPSR:
                m_context.Set_SPSR(Update_Special_Register(m_context.Get_SPSR()));
                break;
        }
    }

    void CCPU_Core::Execute_MRS(isa::CPSR_Transfer instruction)
    {
        // Get the index of the destination register.
        const auto reg_rd_idx = instruction.Get_Rd_Idx();

        switch (instruction.Get_Register_Type())
        {
            // Store the current value of CPSR into Rd.
            case isa::CPSR_Transfer::NRegister::CPSR:
                m_context[reg_rd_idx] = m_context.Get_CPSR();
                break;

            // Store the current value of SPSR into Rd.
            case isa::CPSR_Transfer::NRegister::SPSR:
                m_context[reg_rd_idx] = m_context.Get_SPSR();
                break;
        }
    }

    void CCPU_Core::Execute(isa::CPSR_Transfer instruction)
    {
        switch (instruction.Get_Type())
        {
            // Transfer PSR contents to an ARM register.
            case isa::CPSR_Transfer::NType::MRS:
                Execute_MRS(instruction);
                break;

            // Transfer the content of an ARM register to PSR.
            case isa::CPSR_Transfer::NType::MSR:
                Execute_MSR(instruction);
                break;
        }
    }

    std::uint32_t CCPU_Core::Set_Interrupt_Mask_Bits(std::uint32_t cpsr, isa::CCPS instruction, bool set)
    {
        // Imprecise abort
        if (instruction.Is_A_Bit_Set())
        {
            CCPU_Context::Set_Flag(cpsr, CCPU_Context::NFlag::A, !set);
        }

        // Interrupts
        if (instruction.Is_I_Bit_Set())
        {
            CCPU_Context::Set_Flag(cpsr, CCPU_Context::NFlag::I, !set);
        }

        // Fast interrupts
        if (instruction.Is_F_Bit_Set())
        {
            CCPU_Context::Set_Flag(cpsr, CCPU_Context::NFlag::F, !set);
        }

        return cpsr;
    }

    void CCPU_Core::Execute(isa::CCPS instruction)
    {
        // The CPU has to be in a privileged mode to be able to modify the CPSR register.
        if (!m_context.Is_In_Privileged_Mode())
        {
            // clang-format off
            m_logging_system.Error(fmt::format("Attempt to execute a CPS instruction in a non-privileged mode ({})",
                                               magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
            // clang-format on

            // Reset the CPU.
            throw exceptions::CReset{};
        }

        // Retrieve the current value of the CPSR register.
        auto cpsr = m_context.Get_CPSR();

        // Set the control flags based on the instruction type.
        switch (instruction.Get_Type())
        {
            case isa::CCPS::NType::CPSIE:
                cpsr = Set_Interrupt_Mask_Bits(cpsr, instruction, true);
                break;

            case isa::CCPS::NType::CPSID:
                cpsr = Set_Interrupt_Mask_Bits(cpsr, instruction, false);
                break;
        }

        // Check if the mode of the CPU should be changed.
        if (instruction.Is_M_Bit_Set())
        {
            cpsr &= ~CCPU_Context::CPU_Mode_Mask;
            cpsr |= instruction.Get_Mode();
        }

        // Apply the changes to the CPSR register.
        m_context.Set_CPSR(cpsr);
    }

    void CCPU_Core::Check_Coprocessor_Existence(std::uint32_t coprocessor_id)
    {
        if (!m_coprocessors.contains(coprocessor_id))
        {
            m_logging_system.Error(fmt::format("CP{} is not present", coprocessor_id).c_str());

            // The CPU will throw an exception if there is an attempt
            // to make use of a coprocessor which is not present.
            throw exceptions::CUndefined_Instruction{};
        }
    }

    void CCPU_Core::Execute(isa::CCoprocessor_Reg_Transfer instruction)
    {
        // Get the coprocessor ID.
        const auto coprocessor_id = instruction.Get_Coprocessor_ID();

        // Make sure the coprocessor is present.
        Check_Coprocessor_Existence(coprocessor_id);

        // Pass the instruction to the coprocessor.
        m_coprocessors[coprocessor_id]->Perform_Register_Transfer(instruction);
    }

    void CCPU_Core::Execute(isa::CCoprocessor_Data_Transfer instruction)
    {
        // Get the coprocessor ID.
        const auto coprocessor_id = instruction.Get_Coprocessor_ID();

        // Make sure the coprocessor is present.
        Check_Coprocessor_Existence(coprocessor_id);

        // Pass the instruction to the coprocessor.
        m_coprocessors[coprocessor_id]->Perform_Data_Transfer(instruction);
    }

    void CCPU_Core::Execute(isa::CCoprocessor_Data_Operation instruction)
    {
        // Get the coprocessor ID.
        const auto coprocessor_id = instruction.Get_Coprocessor_ID();

        // Make sure the coprocessor is present.
        Check_Coprocessor_Existence(coprocessor_id);

        // Pass the instruction to the coprocessor.
        m_coprocessors[coprocessor_id]->Perform_Data_Operation(instruction);
    }

    void CCPU_Core::Execute(isa::CSRS instruction)
    {
        // This instruction must be executed in a privileged mode.
        if (!m_context.Is_In_Privileged_Mode())
        {
            // clang-format off
            m_logging_system.Error(fmt::format("Attempt execute an SRS instruction in a non-privileged mode ({})",
                                               magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
            // clang-format on

            // Reset the CPU.
            throw exceptions::CReset{};
        }

        // Get the CPU mode used in the instruction.
        const auto cpu_mode = static_cast<CCPU_Context::NCPU_Mode>(instruction.Get_CPU_Mode());

        // clang-format off
        // Calculate the base address (where PC and SPSR should be stored).
        const auto addr = Calculate_Base_Address(instruction,
                                                 CCPU_Context::SP_Reg_Idx,
                                                 cpu_mode,
                                                 isa::CSRS::Number_Of_Regs_To_Transfer);
        // clang-format on

        // Store the registers of the current mode onto the stack.
        Write<std::uint32_t>(addr, m_context[CCPU_Context::LR_Reg_Idx]);
        Write<std::uint32_t>(addr + CCPU_Context::Reg_Size, m_context.Get_SPSR());

        // Write the final address back to SP of the mode defined in the instruction.
        if (instruction.Is_W_Bit_Set())
        {
            // Total size that has been transferred.
            static constexpr std::uint32_t total_size_transferred{ CCPU_Context::Reg_Size *
                                                                   isa::CSRS::Number_Of_Regs_To_Transfer };

            if (instruction.Should_SP_Be_Decremented())
            {
                m_context.Get_Register(CCPU_Context::SP_Reg_Idx, cpu_mode) -= total_size_transferred;
            }
            else
            {
                m_context.Get_Register(CCPU_Context::SP_Reg_Idx, cpu_mode) += total_size_transferred;
            }
        }
    }

    void CCPU_Core::Execute(isa::CRFE instruction)
    {
        // This instruction must be executed in a privileged mode.
        if (!m_context.Is_In_Privileged_Mode())
        {
            // clang-format off
            m_logging_system.Error(fmt::format("Attempt execute an RFE instruction in a non-privileged mode ({})",
                                               magic_enum::enum_name(m_context.Get_CPU_Mode())).c_str());
            // clang-format on

            // Reset the CPU.
            throw exceptions::CReset{};
        }

        const auto reg_rn_idx = instruction.Get_Rn_Idx();
        const auto cpu_mode = m_context.Get_CPU_Mode();

        // Calculate the base address, taking into account the base address register as well as the addressing mode.
        auto addr = Calculate_Base_Address(instruction, reg_rn_idx, cpu_mode, isa::CRFE::Number_Of_Regs_To_Transfer);

        // Read LR and SPSR off the stack.
        const auto lr = Read<std::uint32_t>(addr);
        const auto spsr = Read<std::uint32_t>(addr + CCPU_Context::Reg_Size);

        // Write the final address back to Rn.
        if (instruction.Is_W_Bit_Set())
        {
            // Total size that has been transferred.
            static constexpr std::uint32_t total_size_transferred{ CCPU_Context::Reg_Size *
                                                                   isa::CRFE::Number_Of_Regs_To_Transfer };

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

        // Update the PC and CPSR register.
        PC() = lr;
        m_context.Set_CPSR(spsr);
    }

    void CCPU_Core::Execute(isa::CCLZ instruction)
    {
        const auto rm_reg = m_context[instruction.Get_Rm_Idx()];
        std::uint32_t leading_zeros{ 0 };

        // Calculate the number of leading zeros.
        for (std::int32_t i = std::numeric_limits<std::uint32_t>::digits - 1; i >= 0; --i)
        {
            // Check if the current bit is set to a 1.
            if (utils::math::Is_Bit_Set(rm_reg, static_cast<std::uint32_t>(i)))
            {
                break;
            }

            ++leading_zeros;
        }

        // Store the result in the Rd register.
        m_context[instruction.Get_Rd_Idx()] = leading_zeros;
    }

    void CCPU_Core::Execute(isa::CSMULWy instruction)
    {
        Sign_Multiply_Accumulate_Word_Halfword(instruction);
    }

    void CCPU_Core::Execute(isa::CSMLAWy instruction)
    {
        Sign_Multiply_Accumulate_Word_Halfword(instruction);
    }

    void CCPU_Core::Execute(isa::CSMULxy instruction)
    {
        Sign_Multiply_Accumulate(instruction);
    }

    void CCPU_Core::Execute(isa::CSMLAxy instruction)
    {
        Sign_Multiply_Accumulate(instruction);
    }

    template<typename Instruction>
    void CCPU_Core::Sign_Multiply_Accumulate_Word_Halfword(Instruction instruction)
    {
        // Retrieve the type of the instruction.
        const auto type = instruction.Get_Type();

        // Retrieve the register indexes.
        const auto rd_idx = instruction.Get_Rd_Idx();
        const auto rm_idx = instruction.Get_Rm_Idx();
        const auto rs_idx = instruction.Get_Rs_Idx();

        // Convert the first operand into signed 32-bit integer.
        const auto op1 = static_cast<std::int32_t>(m_context[rm_idx]);
        std::int16_t op2{};

        std::uint32_t acc_value{ 0 };

        // Retrieve the accumulate value based on the type of the instruction.
        if constexpr (std::is_same<Instruction, isa::CSMLAWy>::value)
        {
            acc_value = m_context[instruction.Get_Rn_Idx()];
        }

        // Get the second as a signed 16-bit integer.
        switch (type)
        {
            // Bottom 16 bits
            case Instruction::NType::B:
                op2 = static_cast<std::int16_t>(m_context[rs_idx] & 0xFFFFU);
                break;

            // Upper 16 bits
            case Instruction::NType::T:
                op2 = static_cast<std::int16_t>(m_context[rs_idx] >> 16U);
                break;
        }

        // Calculate the result (only store the upper 32 bits of the 48-bit result).
        m_context[rd_idx] = static_cast<std::uint32_t>(static_cast<std::uint64_t>(op1 * op2) >> 16U);
        m_context[rd_idx] += acc_value;
    }

    template<typename Instruction>
    void CCPU_Core::Sign_Multiply_Accumulate(Instruction instruction)
    {
        // Retrieve the type of the instruction.
        const auto type = instruction.Get_Type();

        // Retrieve the register indexes.
        const auto rd_idx = instruction.Get_Rd_Idx();
        const auto rm_idx = instruction.Get_Rm_Idx();
        const auto rs_idx = instruction.Get_Rs_Idx();

        std::uint32_t acc_value{ 0 };

        // Retrieve the accumulate value based on the type of the instruction.
        if constexpr (std::is_same<Instruction, isa::CSMLAxy>::value)
        {
            acc_value = m_context[instruction.Get_Rn_Idx()];
        }

        switch (type)
        {
            // Bottom 16 bits | bottom 16 bits
            case Instruction::NType::BB:
                m_context[rd_idx] = static_cast<std::uint32_t>(static_cast<std::int16_t>(m_context[rm_idx] & 0xFFFFU) *
                                                               static_cast<std::int16_t>(m_context[rs_idx] & 0xFFFFU));
                break;

            // Bottom 16 bits | upper 16 bits
            case Instruction::NType::BT:
                m_context[rd_idx] = static_cast<std::uint32_t>(static_cast<std::int16_t>(m_context[rm_idx] & 0xFFFFU) *
                                                               static_cast<std::int16_t>(m_context[rs_idx] >> 16U));
                break;

            // Upper 16 bits | bottom 16 bits
            case Instruction::NType::TB:
                m_context[rd_idx] = static_cast<std::uint32_t>(static_cast<std::int16_t>(m_context[rm_idx] >> 16U) *
                                                               static_cast<std::int16_t>(m_context[rs_idx] & 0xFFFFU));
                break;

            // Upper 16 bits | upper 16 bits
            case Instruction::NType::TT:
                m_context[rd_idx] = static_cast<std::uint32_t>(static_cast<std::int16_t>(m_context[rm_idx] >> 16U) *
                                                               static_cast<std::int16_t>(m_context[rs_idx] >> 16U));
                break;
        }

        // Add the accumulate value to the destination register.
        m_context[rd_idx] += acc_value;
    }

    [[nodiscard]] std::uint32_t CCPU_Core::Convert_Virtual_Addr_To_Physical_Addr(std::uint32_t virtual_addr,
                                                                                 bool write_access)
    {
        // If the MMU is not preset, or it is not enabled, then virtual addr = physical addr.
        if (m_mmu != nullptr && m_mmu->Is_Enabled())
        {
            return m_mmu->Get_Physical_Addr(virtual_addr, m_context, write_access);
        }

        return virtual_addr;
    }

    template<typename Instruction>
    [[nodiscard]] std::uint32_t CCPU_Core::Calculate_Base_Address(Instruction instruction,
                                                                  std::uint32_t base_reg_idx,
                                                                  CCPU_Context::NCPU_Mode cpu_mode,
                                                                  std::uint32_t number_of_regs) const
    {
        switch (instruction.Get_Addressing_Mode())
        {
            // Increment before
            case Instruction::NAddressing_Mode::IB:
                return m_context.Get_Register(base_reg_idx, cpu_mode) + CCPU_Context::Reg_Size;

            // Increment after
            case Instruction::NAddressing_Mode::IA:
                return m_context.Get_Register(base_reg_idx, cpu_mode);

            // Decrement before
            case Instruction::NAddressing_Mode::DB:
                return m_context.Get_Register(base_reg_idx, cpu_mode) - (number_of_regs * CCPU_Context::Reg_Size);

            // Decrement after
            case Instruction::NAddressing_Mode::DA:
                return m_context.Get_Register(base_reg_idx, cpu_mode) - (number_of_regs * CCPU_Context::Reg_Size) +
                       CCPU_Context::Reg_Size;
        }

        return {}; // Just so the compiler does not gripe about a missing return value.
    }

    template<typename Instruction>
    [[nodiscard]] utils::math::TShift_Result<std::uint32_t>
    CCPU_Core::Get_Second_Operand_Imm(Instruction instruction) const noexcept
    {
        // Retrieve the immediate value and the shift amount.
        // The shift amount is always multiplied by 2 - see the documentation.
        const std::uint32_t immediate = instruction.Get_Immediate();
        const std::uint32_t shift_amount = instruction.Get_Rotate() * 2;

        // Create the result.
        utils::math::TShift_Result<std::uint32_t> second_operand{ m_context.Is_Flag_Set(CCPU_Context::NFlag::C),
                                                                  immediate };

        // Perform ROR if possible.
        if (shift_amount != 0 && shift_amount != std::numeric_limits<std::uint32_t>::digits)
        {
            second_operand = utils::math::ROR(immediate, shift_amount, false);
        }

        return second_operand;
    }

    template<typename Type>
    void CCPU_Core::Write(std::uint32_t virtual_addr, Type value)
    {
        // Make sure the CPU is connected to the bus.
        assert(m_bus != nullptr);

        // Convert the virtual address into a physical address.
        const std::uint32_t physical_addr = Convert_Virtual_Addr_To_Physical_Addr(virtual_addr, true);

        // Write data to the bus.
        m_bus->Write<Type>(physical_addr, value);
    }

    template<typename Type>
    [[nodiscard]] Type CCPU_Core::Read(std::uint32_t virtual_addr)
    {
        // Make sure the CPU is connected to the bus.
        assert(m_bus != nullptr);

        // Convert the virtual address into a physical address.
        const std::uint32_t physical_addr = Convert_Virtual_Addr_To_Physical_Addr(virtual_addr, false);

        // Write data to the bus.
        return m_bus->Read<Type>(physical_addr);
    }

    template<std::unsigned_integral Type>
    void CCPU_Core::Read_Write_Value(isa::CSingle_Data_Transfer instruction,
                                     std::uint32_t virtual_addr,
                                     std::uint32_t reg_idx)
    {
        if (instruction.Is_L_Bit_Set())
        {
            m_context[reg_idx] = Read<Type>(virtual_addr);
        }
        else
        {
            Write<Type>(virtual_addr, static_cast<Type>(m_context[reg_idx]));
        }
    }
}
