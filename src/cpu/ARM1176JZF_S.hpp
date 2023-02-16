#pragma once

#include <array>
#include <limits>
#include <cstdint>
#include <initializer_list>

#include "registers/cspr.hpp"
#include "isa/instruction.hpp"
#include "isa/data_processing.hpp"

namespace zero_mate::cpu
{
    class CARM1176JZF_S final
    {
    private:
        static constexpr std::size_t NUMBER_OF_REGS = 16;
        static constexpr std::size_t PC_REG_IDX = 15;
        static constexpr std::size_t LR_REG_IDX = 14;
        static constexpr std::size_t SP_REG_IDX = 13;
        static constexpr auto MAX_ADDR = std::numeric_limits<std::uint32_t>::max() - sizeof(std::uint32_t);

        struct TInstruction_Lookup_Record
        {
            std::uint32_t mask;
            std::uint32_t expected;
            isa::CInstruction::NType type;
        };

        // clang-format off
        static constexpr std::array<TInstruction_Lookup_Record, 1> INSTRUCTION_LOOKUP_TABLE = {{
            { 0b0000'110'0000'0'0000'0000'000000000000, 0b0000'000'0000'0'0000'0000'000000000000, isa::CInstruction::NType::Data_Processing }
        }};
        // clang-format on

    public:
        CARM1176JZF_S() noexcept;

        void Execute(std::initializer_list<isa::CInstruction> instructions);

    private:
        [[nodiscard]] std::uint32_t& PC() noexcept;
        [[nodiscard]] std::uint32_t& LR() noexcept;
        [[nodiscard]] std::uint32_t& SP() noexcept;

        [[nodiscard]] bool Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept;
        [[nodiscard]] static isa::CInstruction::NType Get_Instruction_Type(isa::CInstruction instruction) noexcept;

        void Execute(isa::CInstruction instruction);
        void Execute(isa::CData_Processing instruction);

    public:
        std::array<std::uint32_t, NUMBER_OF_REGS> m_regs;
        CCSPR m_cspr;
    };
}