#pragma once

#include "coprocessor.hpp"

namespace zero_mate::coprocessors
{
    class CCP15 final : public ICoprocessor
    {
    public:
        explicit CCP15(arm1176jzf_s::CCPU_Context& cpu_context);

        void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) override;
    };
}