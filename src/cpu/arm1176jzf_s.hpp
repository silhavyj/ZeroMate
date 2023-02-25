#pragma once

#include <array>
#include <limits>
#include <cstdint>
#include <memory>
#include <initializer_list>

#include "isa/isa.hpp"
#include "registers/cspr.hpp"
#include "instruction_decoder.hpp"
#include "mocks/ram.hpp"
#include "../utils/math.hpp"

namespace zero_mate::cpu
{
    class CARM1176JZF_S final
    {
    public:
        static constexpr std::size_t NUMBER_OF_REGS = 16;
        static constexpr std::size_t PC_REG_IDX = 15;
        static constexpr std::size_t LR_REG_IDX = 14;
        static constexpr std::size_t SP_REG_IDX = 13;
        static constexpr auto MAX_ADDR = std::numeric_limits<std::uint32_t>::max() - sizeof(std::uint32_t);

        CARM1176JZF_S() noexcept;
        CARM1176JZF_S(std::uint32_t pc, std::shared_ptr<mocks::CRAM> ram);

        void Step(std::size_t count);
        void Step();
        void Execute(std::initializer_list<isa::CInstruction> instructions);

    private:
        [[nodiscard]] std::uint32_t& PC() noexcept;
        [[nodiscard]] std::uint32_t& LR() noexcept;
        [[nodiscard]] std::uint32_t& SP() noexcept;
        [[nodiscard]] isa::CInstruction Fetch_Instruction();

        [[nodiscard]] bool Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept;
        [[nodiscard]] std::uint32_t Get_Shift_Amount(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand_Imm(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand(isa::CData_Processing instruction) const noexcept;

        void Execute(isa::CInstruction instruction);
        void Execute(isa::CBranch_And_Exchange instruction) noexcept;
        void Execute(isa::CBranch instruction) noexcept;
        void Execute(isa::CData_Processing instruction) noexcept;
        void Execute(isa::CMultiply instruction) noexcept;
        void Execute(isa::CMultiply_Long instruction) noexcept;

    public:
        std::array<std::uint32_t, NUMBER_OF_REGS> m_regs;
        CCSPR m_cspr;
        CInstruction_Decoder m_instruction_decoder;
        std::shared_ptr<mocks::CRAM> m_ram;
    };
}