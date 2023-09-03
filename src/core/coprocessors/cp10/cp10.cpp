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
        Reset();
    }

    void CCP10::Reset()
    {
        m_fpexc = 0;

        for (auto& reg : m_regs)
        {
            reg = 0.0F;
        }
    }

    void CCP10::Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
        const isa::CCP_Data_Processing_Inst cp_instruction{ instruction.Get_Value() };

        const auto type = cp_instruction.Get_Type();

        switch (type)
        {
            case isa::CCP_Data_Processing_Inst::NType::VMUL:
                Execute(isa::CData_Processing{ instruction.Get_Value() }, [&](auto vn, auto vm) { return vn * vm; });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VADD:
                Execute(isa::CData_Processing{ instruction.Get_Value() }, [&](auto vn, auto vm) { return vn + vm; });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VSUB:
                Execute(isa::CData_Processing{ instruction.Get_Value() }, [&](auto vn, auto vm) { return vn - vm; });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VDIV:
                Execute(isa::CData_Processing{ instruction.Get_Value() }, [&](auto vn, auto vm) { return vn / vm; });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VABS:
                Execute(isa::CData_Processing{ instruction.Get_Value() },
                        [&]([[maybe_unused]] auto vn, auto vm) { return vm.Get_ABS(); });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VNEG:
                Execute(isa::CData_Processing{ instruction.Get_Value() },
                        [&]([[maybe_unused]] auto vn, auto vm) { return vm.Get_NEG(); });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VSQRT:
                Execute(isa::CData_Processing{ instruction.Get_Value() },
                        [&]([[maybe_unused]] auto vn, auto vm) { return vm.Get_SQRT(); });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VMLA_VMLS:
                [[fallthrough]];
            case isa::CCP_Data_Processing_Inst::NType::VNMLA_VNMLS_VNMUL:
            case isa::CCP_Data_Processing_Inst::NType::VFNMA_VFNMS:
            case isa::CCP_Data_Processing_Inst::NType::VFMA_VFMS:
            case isa::CCP_Data_Processing_Inst::NType::VMOV_Immediate:
            case isa::CCP_Data_Processing_Inst::NType::VMOV_Register:
            case isa::CCP_Data_Processing_Inst::NType::VCVTB_VCVTT:
            case isa::CCP_Data_Processing_Inst::NType::VCMP_VCMPE:
            case isa::CCP_Data_Processing_Inst::NType::VCVT_Double_Precision_Single_Precision:
            case isa::CCP_Data_Processing_Inst::NType::VCVT_VCVTR_Floating_Point_Integer:
            case isa::CCP_Data_Processing_Inst::NType::VCVT_Floating_Point_Fixed_Point:
                // clang-format off
                m_logging_system.Error(fmt::format("{} instruction has not been implemented yet",
                                       magic_enum::enum_name(type)).c_str());
                // clang-format on
                break;

            case isa::CCP_Data_Processing_Inst::NType::Unknown:
                m_logging_system.Error("Unknown FPU data processing instruction");
                break;
        }
    }

    void CCP10::Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
        const isa::CCP_Data_Transfer_Inst cp_instruction{ instruction.Get_Value() };

        const auto type = cp_instruction.Get_Type();

        switch (type)
        {
            case isa::CCP_Data_Transfer_Inst::NType::VSTM_Increment_After_No_Writeback:
                [[fallthrough]];
            case isa::CCP_Data_Transfer_Inst::NType::VSTM_Increment_After_Writeback:
            case isa::CCP_Data_Transfer_Inst::NType::VSTR:
            case isa::CCP_Data_Transfer_Inst::NType::VSTM_Decrement_Before_Writeback:
            case isa::CCP_Data_Transfer_Inst::NType::VPUSH:
            case isa::CCP_Data_Transfer_Inst::NType::VLDM_Increment_After_No_Writeback:
            case isa::CCP_Data_Transfer_Inst::NType::VLDM_Increment_After_Writeback:
            case isa::CCP_Data_Transfer_Inst::NType::VPOP:
            case isa::CCP_Data_Transfer_Inst::NType::VLDR:
            case isa::CCP_Data_Transfer_Inst::NType::VLDM_Decrement_Before_Writeback:
                // clang-format off
                m_logging_system.Error(fmt::format("{} instruction has not been implemented yet",
                                       magic_enum::enum_name(type)).c_str());
                // clang-format on
                break;

            case isa::CCP_Data_Transfer_Inst::NType::Unknown:
                m_logging_system.Error("Unknown FPU data transfer instruction");
                break;
        }
    }

    void CCP10::Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
        const isa::CCP_Register_Transfer_Inst cp_instruction{ instruction.Get_Value() };

        const auto type = cp_instruction.Get_Type();

        switch (type)
        {
            case isa::CCP_Register_Transfer_Inst::NType::VMSR:
                Execute(isa::CVMSR{ instruction.Get_Value() });
                break;

            case isa::CCP_Register_Transfer_Inst::NType::VMOV_ARM_Register_Single_Precision_Register:
                Execute(isa::CVMOV_ARM_Register_Single_Precision_Register{ instruction.Get_Value() });
                break;

            case isa::CCP_Register_Transfer_Inst::NType::VMOV_ARM_Register_Scalar:
                [[fallthrough]];
            case isa::CCP_Register_Transfer_Inst::NType::VDUP:
            case isa::CCP_Register_Transfer_Inst::NType::VMRS:
            case isa::CCP_Register_Transfer_Inst::NType::VMOV_Scalar_ARM_Register:
                // clang-format off
                m_logging_system.Error(fmt::format("{} instruction has not been implemented yet",
                                       magic_enum::enum_name(type)).c_str());
                // clang-format on
                break;

            case isa::CCP_Register_Transfer_Inst::NType::Unknown:
                m_logging_system.Error("Unknown FPU register transfer instruction");
                break;
        }
    }

    void CCP10::Execute(isa::CVMSR instruction)
    {
        const std::uint32_t rt_idx = instruction.Get_Rt_Idx();
        const auto special_reg_type = instruction.Get_Special_Reg_Type();

        switch (special_reg_type)
        {
            case isa::CVMSR::NSpecial_Register_Type::FPSID:
                [[fallthrough]];
            case isa::CVMSR::NSpecial_Register_Type::FPSCR:
                // clang-format off
                m_logging_system.Error(fmt::format("VMSR {} register is not supported yet",
                                       magic_enum::enum_name(special_reg_type)).c_str());
                // clang-format on
                break;

            case isa::CVMSR::NSpecial_Register_Type::FPEXC:
                m_fpexc = m_cpu_context[rt_idx];
                break;
        }
    }

    void CCP10::Execute(isa::CVMOV_ARM_Register_Single_Precision_Register instruction)
    {
        const std::uint32_t vn_idx = 2 * instruction.Get_Vn_Idx() + instruction.Get_Vn_Offset();
        const std::uint32_t rt_idx = instruction.Get_Rt_Idx();

        if (instruction.To_ARM_Register())
        {
            m_cpu_context[rt_idx] = m_regs[vn_idx].Get_Value_As<std::uint32_t>();
        }
        else
        {
            m_regs[vn_idx] = m_cpu_context[rt_idx];
        }
    }

    template<typename Operation>
    void CCP10::Execute(isa::CData_Processing instruction, Operation operation)
    {
        const std::uint32_t vd_idx = 2 * instruction.Get_Vd_Idx() + instruction.Get_Vd_Offset();
        const std::uint32_t vn_idx = 2 * instruction.Get_Vn_Idx() + instruction.Get_Vn_Offset();
        const std::uint32_t vm_idx = 2 * instruction.Get_Vm_Idx() + instruction.Get_Vm_Offset();

        m_regs[vd_idx] = operation(m_regs[vn_idx], m_regs[vm_idx]);
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