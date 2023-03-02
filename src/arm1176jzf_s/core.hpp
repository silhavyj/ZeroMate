#pragma once

#include <array>
#include <limits>
#include <cstdint>
#include <memory>
#include <cassert>
#include <initializer_list>

#include "isa/isa.hpp"
#include "isa/isa_decoder.hpp"
#include "registers/cspr.hpp"
#include "mocks/ram.hpp"
#include "../utils/math.hpp"

namespace zero_mate::arm1176jzf_s
{
    class CCPU_Core final
    {
    public:
        static constexpr auto REG_SIZE = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        static constexpr std::size_t NUMBER_OF_REGS = 16;
        static constexpr std::size_t PC_REG_IDX = 15;
        static constexpr std::size_t LR_REG_IDX = 14;
        static constexpr std::size_t SP_REG_IDX = 13;

        CCPU_Core() noexcept;
        CCPU_Core(std::uint32_t pc, std::shared_ptr<mocks::CRAM> ram) noexcept;

        void Run(std::uint32_t last_execution_addr);
        void Step(std::size_t count);
        void Step();
        void Execute(std::initializer_list<isa::CInstruction> instructions);

    private:
        [[nodiscard]] std::uint32_t& PC() noexcept;
        [[nodiscard]] std::uint32_t& LR() noexcept;
        [[nodiscard]] isa::CInstruction Fetch_Instruction();

        [[nodiscard]] bool Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept;
        [[nodiscard]] std::uint32_t Get_Shift_Amount(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand_Imm(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Perform_Shift(isa::CInstruction::NShift_Type shift_type, std::uint32_t shift_amount, std::uint32_t shift_reg) const noexcept;
        [[nodiscard]] std::int64_t Get_Offset(isa::CSingle_Data_Transfer instruction) const noexcept;
        [[nodiscard]] std::uint32_t Get_Offset(isa::CHalfword_Data_Transfer instruction) const noexcept;
        void Perform_Halfword_Data_Transfer_Read(isa::CHalfword_Data_Transfer::NType type, std::uint32_t addr, std::uint32_t src_dest_reg);

        void Execute(isa::CInstruction instruction);
        void Execute(isa::CBranch_And_Exchange instruction) noexcept;
        void Execute(isa::CBranch instruction) noexcept;
        void Execute(isa::CData_Processing instruction) noexcept;
        void Execute(isa::CMultiply instruction) noexcept;
        void Execute(isa::CMultiply_Long instruction) noexcept;
        void Execute(isa::CSingle_Data_Transfer instruction);
        void Execute(isa::CBlock_Data_Transfer instruction);
        void Execute(isa::CHalfword_Data_Transfer instruction);
        void Execute(isa::CSW_Interrupt instruction);

        template<std::unsigned_integral Type>
        void Read_Write_Value(isa::CSingle_Data_Transfer instruction, std::uint32_t addr, std::uint32_t reg_idx)
        {
            assert(m_ram != nullptr);

            // TODO do this check in IBus once it is implemented
            if (static_cast<std::size_t>(addr) % sizeof(Type) != 0)
            {
                // TODO react appropriately (abort, throw an exception?)
            }

            if (instruction.Is_L_Bit_Set())
            {
                m_regs.at(reg_idx) = m_ram->Read<Type>(addr);
            }
            else
            {
                m_ram->Write<Type>(addr, static_cast<Type>(m_regs.at(reg_idx)));
            }
        }

        template<std::unsigned_integral Type>
        [[nodiscard]] static std::uint32_t Sign_Extend_Value(Type value) noexcept
        {
            static_assert(std::numeric_limits<Type>::digits < std::numeric_limits<std::uint32_t>::digits);

            if (utils::math::Is_Negative<Type>(value))
            {
                auto mask = static_cast<std::uint32_t>(-1);

                for (std::size_t i = 0; i < sizeof(Type); ++i)
                {
                    mask <<= static_cast<std::uint32_t>(std::numeric_limits<std::uint8_t>::digits);
                }

                return mask | static_cast<std::uint32_t>(value);
            }

            return static_cast<std::uint32_t>(value);
        }

    public:
        std::array<std::uint32_t, NUMBER_OF_REGS> m_regs;
        CCSPR m_cspr;
        isa::CISA_Decoder m_instruction_decoder;
        std::shared_ptr<mocks::CRAM> m_ram;
    };
}