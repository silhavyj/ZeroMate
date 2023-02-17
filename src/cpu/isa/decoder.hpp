#pragma once

#include <array>
#include <cstdint>

#include "instruction.hpp"

namespace zero_mate::cpu::isa::decoder
{
    struct TInstruction_Lookup_Record
    {
        std::uint32_t mask;
        std::uint32_t expected;
        CInstruction::NType type;
    };

    // clang-format off
    inline constexpr std::array<TInstruction_Lookup_Record, 1> INSTRUCTION_LOOKUP_TABLE = {{
        { .mask = 0b0000'110'0000'0'0000'0000'000000000000, .expected = 0b0000'000'0000'0'0000'0000'000000000000, .type = CInstruction::NType::Data_Processing }
    }};
    // clang-format on

    [[nodiscard]] CInstruction::NType Get_Instruction_Type(CInstruction instruction) noexcept;
}