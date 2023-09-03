#pragma once

#include <array>

#include "fpexc.hpp"
#include "register.hpp"
#include "../coprocessor.hpp"
#include "isa/data_processing.hpp"
#include "isa/data_transfer.hpp"
#include "isa/register_transfer.hpp"
#include "zero_mate/utils/logging_system.hpp"

namespace zero_mate::coprocessor::cp10
{
    class CCP10 final : public ICoprocessor
    {
    public:
        static constexpr std::uint32_t ID = 10;
        static constexpr std::uint32_t Number_Of_S_Registers = 32;

    public:
        explicit CCP10(arm1176jzf_s::CCPU_Context& cpu_context);

        void Reset() override;

        void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) override;
        void Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction) override;
        void Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction) override;

        [[nodiscard]] std::array<CRegister, Number_Of_S_Registers>& Get_Registers();

    private:
        [[nodiscard]] inline bool Is_FPU_Enabled() const noexcept;

    private:
        CFPEXC m_fpexc;
        utils::CLogging_System& m_logging_system;
        std::array<CRegister, Number_Of_S_Registers> m_regs;
    };
}