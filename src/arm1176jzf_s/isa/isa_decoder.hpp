#pragma once

#include <array>
#include <cstdint>

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CISA_Decoder
    {
    private:
        struct TInstruction_Lookup_Record
        {
            std::uint32_t mask;
            std::uint32_t expected;
            CInstruction::NType type;
        };

        // clang-format off
        std::array<TInstruction_Lookup_Record, 7> INSTRUCTION_LOOKUP_TABLE = {{
            { .mask = 0b0000'1111'1111'1111'1111'1111'1101'0000U, .expected = 0b0000'0001'0010'1111'1111'1111'0001'0000U, .type = CInstruction::NType::Branch_And_Exchange  },
            { .mask = 0b0000'1110'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'1010'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Branch               },
            { .mask = 0b0000'1100'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'0000'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Data_Processing      },
            { .mask = 0b0000'1111'1100'0000'0000'0000'1111'0000U, .expected = 0b0000'0000'0000'0000'0000'0000'1001'0000U, .type = CInstruction::NType::Multiply             },
            { .mask = 0b0000'1111'1000'0000'0000'0000'1111'0000U, .expected = 0b0000'0000'1000'0000'0000'0000'1001'0000U, .type = CInstruction::NType::Multiply_Long        },
            { .mask = 0b0000'1100'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'0100'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Single_Data_Transfer },
            { .mask = 0b0000'1110'0000'0000'0000'0000'0000'0000U, .expected = 0b0000'1000'0000'0000'0000'0000'0000'0000U, .type = CInstruction::NType::Block_Data_Transfer  }
        }};
        // clang-format on

    public:
        CISA_Decoder() noexcept;

        [[nodiscard]] CInstruction::NType Get_Instruction_Type(CInstruction instruction) const noexcept;
    };
}