// ---------------------------------------------------------------------------------------------------------------------
/// \file cp15.cpp
/// \date 26. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party library includes

#include <fmt/format.h>

// Project file imports

#include "cp15.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::coprocessor::cp15
{
    CCP15::CCP15(arm1176jzf_s::CCPU_Context& cpu_context)
    : ICoprocessor{ cpu_context }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
        // Create primary registers of coprocessor CP15.
        m_regs[static_cast<std::uint32_t>(NPrimary_Register::C1)] = std::make_shared<CC1>();
    }

    void CCP15::Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
        const std::uint32_t crn_idx = instruction.Get_CRn_Idx(); // Primary register
        const std::uint32_t crm_idx = instruction.Get_CRm_Idx(); // Secondary register
        const std::uint32_t op2 = instruction.Get_Opcode2();     // Register index of the secondary register
        const std::uint32_t rd_idx = instruction.Get_Rd_Idx();   // CPU register

        // Make sure the primary register exists/has been implemented.
        if (!m_regs.contains(crn_idx))
        {
            m_logging_system.Error(fmt::format("CP15: CRn c{} register has not been implemented yet", crn_idx).c_str());
            return;
        }

        if (instruction.Is_L_Bit_Set())
        {
            // Coprocessor -> CPU
            m_cpu_context[rd_idx] = m_regs.at(crn_idx)->Get_Reg(crm_idx, op2);
        }
        else
        {
            //  Coprocessor <- CPU
            m_regs[crn_idx]->Get_Reg(crm_idx, op2) = m_cpu_context[rd_idx];
        }
    }

    void CCP15::Perform_Data_Transfer([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
        m_logging_system.Error("Data transfer operation cannot be applied to CP15");
    }

    void CCP15::Perform_Data_Operation([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
        m_logging_system.Error("Data operation cannot be applied to CP15");
    }

} // namespace zero_mate::coprocessor::cp15