#include "data_processing.hpp"

namespace zero_mate::coprocessor::cp10::isa
{
    CData_Processing::CData_Processing(std::uint32_t value) noexcept
    : m_value{ value }
    {
    }

    std::uint32_t CData_Processing::Get_Vn_Idx() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Vd_Idx() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Vm_Idx() const noexcept
    {
        return m_value & 0b1111U;
    }

    std::uint32_t CData_Processing::Get_Vn_Offset() const noexcept
    {
        return (m_value >> 7U) & 0b1U;
    }

    std::uint32_t CData_Processing::Get_Vd_Offset() const noexcept
    {
        return (m_value >> 22U) & 0b1U;
    }

    std::uint32_t CData_Processing::Get_Vm_Offset() const noexcept
    {
        return (m_value >> 5U) & 0b1U;
    }
}