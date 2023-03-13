#include "sw_interrupt.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSW_Interrupt::CSW_Interrupt(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CSW_Interrupt::Get_Comment_Field() const noexcept
    {
        return m_value & 0xFFFFFF;
    }
}