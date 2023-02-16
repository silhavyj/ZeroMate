#include "cspr.hpp"
#include "../../utils/math.hpp"

namespace zero_mate::cpu
{
    CCSPR::CCSPR(uint32_t value) noexcept
    : m_value{ value }
    {
    }

    void CCSPR::Set_Flag(NFlag flag, bool set) noexcept
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

    bool CCSPR::Is_Flag_Set(NFlag flag) const noexcept
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
}