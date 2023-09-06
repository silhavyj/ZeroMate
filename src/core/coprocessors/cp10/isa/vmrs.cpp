#include "vmrs.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    CVMRS::CVMRS(std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    bool CVMRS::Transfer_To_APSR() const noexcept
    {
        return Get_Rt_Idx() == 0b1111U;
    }

    std::uint32_t CVMRS::Get_Rt_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }
}