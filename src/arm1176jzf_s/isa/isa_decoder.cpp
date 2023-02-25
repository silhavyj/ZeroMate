#include <algorithm>
#include <bitset>

#include "../../utils/math.hpp"
#include "isa_decoder.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CISA_Decoder::CISA_Decoder() noexcept
    {
        std::sort(INSTRUCTION_LOOKUP_TABLE.begin(),
                  INSTRUCTION_LOOKUP_TABLE.end(),
                  [](const auto& record1, const auto& record2) -> bool {
                      return utils::math::Get_Number_Of_Set_Bits(record1.mask) >
                             utils::math::Get_Number_Of_Set_Bits(record2.mask);
                  });
    }

    CInstruction::NType CISA_Decoder::Get_Instruction_Type(CInstruction instruction) const noexcept
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