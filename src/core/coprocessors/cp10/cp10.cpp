// ---------------------------------------------------------------------------------------------------------------------
/// \file cp10.cpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements coprocessor CP10 (single-precision FPU).
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party libraries

#include "fmt/format.h"
#include "magic_enum.hpp"

// Project file imports

#include "cp10.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::coprocessor::cp10
{
    CCP10::CCP10(arm1176jzf_s::CCPU_Context& cpu_context, std::shared_ptr<CBus> bus)
    : ICoprocessor{ cpu_context }
    , m_bus{ bus }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    , m_regs{}
    {
        Reset();
    }

    void CCP10::Reset()
    {
        m_fpexc = 0;
        m_fpscr = 0;

        // Reset all single-precision registers.
        for (auto& reg : m_regs)
        {
            reg = 0.0F;
        }
    }

    void CCP10::Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
        // Make sure the coprocessor has been enabled before it is used.
        if (!Is_FPU_Enabled())
        {
            return;
        }

        // Retrieve the type of the data processing instruction.
        const isa::CCP_Data_Processing_Inst cp_instruction{ instruction.Get_Value() };
        const auto type = cp_instruction.Get_Type();

        // clang-format off
        // Call the appropriate handler based on the type of the instruction.
        switch (type)
        {
            case isa::CCP_Data_Processing_Inst::NType::VMUL:
                Execute_VMUL(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VADD:
                Execute_VADD(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VSUB:
                Execute_VSUB(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VDIV:
                Execute_VDIV(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VABS:
                Execute_VABS(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VNEG:
                Execute_VNEG(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VSQRT:
                Execute_VSQRT(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VMLA_VMLS:
                Execute_VMLA_VMLS(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VNMLA_VNMLS_VNMUL:
                Execute_VNMLA_VNMLS_VNMUL(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VMOV_Register:
                Execute_VMOV(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VCMP_VCMPE:
                Execute_VCMP_VCMPE(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VCVT_Double_Precision_Single_Precision:
                Execute_VCVT_Double_Precision_Single_Precision(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::VCVT_VCVTR_Floating_Point_Integer:
                Execute_VCVT_VCVTR_Floating_Point_Integer(isa::CData_Processing{ instruction.Get_Value() });
                break;

            case isa::CCP_Data_Processing_Inst::NType::Unknown:
                m_logging_system.Error("Unknown FPU data processing instruction");
                break;
        }
        // clang-format on
    }

    void CCP10::Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
        // Make sure the coprocessor has been enabled before it is used.
        if (!Is_FPU_Enabled())
        {
            return;
        }

        // Retrieve the type of the data transfer instruction.
        const isa::CCP_Data_Transfer_Inst cp_instruction{ instruction.Get_Value() };
        const auto type = cp_instruction.Get_Type();

        // Call the appropriate handler based on the type of the instruction.
        switch (type)
        {
            case isa::CCP_Data_Transfer_Inst::NType::VLDR:
                Execute_VLDR_VSTR(isa::CData_Transfer{ instruction.Get_Value() }, true);
                break;

            case isa::CCP_Data_Transfer_Inst::NType::VSTR:
                Execute_VLDR_VSTR(isa::CData_Transfer{ instruction.Get_Value() }, false);
                break;

            case isa::CCP_Data_Transfer_Inst::NType::VPUSH:
                Execute_VSTM_VLDM(isa::CData_Transfer{ instruction.Get_Value() }, false);
                break;

            case isa::CCP_Data_Transfer_Inst::NType::VPOP:
                Execute_VSTM_VLDM(isa::CData_Transfer{ instruction.Get_Value() }, true);
                break;

            case isa::CCP_Data_Transfer_Inst::NType::VSTM_Increment_After_No_Writeback:
                [[fallthrough]];
            case isa::CCP_Data_Transfer_Inst::NType::VSTM_Increment_After_Writeback:
            case isa::CCP_Data_Transfer_Inst::NType::VSTM_Decrement_Before_Writeback:
                Execute_VSTM_VLDM(isa::CData_Transfer{ instruction.Get_Value() }, false);
                break;

            case isa::CCP_Data_Transfer_Inst::NType::VLDM_Increment_After_No_Writeback:
                [[fallthrough]];
            case isa::CCP_Data_Transfer_Inst::NType::VLDM_Increment_After_Writeback:
            case isa::CCP_Data_Transfer_Inst::NType::VLDM_Decrement_Before_Writeback:
                Execute_VSTM_VLDM(isa::CData_Transfer{ instruction.Get_Value() }, true);
                break;

            case isa::CCP_Data_Transfer_Inst::NType::Unknown:
                m_logging_system.Error("Unknown FPU data transfer instruction");
                break;
        }
    }

    void CCP10::Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
        // Note: This type of instruction is allowed to be called even though CP10 has not been enabled yet.

        // Retrieve the type of the register transfer instruction.
        const isa::CCP_Register_Transfer_Inst cp_instruction{ instruction.Get_Value() };
        const auto type = cp_instruction.Get_Type();

        // Call the appropriate handler based on the type of the instruction.
        switch (type)
        {
            case isa::CCP_Register_Transfer_Inst::NType::VMSR:
                Execute(isa::CVMSR{ instruction.Get_Value() });
                break;

            case isa::CCP_Register_Transfer_Inst::NType::VMRS:
                Execute(isa::CVMRS{ instruction.Get_Value() });
                break;

            case isa::CCP_Register_Transfer_Inst::NType::VMOV_ARM_Register_Single_Precision_Register:
                Execute(isa::CVMOV_ARM_Register_Single_Precision_Register{ instruction.Get_Value() });
                break;

            case isa::CCP_Register_Transfer_Inst::NType::VDUP:
                [[fallthrough]];
            case isa::CCP_Register_Transfer_Inst::NType::VMOV_ARM_Register_Scalar:
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
        // Get the index of the ARM register.
        const std::uint32_t rt_idx = instruction.Get_Rt_Idx();

        // Get the type of the special register.
        const auto special_reg_type = instruction.Get_Special_Reg_Type();

        // Perform the transfer.
        switch (special_reg_type)
        {
            // FPEXC
            case isa::CVMSR::NSpecial_Register_Type::FPEXC:
                m_fpexc = m_cpu_context[rt_idx];
                break;

            // FPSCR
            case isa::CVMSR::NSpecial_Register_Type::FPSCR:
                m_fpscr = m_cpu_context[rt_idx];
                break;

            // FPSID
            case isa::CVMSR::NSpecial_Register_Type::FPSID:
                // clang-format off
                m_logging_system.Error(fmt::format("VMSR {} register is not supported yet",
                                       magic_enum::enum_name(special_reg_type)).c_str());
                // clang-format on
                break;
        }
    }

    void CCP10::Execute(isa::CVMRS instruction)
    {
        // If the target register is the ARM APSR register, only the flags (see the CMP operation)
        // are transferred from the coprocessor register.
        if (instruction.Transfer_To_APSR())
        {
            m_cpu_context.Set_Flag(arm1176jzf_s::CCPU_Context::NFlag::N, m_fpscr.Is_Flag_Set(CFPSCR::NFlag::N));
            m_cpu_context.Set_Flag(arm1176jzf_s::CCPU_Context::NFlag::Z, m_fpscr.Is_Flag_Set(CFPSCR::NFlag::Z));
            m_cpu_context.Set_Flag(arm1176jzf_s::CCPU_Context::NFlag::C, m_fpscr.Is_Flag_Set(CFPSCR::NFlag::C));
            m_cpu_context.Set_Flag(arm1176jzf_s::CCPU_Context::NFlag::V, m_fpscr.Is_Flag_Set(CFPSCR::NFlag::V));
        }
        else
        {
            // Otherwise, we perform a regular register transfer.
            m_cpu_context[instruction.Get_Rt_Idx()] = m_fpscr.Get_Value();
        }
    }

    void CCP10::Execute(isa::CVMOV_ARM_Register_Single_Precision_Register instruction)
    {
        // Get the index of a single-precision CP10 register.
        const std::uint32_t vn_idx = 2 * instruction.Get_Vn_Idx() + instruction.Get_Vn_Offset();

        // Get the index of an ARM register.
        const std::uint32_t rt_idx = instruction.Get_Rt_Idx();

        // Check the type of the transfer.
        if (instruction.To_ARM_Register())
        {
            // ARM <- CP10
            m_cpu_context[rt_idx] = m_regs[vn_idx].Get_Value_As<std::uint32_t>();
        }
        else
        {
            // ARM -> CP10
            m_regs[vn_idx] = m_cpu_context[rt_idx];
        }
    }

    void CCP10::Execute_VMUL(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = X * Y
        m_regs[vd_idx] = m_regs[vn_idx] * m_regs[vm_idx];
    }

    void CCP10::Execute_VADD(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = X + Y
        m_regs[vd_idx] = m_regs[vn_idx] + m_regs[vm_idx];
    }

    void CCP10::Execute_VSUB(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = X - Y
        m_regs[vd_idx] = m_regs[vn_idx] - m_regs[vm_idx];
    }

    void CCP10::Execute_VDIV(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = X / Y
        m_regs[vd_idx] = m_regs[vn_idx] / m_regs[vm_idx];
    }

    void CCP10::Execute_VABS(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = std::abs(X)
        m_regs[vd_idx] = m_regs[vm_idx].Get_ABS();
    }

    void CCP10::Execute_VNEG(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = -X
        m_regs[vd_idx] = m_regs[vm_idx].Get_NEG();
    }

    void CCP10::Execute_VSQRT(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = std::sqrt(X)
        m_regs[vd_idx] = m_regs[vm_idx].Get_SQRT();
    }

    void CCP10::Execute_VMLA_VMLS(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        if (!instruction.Is_OP_6_Bit_Set())
        {
            // Z = Z + (X * Y)
            m_regs[vd_idx] += (m_regs[vn_idx] * m_regs[vm_idx]);
        }
        else
        {
            // Z = Z - (X * Y)
            m_regs[vd_idx] -= (m_regs[vn_idx] * m_regs[vm_idx]);
        }
    }

    void CCP10::Execute_VNMLA_VNMLS_VNMUL(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Is it an accumulate instruction?
        if (instruction.Is_Accumulate_Type())
        {
            if (!instruction.Is_OP_6_Bit_Set())
            {
                // Z = -Z + (-(X * Y))
                m_regs[vd_idx] = m_regs[vd_idx].Get_NEG() + (m_regs[vn_idx] * m_regs[vm_idx]).Get_NEG();
            }
            else
            {
                // Z = -Z - (-(X * Y))
                m_regs[vd_idx] = m_regs[vd_idx].Get_NEG() - (m_regs[vn_idx] * m_regs[vm_idx]).Get_NEG();
            }
        }
        else
        {
            // Z = -(X * Y)
            m_regs[vd_idx] = (m_regs[vn_idx] * m_regs[vm_idx]).Get_NEG();
        }
    }

    void CCP10::Execute_VCMP_VCMPE(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Get the first operand.
        const CRegister val_1{ m_regs[vd_idx] };

        // Get the second operand.
        const CRegister val_2{ instruction.Compare_With_Zero() ? m_regs[vm_idx] : 0.0F };

        if (val_1 == val_2)
        {
            m_fpscr.Set_Flag(CFPSCR::NFlag::N, false);
            m_fpscr.Set_Flag(CFPSCR::NFlag::Z, true); // Z = 1
            m_fpscr.Set_Flag(CFPSCR::NFlag::C, true); // C = 1
            m_fpscr.Set_Flag(CFPSCR::NFlag::V, false);
        }
        else if (val_1 > val_2)
        {
            m_fpscr.Set_Flag(CFPSCR::NFlag::N, false);
            m_fpscr.Set_Flag(CFPSCR::NFlag::Z, false);
            m_fpscr.Set_Flag(CFPSCR::NFlag::C, true); // C = 1
            m_fpscr.Set_Flag(CFPSCR::NFlag::V, false);
        }
        else
        {
            m_fpscr.Set_Flag(CFPSCR::NFlag::N, true); // N = 1
            m_fpscr.Set_Flag(CFPSCR::NFlag::Z, false);
            m_fpscr.Set_Flag(CFPSCR::NFlag::C, false);
            m_fpscr.Set_Flag(CFPSCR::NFlag::V, false);
        }
    }

    void CCP10::Execute_VCVT_Double_Precision_Single_Precision(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = X (simplification as double-precision is NOT supported).
        m_regs[vd_idx] = m_regs[vm_idx];
    }

    void CCP10::Execute_VCVT_VCVTR_Floating_Point_Integer(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Are we converting a float to an integer?
        if (instruction.To_Integer())
        {
            // Get the register value as a float, convert it into an integer, and store it in the destination register.
            const auto value = m_regs[vm_idx].Get_Value_As<float>();
            m_regs[vd_idx] = Convert_Float_To_Int(value, instruction.Signed());
        }
        else
        {
            // Get the register value as an integer, convert it into a float, and store it in the destination register.
            const auto value = m_regs[vm_idx].Get_Value_As<std::uint32_t>();
            m_regs[vd_idx] = Convert_Int_To_Float(value, instruction.Is_OP_7_Bit_Set());
        }
    }

    std::uint32_t CCP10::Convert_Float_To_Int(float value, bool is_signed)
    {
        // Are we dealing with a signed integer?
        if (is_signed)
        {
            return static_cast<std::uint32_t>(static_cast<std::int32_t>(value));
        }

        // Unsigned integer
        return static_cast<std::uint32_t>(value);
    }

    float CCP10::Convert_Int_To_Float(std::uint32_t value, bool is_signed)
    {
        // Are we dealing with a signed integer?
        if (is_signed)
        {
            return static_cast<float>(static_cast<std::int32_t>(value));
        }

        // Unsigned integer
        return static_cast<float>(value);
    }

    void CCP10::Execute_VLDR_VSTR(isa::CData_Transfer instruction, bool is_load_op)
    {
        // Get the index of the single-precision register.
        const std::uint32_t vd_idx = 2 * instruction.Get_Vd_Idx() + instruction.Get_Vd_Offset();

        // Get the index of an ARM register.
        const std::uint32_t rn_idx = instruction.Get_Rn_Idx();

        // Get the immediate value.
        const std::uint32_t immediate = arm1176jzf_s::CCPU_Context::Reg_Size * instruction.Get_Immediate();

        // Calculate the source/destination address.
        std::uint32_t addr{ m_cpu_context[rn_idx] };

        // If Rn = PC, add 4 to the address.
        if (rn_idx == arm1176jzf_s::CCPU_Context::PC_Reg_Idx)
        {
            addr += arm1176jzf_s::CCPU_Context::Reg_Size;
        }

        // Should the immediate value be added or subtracted from the address?
        if (instruction.Is_U_Bit_Set())
        {
            addr += immediate;
        }
        else
        {
            addr -= immediate;
        }

        // Is it a load operation?
        if (is_load_op)
        {
            m_regs[vd_idx] = m_bus->Read<std::uint32_t>(addr);
        }
        else
        {
            m_bus->Write<std::uint32_t>(addr, m_regs[vd_idx].Get_Value_As<std::uint32_t>());
        }
    }

    void CCP10::Execute_VSTM_VLDM(isa::CData_Transfer instruction, bool is_load_instruction)
    {
        // Get the index of the first single-precision register.
        const std::uint32_t start_idx = 2 * instruction.Get_Vd_Idx() + instruction.Get_Vd_Offset();

        // Get the total number of single-precision register to be transferred.
        const std::uint32_t count = instruction.Get_Immediate();

        // Get the ARM Rn register (base address).
        std::uint32_t& rn = m_cpu_context[instruction.Get_Rn_Idx()];

        // Are we incrementing or decrementing from the base address? (see VPUSH vs VPOP)
        const bool add = instruction.Is_U_Bit_Set();

        // Should we write the address back to Rn?
        const bool write_back = instruction.Is_W_Bit_Set();

        std::uint32_t addr{ 0 };

        // Calculate the address as if required, write the result back to Rn.
        if (add)
        {
            addr = rn;

            if (write_back)
            {
                rn += (arm1176jzf_s::CCPU_Context::Reg_Size * count);
            }
        }
        else
        {
            addr = rn - (arm1176jzf_s::CCPU_Context::Reg_Size * count);

            if (write_back)
            {
                rn -= (arm1176jzf_s::CCPU_Context::Reg_Size * count);
            }
        }

        // Transfer all registers one by one.
        for (std::uint32_t idx = start_idx; idx < (start_idx + count); ++idx)
        {
            // Have we exceeded the number of single-precision registers?
            if (idx >= Number_Of_S_Registers)
            {
                break; // Undefined behavior
            }

            // Are we supposed to load or store the registers?
            if (is_load_instruction)
            {
                // Read the value from the current address and store it into the current single-precision register.
                m_regs[idx] = m_bus->Read<std::uint32_t>(addr);
            }
            else
            {
                // Store the value from the current single-precision register at the current address.
                m_bus->Write<std::uint32_t>(addr, m_regs[idx].Get_Value_As<std::uint32_t>());
            }

            // Move on to the next address (next register).
            addr += arm1176jzf_s::CCPU_Context::Reg_Size;
        }
    }

    void CCP10::Execute_VMOV(isa::CData_Processing instruction)
    {
        // Get the indexes of the single-precision FPU registers.
        const auto [vd_idx, vn_idx, vm_idx] = instruction.Get_Register_Idxs();

        // Z = X
        m_regs[vd_idx] = m_regs[vm_idx];
    }

    std::array<CRegister, CCP10::Number_Of_S_Registers>& CCP10::Get_Registers()
    {
        return m_regs;
    }

    const std::array<CRegister, CCP10::Number_Of_S_Registers>& CCP10::Get_Registers() const
    {
        return m_regs;
    }

    const CFPSCR& CCP10::Get_FPSCR() const noexcept
    {
        return m_fpscr;
    }

    const CFPEXC& CCP10::Get_FPEXC() const noexcept
    {
        return m_fpexc;
    }

    bool CCP10::Is_FPU_Enabled() const noexcept
    {
        // Is the FPU (CP10) enabled?
        const auto enabled = m_fpexc.Is_Flag_Set(CFPEXC::NFlag::EN);

        // Log an error message in case the FPU (CP10) is not enabled.
        if (!enabled)
        {
            m_logging_system.Error("FPU (CP10) is not enabled");
        }

        return enabled;
    }

} // namespace zero_mate::coprocessor::cp10