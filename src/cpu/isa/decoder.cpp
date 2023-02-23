#include <algorithm>
#include <bitset>

#include "../../utils/math.hpp"
#include "decoder.hpp"

namespace zero_mate::cpu::isa
{
    CInstruction_Decoder::CInstruction_Decoder() noexcept
    {
        std::sort(INSTRUCTION_LOOKUP_TABLE.begin(),
                  INSTRUCTION_LOOKUP_TABLE.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return utils::math::Get_Number_Of_Set_Bits(record1.mask) >
                             utils::math::Get_Number_Of_Set_Bits(record2.mask);
                  });
    }

    CInstruction::NType CInstruction_Decoder::Get_Instruction_Type(CInstruction instruction) noexcept
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