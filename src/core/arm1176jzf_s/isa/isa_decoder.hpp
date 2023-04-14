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
        // TODO change this to static constexpr auto NUMBER_OF_INSTRUCTION_TYPES = static_cast<std::size_t>(CInstruction::NType::Count)
        static constexpr std::size_t NUMBER_OF_INSTRUCTION_TYPES = 10;

        static std::array<TInstruction_Lookup_Record, NUMBER_OF_INSTRUCTION_TYPES> s_instruction_lookup_table;
    };
}