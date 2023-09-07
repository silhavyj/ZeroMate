#pragma once

#include <array>

#include "fpexc.hpp"
#include "fpscr.hpp"
#include "register.hpp"
#include "../coprocessor.hpp"
#include "isa/isa.hpp"
#include "isa/cp_data_processing_inst.hpp"
#include "isa/cp_data_transfer_inst.hpp"
#include "isa/cp_register_transfer_inst.hpp"
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
        [[nodiscard]] const CFPSCR& Get_FPSCR() const noexcept;
        [[nodiscard]] const CFPEXC& Get_FPEXC() const noexcept;

    private:
        [[nodiscard]] inline bool Is_FPU_Enabled() const noexcept;

        void Execute(isa::CVMSR instruction);
        void Execute(isa::CVMRS instruction);
        void Execute(isa::CVMOV_ARM_Register_Single_Precision_Register instruction);

        inline void Execute_VMUL(isa::CData_Processing instruction);
        inline void Execute_VADD(isa::CData_Processing instruction);
        inline void Execute_VSUB(isa::CData_Processing instruction);
        inline void Execute_VDIV(isa::CData_Processing instruction);
        inline void Execute_VABS(isa::CData_Processing instruction);
        inline void Execute_VNEG(isa::CData_Processing instruction);
        inline void Execute_VSQRT(isa::CData_Processing instruction);
        inline void Execute_VMLA_VMLS(isa::CData_Processing instruction);
        inline void Execute_VNMLA_VNMLS_VNMUL(isa::CData_Processing instruction);
        inline void Execute_VMOV(isa::CData_Processing instruction);
        inline void Execute_VCMP_VCMPE(isa::CData_Processing instruction);

    private:
        CFPEXC m_fpexc;
        CFPSCR m_fpscr;
        utils::CLogging_System& m_logging_system;
        std::array<CRegister, Number_Of_S_Registers> m_regs;
    };
}