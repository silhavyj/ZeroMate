#include "decoder.hpp"

namespace zero_mate::cpu::isa::decoder
{
    CInstruction::NType Get_Instruction_Type(CInstruction instruction) noexcept
    {
        for (const auto& [mask, expected, type] : INSTRUCTION_LOOKUP_TABLE)
        {
            if ((instruction.Get_Value() & mask) == expected)
            {
                return type;
            }
        }

        return CInstruction::NType::Unknown;
    }
}