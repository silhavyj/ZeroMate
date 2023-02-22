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

    // TODO make sure the table is sorted from the most restrictive mask to the least restrictive
    // clang-format off
    inline constexpr std::array<TInstruction_Lookup_Record, 3> INSTRUCTION_LOOKUP_TABLE = {{
        { .mask = 0b0000'111111'0'0'0000'0000'0000'1111'0000 , .expected = 0b0000'000000'0'0'0000'0000'0000'1001'0000 , .type = CInstruction::NType::Multiply        },
        { .mask = 0b0000'11111'0'0'0'0000'0000'0000'1111'0000, .expected = 0b0000'00001'0'0'0'0000'0000'0000'1001'0000, .type = CInstruction::NType::Multiply_Long   },
        { .mask = 0b0000'110'0000'0'0000'0000'000000000000   , .expected = 0b0000'000'0000'0'0000'0000'000000000000   , .type = CInstruction::NType::Data_Processing }
    }};
    // clang-format on

    [[nodiscard]] CInstruction::NType Get_Instruction_Type(CInstruction instruction) noexcept;
}