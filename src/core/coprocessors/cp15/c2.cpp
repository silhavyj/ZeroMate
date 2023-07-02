// ---------------------------------------------------------------------------------------------------------------------
/// \file c2.cpp
/// \date 27. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the primary register C2 of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "c2.hpp"

namespace zero_mate::coprocessor::cp15
{
    CC2::CC2()
    {
        Init_CRm_R0();
    }

    void CC2::Init_CRm_R0()
    {
        // Index of the C0 secondary register.
        const auto crm_c0_idx = static_cast<std::uint32_t>(NCRm::C0);

        // Initialize all registers of the C0 secondary register (indexed by op2).
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Translation_Table_Base_0)] = 0;
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Translation_Table_Base_1)] = 0;
        m_regs[crm_c0_idx][static_cast<std::uint32_t>(NCRm_C0_Register::Translation_Table_Base_Control)] = 0;
    }

    std::uint32_t CC2::Get_TTB_Address(NCRm_C0_Register reg) const
    {
        return Extract_Bits_From_TTBR(reg, NC0_TTB_Flags::Address);
    }

    bool CC2::Is_TTB_Shared(NCRm_C0_Register reg) const
    {
        return static_cast<bool>(Extract_Bits_From_TTBR(reg, NC0_TTB_Flags::Shared));
    }

    bool CC2::Is_TTB_Inner_Cacheable(NCRm_C0_Register reg) const
    {
        return static_cast<bool>(Extract_Bits_From_TTBR(reg, NC0_TTB_Flags::Inner_Cacheable));
    }

    CC2::NBoundary CC2::Get_Boundary_Type() const
    {
        return static_cast<NBoundary>(Extract_Bits_From_TTB_Ctrl(NC0_TTB_Control_Flags::Boundary));
    }

    std::uint32_t CC2::Get_Boundary() const
    {
        switch (Get_Boundary_Type())
        {
            case NBoundary::KB_16:
                return 16 * 1024 * 1024;

            case NBoundary::KB_8:
                return 8 * 1024 * 1024;

            case NBoundary::KB_4:
                return 4 * 1024 * 1024;

            case NBoundary::KB_2:
                return 2 * 1024 * 1024;

            case NBoundary::KB_1:
                return 1 * 1024 * 1024;

            case NBoundary::B_512:
                return 512 * 1024;

            case NBoundary::B_256:
                return 128 * 1024;

            case NBoundary::B_128:
                break;
        }

        return 0;
    }

    bool CC2::Is_PD0_Set() const
    {
        return static_cast<bool>(Extract_Bits_From_TTB_Ctrl(NC0_TTB_Control_Flags::PD0));
    }

    bool CC2::Is_PD1_Set() const
    {
        return static_cast<bool>(Extract_Bits_From_TTB_Ctrl(NC0_TTB_Control_Flags::PD1));
    }

    std::uint32_t CC2::Extract_Bits_From_TTB_Ctrl(NC0_TTB_Control_Flags mask) const
    {
        // Index of secondary register C0.
        const auto crm_c0_idx = static_cast<std::uint32_t>(NCRm::C0);

        // Index of the translation table control register.
        const auto reg_idx = static_cast<std::uint32_t>(NCRm_C0_Register::Translation_Table_Base_Control);

        // Mask as a 32-bit value.
        const auto mask_value = static_cast<std::uint32_t>(mask);

        return m_regs.at(crm_c0_idx).at(reg_idx) & mask_value;
    }

    std::uint32_t CC2::Extract_Bits_From_TTBR(NCRm_C0_Register reg, NC0_TTB_Flags mask) const
    {
        // Index of secondary register C0.
        const auto crm_c0_idx = static_cast<std::uint32_t>(NCRm::C0);

        // Index of the register indexed by op2.
        const auto reg_idx = static_cast<std::uint32_t>(reg);

        // Mask as a 32-bit value.
        const auto mask_value = static_cast<std::uint32_t>(mask);

        return m_regs.at(crm_c0_idx).at(reg_idx) & mask_value;
    }

} // namespace zero_mate::coprocessor::cp15