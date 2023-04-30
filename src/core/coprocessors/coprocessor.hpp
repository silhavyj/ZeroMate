#pragma once

#include <cstdint>

#include "../arm1176jzf_s/context.hpp"
#include "../arm1176jzf_s/isa/coprocessor_register_transfer.hpp"

namespace zero_mate::coprocessors
{
    class ICoprocessor
    {
    public:
        explicit ICoprocessor(arm1176jzf_s::CCPU_Context& cpu_context);
        virtual ~ICoprocessor() = default;

        ICoprocessor(const ICoprocessor&) = delete;
        ICoprocessor& operator=(const ICoprocessor&) = delete;
        ICoprocessor(ICoprocessor&&) = delete;
        ICoprocessor& operator=(ICoprocessor&&) = delete;

        virtual void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) = 0;

    protected:
        arm1176jzf_s::CCPU_Context& m_cpu_context;
    };
}