// ---------------------------------------------------------------------------------------------------------------------
/// \file cp15.cpp
/// \date 29. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements CP15 (system control coprocessor) as defined in cp15.hpp.
///
/// To find more information about the coprocessor, please visit
/// https://developer.arm.com/documentation/ddi0290/g/system-control-coprocessor/about-control-coprocessor-cp15
// ---------------------------------------------------------------------------------------------------------------------

// 3rd party library includes

#include <fmt/format.h>
#include <magic_enum.hpp>

// Project file imports

#include "cp15.hpp"
#include "zero_mate/utils/singleton.hpp"

namespace zero_mate::coprocessor
{
    CCP15::CCP15(arm1176jzf_s::CCPU_Context& cpu_context)
    : ICoprocessor{ cpu_context }
    , m_logging_system{ *utils::CSingleton<utils::CLogging_System>::Get_Instance() }
    {
        // Initialize the coprocessor.
        Initialize();
    }

    void CCP15::Initialize()
    {
        Initialize_C1();
    }

    void CCP15::Initialize_C1()
    {
        // Create the C1 primary register.
        m_regs[NPrimary_Register::C1] = std::vector<std::uint32_t>(static_cast<std::size_t>(NC1_Register::Count), 0);

        // Permit unaligned memory access.
        m_regs[NPrimary_Register::C1][static_cast<std::uint32_t>(NC1_Register::Control)] |=
        static_cast<std::uint32_t>(NC1_Control_Flags::Unaligned_Memory_Access_Enable);
    }

    bool CCP15::Is_C1_Control_Flag_Set(NC1_Control_Flags flag) const
    {
        // clang-format off
        return static_cast<bool>(
            m_regs.at(NPrimary_Register::C1).at(static_cast<std::uint32_t>(NC1_Register::Control)) &
            static_cast<std::uint32_t>(flag)
        );
        // clang-format on
    }

    void CCP15::Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction)
    {
        // Retrieve the index of the primary register
        const auto primary_reg = static_cast<NPrimary_Register>(instruction.Get_CRn_Idx());

        // Make sure the index is value (primary register exists).
        if (!m_regs.contains(primary_reg))
        {
            // clang-format off
            m_logging_system.Error(fmt::format("CP15: c{} register has not been implemented yet",
                                               instruction.Get_CRn_Idx()).c_str());
            // clang-format on

            return;
        }

        // Retrieve the secondary register associated with the primary register.
        const auto secondary_reg_idx = instruction.Get_CRm_Idx();

        // Source/destination CPU register.
        const auto rd_idx = instruction.Get_Rd_Idx();

        if (instruction.Is_L_Bit_Set())
        {
            // Coprocessor -> CPU
            m_cpu_context[rd_idx] = m_regs[primary_reg][secondary_reg_idx];
        }
        else
        {
            //  Coprocessor <- CPU
            m_regs[primary_reg][secondary_reg_idx] = m_cpu_context[rd_idx];
        }
    }

    bool CCP15::Is_Unaligned_Access_Permitted() const
    {
        return Is_C1_Control_Flag_Set(NC1_Control_Flags::Unaligned_Memory_Access_Enable);
    }

    void CCP15::Perform_Data_Transfer([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction)
    {
        m_logging_system.Error("Data transfer operation cannot be applied to CP15");
    }

    void CCP15::Perform_Data_Operation([[maybe_unused]] arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction)
    {
        m_logging_system.Error("Data operation cannot be applied to CP15");
    }

} // namespace zero_mate::coprocessor