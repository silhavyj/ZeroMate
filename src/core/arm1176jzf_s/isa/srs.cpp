#include "srs.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CSRS::CSRS(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    CSRS::NAddressing_Mode CSRS::Get_Addressing_Mode() const noexcept
    {
        return static_cast<NAddressing_Mode>((m_value >> 23U) & 0b11U);
    }

    bool CSRS::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    std::uint32_t CSRS::Get_CPU_Mode() const noexcept
    {
        return m_value & 0b11111U;
    }

    bool CSRS::Should_Be_Decremented() const noexcept
    {
        const auto addressing_mode = Get_Addressing_Mode();

        return addressing_mode == NAddressing_Mode::DB || addressing_mode == NAddressing_Mode::DA;
    }
}