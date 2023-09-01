#include "cp10.hpp"

namespace zero_mate::coprocessor::cp10
{
    CCP10::CCP10(arm1176jzf_s::CCPU_Context& cpu_context)
    : ICoprocessor{ cpu_context }
    {
    }

    void CCP10::Reset()
    {
    }

    void CCP10::Perform_Data_Operation([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
    }

    void CCP10::Perform_Data_Transfer([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
    }

    void CCP10::Perform_Register_Transfer([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
    }
}