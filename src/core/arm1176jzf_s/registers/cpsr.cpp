#include "cpsr.hpp"
#include "../../utils/math.hpp"

namespace zero_mate::arm1176jzf_s
{
    CCPSR::CCPSR(uint32_t value) noexcept
    : m_value{ value }
    {
    }

    void CCPSR::Set_Flag(NFlag flag, bool set) noexcept
    {
        switch (flag)
        {
            case NFlag::N:
                utils::math::Set_Bit(m_value, N_BIT_IDX, set);
                break;

            case NFlag::Z:
                utils::math::Set_Bit(m_value, Z_BIT_IDX, set);
                break;

            case NFlag::C:
                utils::math::Set_Bit(m_value, C_BIT_IDX, set);
                break;

            case NFlag::V:
                utils::math::Set_Bit(m_value, V_BIT_IDX, set);
                break;
        }
    }

    bool CCPSR::Is_Flag_Set(NFlag flag) const noexcept
    {
        switch (flag)
        {
            case NFlag::N:
                return utils::math::Is_Bit_Set(m_value, N_BIT_IDX);

            case NFlag::Z:
                return utils::math::Is_Bit_Set(m_value, Z_BIT_IDX);

            case NFlag::C:
                return utils::math::Is_Bit_Set(m_value, C_BIT_IDX);

            case NFlag::V:
                return utils::math::Is_Bit_Set(m_value, V_BIT_IDX);
        }

        return false;
    }

    void CCPSR::Set_CPU_Mode(NCPU_Mode mode) noexcept
    {
        m_value &= ~(CPU_MODE_MASK);
        m_value |= static_cast<std::uint32_t>(mode);
    }

    CCPSR::NCPU_Mode CCPSR::Get_CPU_Mode() const noexcept
    {
        return static_cast<NCPU_Mode>(m_value & CPU_MODE_MASK);
    }
}