#include "clz.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCLZ::CCLZ(zero_mate::arm1176jzf_s::isa::CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CCLZ::Get_Rd() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CCLZ::Get_Rm() const noexcept
    {
        return m_value & 0b1111U;
    }
}