#pragma once

#include <array>
#include <limits>
#include <cstdint>
#include <initializer_list>

#include "../utils/math.hpp"
#include "registers/cspr.hpp"
#include "isa/instruction.hpp"
#include "isa/data_processing.hpp"
#include "isa/multiply.hpp"

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

        void Execute(std::initializer_list<isa::CInstruction> instructions);

    private:
        [[nodiscard]] std::uint32_t& PC() noexcept;
        [[nodiscard]] std::uint32_t& LR() noexcept;
        [[nodiscard]] std::uint32_t& SP() noexcept;

        [[nodiscard]] bool Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept;
        [[nodiscard]] std::uint32_t Get_Shift_Amount(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand_Imm(isa::CData_Processing instruction) const noexcept;
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Get_Second_Operand(isa::CData_Processing instruction) const noexcept;

        void Execute(isa::CInstruction instruction);
        void Execute(isa::CData_Processing instruction);
        void Execute(isa::CMultiply instruction);

    public:
        std::array<std::uint32_t, NUMBER_OF_REGS> m_regs;
        CCSPR m_cspr;
    };
}