#include "coprocessor_data_operation.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    CCoprocessor_Data_Operation::CCoprocessor_Data_Operation(CInstruction instruction) noexcept
    : CInstruction{ instruction.Get_Value() }
    {
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_CP_OP_Code() const noexcept
    {
        return (m_value >> 20U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_CRn() const noexcept
    {
        return (m_value >> 16U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_CRd() const noexcept
    {
        return (m_value >> 12U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_Coprocessor_ID() const noexcept
    {
        return (m_value >> 8U) & 0b1111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_Coprocessor_Information() const noexcept
    {
        return (m_value >> 5U) & 0b111U;
    }

    std::uint32_t CCoprocessor_Data_Operation::Get_CRm() const noexcept
    {
        return m_value & 0b1111U;
    }
}