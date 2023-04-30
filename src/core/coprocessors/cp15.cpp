#include "cp15.hpp"

namespace zero_mate::coprocessors
{
    CCP15::CCP15(arm1176jzf_s::CCPU_Context& cpu_context)
    : ICoprocessor{ cpu_context }
    {
    }

    void CCP15::Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
        // TODO
        static_cast<void>(instruction);
    }
}