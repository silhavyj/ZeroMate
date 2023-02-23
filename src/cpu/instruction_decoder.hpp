#pragma once

#include <array>
#include <cstdint>

#include "isa/instruction.hpp"

namespace zero_mate::cpu
{
    class CInstruction_Decoder
    {
    private:
        struct TInstruction_Lookup_Record
        {
            std::uint32_t mask;
            std::uint32_t expected;
            isa::CInstruction::NType type;
        };

        // clang-format off
        std::array<TInstruction_Lookup_Record, 5> INSTRUCTION_LOOKUP_TABLE = {{
            { .mask = 0b0000'1111'1111'1111'1111'1111'1111'0000U, .expected = 0b0000'0001'0010'1111'1111'1111'0001'0000U, .type = isa::CInstruction::NType::Branch_And_Exchange },
            { .mask = 0b0000'1110'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'1010'0000'0000'0000'0000'0000'0000U, .type = isa::CInstruction::NType::Branch              },
            { .mask = 0b0000'1100'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'0000'0000'0000'0000'0000'0000'0000U, .type = isa::CInstruction::NType::Data_Processing     },
            { .mask = 0b0000'1111'1100'0000'0000'0000'1111'0000U, .expected = 0b0000'0000'0000'0000'0000'0000'1001'0000U, .type = isa::CInstruction::NType::Multiply            },
            { .mask = 0b0000'1111'1000'0000'0000'0000'1111'0000U, .expected = 0b0000'0000'1000'0000'0000'0000'1001'0000U, .type = isa::CInstruction::NType::Multiply_Long       }
        }};
        // clang-format on

    public:
        CInstruction_Decoder() noexcept;

        [[nodiscard]] isa::CInstruction::NType Get_Instruction_Type(isa::CInstruction instruction) const noexcept;
    };
}