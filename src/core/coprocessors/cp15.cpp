#include <fmt/format.h>
#include <magic_enum.hpp>

#include "cp15.hpp"
#include "../utils/singleton.hpp"

namespace zero_mate::coprocessor
{
    CCP15::CCP15(arm1176jzf_s::CCPU_Context& cpu_context)
    : ICoprocessor{ cpu_context }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
        Initialize();
    }

    void CCP15::Initialize()
    {
        m_regs[NPrimary_Register::Control_Register] = std::vector<std::uint32_t>(REGISTER_1_COUNT, 0);
    }

    bool CCP15::Is_Control_Flag_Set(NControl_Register_Flags flag) const
    {
        return static_cast<bool>(m_regs.at(NPrimary_Register::Control_Register).at(static_cast<std::uint32_t>(NRegister_1::Control_Register)) & static_cast<std::uint32_t>(flag));
    }

    void CCP15::Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
        const auto primary_reg = static_cast<NPrimary_Register>(instruction.Get_CRn_Idx());

        if (!m_regs.contains(primary_reg))
        {
            m_logging_system.Error(fmt::format("CP15: {} register has not been implemented yet", magic_enum::enum_name(primary_reg)).c_str());
            return;
        }

        const auto secondary_reg_idx = instruction.Get_CRm_Idx();
        const auto rd_idx = instruction.Get_Rd_Idx();

        if (instruction.Is_L_Bit_Set())
        {
            m_cpu_context[rd_idx] = m_regs[primary_reg][secondary_reg_idx];
        }
        else
        {
            m_regs[primary_reg][secondary_reg_idx] = m_cpu_context[rd_idx];
        }
    }

    bool CCP15::Is_Unaligned_Access_Permitted() const
    {
        return Is_Control_Flag_Set(NControl_Register_Flags::U);
    }

    void CCP15::Perform_Data_Transfer([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
        m_logging_system.Error("Data transfer operation cannot be applied to CP15");
    }

    void CCP15::Perform_Data_Operation([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
        m_logging_system.Error("Data operation cannot be applied to CP15");
    }
}