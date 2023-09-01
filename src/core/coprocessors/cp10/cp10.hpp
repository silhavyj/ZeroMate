#pragma once

#include "../coprocessor.hpp"

namespace zero_mate::coprocessor::cp10
{
    class CCP10 final : public ICoprocessor
    {
    public:
        static constexpr std::uint32_t ID = 10;

    public:
        explicit CCP10(arm1176jzf_s::CCPU_Context& cpu_context);

        void Reset() override;

        void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) override;
        void Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction) override;
        void Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction) override;
    };
}