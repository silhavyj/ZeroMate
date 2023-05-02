#include "rfe.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CRFE::CRFE(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    CRFE::NAddressing_Mode CRFE::Get_Addressing_Mode() const noexcept
    {
        return static_cast<NAddressing_Mode>((m_value >> 23U) & 0b11U);
    }

    bool CRFE::Is_W_Bit_Set() const noexcept
    {
        return static_cast<bool>((m_value >> 21U) & 0b1U);
    }

    std::uint32_t CRFE::Get_Rn() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    bool CRFE::Should_Rn_Be_Decremented() const noexcept
    {
        const auto addressing_mode = Get_Addressing_Mode();

        return addressing_mode == NAddressing_Mode::DB || addressing_mode == NAddressing_Mode::DA;
    }
}