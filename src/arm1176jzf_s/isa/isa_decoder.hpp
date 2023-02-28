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

    public:
        CISA_Decoder() noexcept;

        [[nodiscard]] static CInstruction::NType Get_Instruction_Type(CInstruction instruction) noexcept;

    private:
        static std::array<TInstruction_Lookup_Record, 8> s_instruction_lookup_table;
    };
}