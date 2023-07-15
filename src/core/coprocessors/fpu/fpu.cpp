#include "fpu.hpp"

namespace zero_mate::coprocessor::cp10
{
    CFPU::CFPU(arm1176jzf_s::CCPU_Context& cpu_context)
    : ICoprocessor{ cpu_context }
    {
    }

    void CFPU::Reset()
    {
    }

    void CFPU::Perform_Data_Operation([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
    }

    void CFPU::Perform_Data_Transfer([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
    }

    void CFPU::Perform_Register_Transfer([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
    }
}