#pragma once

#include <array>
#include <limits>
#include <memory>
#include <cstdint>
#include <cassert>
#include <optional>
#include <unordered_set>
#include <initializer_list>

#include "context.hpp"
#include "isa/isa.hpp"
#include "exceptions.hpp"
#include "isa/isa_decoder.hpp"
#include "../utils/math.hpp"
#include "../peripherals/bus.hpp"
#include "../utils/logger/logger.hpp"
#include "../peripherals/interrupt_controller.hpp"
#include "../peripherals/arm_timer.hpp"

namespace zero_mate::arm1176jzf_s
{
    class CCPU_Core final
    {
    public:
        static constexpr std::uint32_t DEFAULT_ENTRY_POINT = 0x8000;

        CCPU_Core() noexcept;
        CCPU_Core(std::uint32_t pc, std::shared_ptr<CBus> bus) noexcept;

        void Set_Interrupt_Controller(std::shared_ptr<peripheral::CInterrupt_Controller> interrupt_controller);
        void Set_ARM_Timer(std::shared_ptr<peripheral::CARM_Timer> arm_timer);

        void Reset_Context();

        void Set_PC(std::uint32_t pc);
        void Add_Breakpoint(std::uint32_t addr);
        void Remove_Breakpoint(std::uint32_t addr);
        void Run();
        void Steps(std::size_t count);
        bool Step(bool ignore_breakpoint = false);
        void Execute(std::initializer_list<isa::CInstruction> instructions);

    private:
        [[nodiscard]] std::uint32_t& PC() noexcept;
        [[nodiscard]] const std::uint32_t& PC() const noexcept;
        [[nodiscard]] std::uint32_t& LR() noexcept;
        [[nodiscard]] const std::uint32_t& LR() const noexcept;

        [[nodiscard]] std::optional<isa::CInstruction> Fetch_Instruction();

        [[nodiscard]] bool Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept;
        [[nodiscard]] std::uint32_t Get_Shift_Amount(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Perform_Shift(isa::CInstruction::NShift_Type shift_type, std::uint32_t shift_amount, std::uint32_t shift_reg) const noexcept;
        [[nodiscard]] std::int64_t Get_Offset(isa::CSingle_Data_Transfer instruction) const noexcept;
        [[nodiscard]] std::uint32_t Get_Offset(isa::CHalfword_Data_Transfer instruction) const noexcept;
        void Perform_Halfword_Data_Transfer_Read(isa::CHalfword_Data_Transfer::NType type, std::uint32_t addr, std::uint32_t dest_reg);
        void Perform_Halfword_Data_Transfer_Write(isa::CHalfword_Data_Transfer::NType type, std::uint32_t addr, std::uint32_t src_reg);
        void Execute_MSR(isa::CPSR_Transfer instruction);
        void Execute_MRS(isa::CPSR_Transfer instruction);
        void Execute_Exception(const exceptions::CCPU_Exception& exception);
        [[nodiscard]] static inline std::uint32_t Set_Interrupt_Mask_Bits(std::uint32_t cpsr, isa::CCPS instruction, bool set);
        [[nodiscard]] CCPU_Context::NCPU_Mode Determine_CPU_Mode(isa::CBlock_Data_Transfer instruction) const;
        [[nodiscard]] std::uint32_t Calculate_Base_Address(isa::CBlock_Data_Transfer instruction, std::uint32_t base_reg_idx, CCPU_Context::NCPU_Mode cpu_mode, std::uint32_t number_of_regs) const;

        void Execute(isa::CInstruction instruction);
        void Execute(isa::CBranch_And_Exchange instruction) noexcept;
        void Execute(isa::CBranch instruction);
        void Execute(isa::CData_Processing instruction);
        void Execute(isa::CMultiply instruction);
        void Execute(isa::CMultiply_Long instruction);
        void Execute(isa::CSingle_Data_Transfer instruction);
        void Execute(isa::CBlock_Data_Transfer instruction);
        void Execute(isa::CHalfword_Data_Transfer instruction);
        void Execute(isa::CExtend instruction);
        void Execute(isa::CPSR_Transfer instruction);
        void Execute(isa::CCPS instruction);

        template<typename Instruction>
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand_Imm(Instruction instruction) const noexcept
        {
            const std::uint32_t immediate = instruction.Get_Immediate();
            const std::uint32_t shift_amount = instruction.Get_Rotate() * 2;

            utils::math::TShift_Result<std::uint32_t> second_operand{ m_context.Is_Flag_Set(CCPU_Context::NFlag::C), immediate };

            if (shift_amount != 0 && shift_amount != std::numeric_limits<std::uint32_t>::digits)
            {
                second_operand = utils::math::ROR(immediate, shift_amount, false);
            }

            return second_operand;
        }

        template<std::unsigned_integral Type>
        void Read_Write_Value(isa::CSingle_Data_Transfer instruction, std::uint32_t addr, std::uint32_t reg_idx)
        {
            assert(m_bus != nullptr);

            if (instruction.Is_L_Bit_Set())
            {
                m_context[reg_idx] = m_bus->Read<Type>(addr);
            }
            else
            {
                m_bus->Write<Type>(addr, static_cast<Type>(m_context[reg_idx]));
            }
        }

    public:
        CCPU_Context m_context;

    private:
        isa::CISA_Decoder m_instruction_decoder;
        std::shared_ptr<CBus> m_bus;
        std::unordered_set<std::uint32_t> m_breakpoints;
        utils::CLogging_System& m_logging_system;
        std::uint32_t m_entry_point;
        std::shared_ptr<peripheral::CInterrupt_Controller> m_interrupt_controller;
        std::shared_ptr<peripheral::CARM_Timer> m_arm_timer;
    };
}