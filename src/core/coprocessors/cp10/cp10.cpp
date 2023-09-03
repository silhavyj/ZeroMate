#include "fmt/format.h"
#include "magic_enum.hpp"

#include "cp10.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::coprocessor::cp10
{
    CCP10::CCP10(arm1176jzf_s::CCPU_Context& cpu_context)
    : ICoprocessor{ cpu_context }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_regs{}
    {
    }

    void CCP10::Reset()
    {
    }

    void CCP10::Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
        const isa::CData_Processing fp_instruction{ instruction.Get_Value() };

        const auto type = fp_instruction.Get_Type();

        switch (type)
        {
            case isa::CData_Processing::NType::VMUL:
                [[fallthrough]];
            case isa::CData_Processing::NType::VADD:
            case isa::CData_Processing::NType::VSUB:
            case isa::CData_Processing::NType::VDIV:
            case isa::CData_Processing::NType::VMLA_VMLS:
            case isa::CData_Processing::NType::VNMLA_VNMLS_VNMUL:
            case isa::CData_Processing::NType::VFNMA_VFNMS:
            case isa::CData_Processing::NType::VFMA_VFMS:
            case isa::CData_Processing::NType::VMOV_Immediate:
            case isa::CData_Processing::NType::VMOV_Register:
            case isa::CData_Processing::NType::VABS:
            case isa::CData_Processing::NType::VNEG:
            case isa::CData_Processing::NType::VSQRT:
            case isa::CData_Processing::NType::VCVTB_VCVTT:
            case isa::CData_Processing::NType::VCMP_VCMPE:
            case isa::CData_Processing::NType::VCVT_Double_Precision_Single_Precision:
            case isa::CData_Processing::NType::VCVT_VCVTR_Floating_Point_Integer:
            case isa::CData_Processing::NType::VCVT_Floating_Point_Fixed_Point:
                // clang-format off
                m_logging_system.Error(fmt::format("{} instruction has not been implemented yet",
                                       magic_enum::enum_name(type)).c_str());
                // clang-format on
                break;

            case isa::CData_Processing::NType::Unknown:
                m_logging_system.Error("Unknown FPU data processing instruction");
                break;
        }
    }

    void CCP10::Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
        const isa::CData_Transfer fp_instruction{ instruction.Get_Value() };

        const auto type = fp_instruction.Get_Type();

        switch (type)
        {
            case isa::CData_Transfer::NType::VSTM_Increment_After_No_Writeback:
                [[fallthrough]];
            case isa::CData_Transfer::NType::VSTM_Increment_After_Writeback:
            case isa::CData_Transfer::NType::VSTR:
            case isa::CData_Transfer::NType::VSTM_Decrement_Before_Writeback:
            case isa::CData_Transfer::NType::VPUSH:
            case isa::CData_Transfer::NType::VLDM_Increment_After_No_Writeback:
            case isa::CData_Transfer::NType::VLDM_Increment_After_Writeback:
            case isa::CData_Transfer::NType::VPOP:
            case isa::CData_Transfer::NType::VLDR:
            case isa::CData_Transfer::NType::VLDM_Decrement_Before_Writeback:
                // clang-format off
                m_logging_system.Error(fmt::format("{} instruction has not been implemented yet",
                                       magic_enum::enum_name(type)).c_str());
                // clang-format on
                break;

            case isa::CData_Transfer::NType::Unknown:
                m_logging_system.Error("Unknown FPU data transfer instruction");
                break;
        }
    }

    void CCP10::Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
        const isa::CRegister_Transfer fp_instruction{ instruction.Get_Value() };

        const auto type = fp_instruction.Get_Type();

        switch (type)
        {
            case isa::CRegister_Transfer::NType::VMOV_ARM_Register_Single_Precision_Register:
                [[fallthrough]];
            case isa::CRegister_Transfer::NType::VMSR:
            case isa::CRegister_Transfer::NType::VMOV_ARM_Register_Scalar:
            case isa::CRegister_Transfer::NType::VDUP:
            case isa::CRegister_Transfer::NType::VMRS:
            case isa::CRegister_Transfer::NType::VMOV_Scalar_ARM_Register:
                // clang-format off
                m_logging_system.Error(fmt::format("{} instruction has not been implemented yet",
                                       magic_enum::enum_name(type)).c_str());
                // clang-format on
                break;

            case isa::CRegister_Transfer::NType::Unknown:
                m_logging_system.Error("Unknown FPU register transfer instruction");
                break;
        }
    }

    std::array<CRegister, CCP10::Number_Of_S_Registers>& CCP10::Get_Registers()
    {
        return m_regs;
    }

    bool CCP10::Is_FPU_Enabled() const noexcept
    {
        const auto enabled = m_fpexc.Is_Enabled();

        if (!enabled)
        {
            m_logging_system.Error("FPU (CP10) is not enabled");
        }

        return enabled;
    }
}