#include "coprocessor.hpp"

namespace zero_mate::coprocessors
{
    ICoprocessor::ICoprocessor(arm1176jzf_s::CCPU_Context& cpu_context)
    : m_cpu_context{ cpu_context }
    {
    }
}