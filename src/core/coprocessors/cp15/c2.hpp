// ---------------------------------------------------------------------------------------------------------------------
/// \file c2.hpp
/// \date 27. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the primary register C2 of coprocessor CP15.
///
/// List of all registers of CP15 can be found over at
/// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/
/// register-allocation?lang=en
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// Project file imports

#include "primary_reg.hpp"

namespace zero_mate::coprocessor::cp15
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CC2
    /// \brief This class represents primary register C2 of coprocessor CP15
    // -----------------------------------------------------------------------------------------------------------------
    class CC2 final : public IPrimary_Reg
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm
        /// \brief Enumeration of secondary registers of the C2 primary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm : std::uint32_t
        {
            C0 = 0 ///< CRm = 0
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C0_Register
        /// \brief Enumeration of the registers of the NCRm::C0 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C0_Register : std::uint32_t
        {
            Translation_Table_Base_0 = 0,      ///< TTB0 (address, shared, cacheable)
            Translation_Table_Base_1 = 1,      ///< TTB1 (address, shared, cacheable)
            Translation_Table_Base_Control = 2 ///< TTB control (boundary, PD0, PD1)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NC0_TTB_Flags
        /// \brief Enumeration of difference flags tha can be found in both TTB0 and TBB1.
        // -------------------------------------------------------------------------------------------------------------
        enum class NC0_TTB_Flags : std::uint32_t
        {
            Inner_Cacheable = 0b1U << 0U,                       ///< Table is inner cacheable
            Shared = 0b1U << 1U,                                ///< Table can be shared among multiple cores
            Address = 0b1111'1111'1111'1111'1100'0000'0000'0000 ///< Mask of the table's physical address
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NC0_TTB_Control_Flags
        /// \brief Enumeration of different flags the can be found in the TTB control register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NC0_TTB_Control_Flags : std::uint32_t
        {
            Boundary = 0b111U, ///< Mask of the boundary (first 3 bits)
            PD0 = 0b1U << 4U,  ///< Perform a page table walk (TTB0)
            PD1 = 0b1U << 5U,  ///< Perform a page table walk (TTB1)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NBoundary
        /// \brief Enumeration of different boundaries between TBB0 and TBB1.
        // -------------------------------------------------------------------------------------------------------------
        enum class NBoundary : std::uint32_t
        {
            KB_16 = 0b000U, ///< 16 KB boundary, reset
            KB_8 = 0b001U,  ///< 8 KB boundary
            KB_4 = 0b010U,  ///< 4 KB boundary
            KB_2 = 0b011U,  ///< 2 KB boundary
            KB_1 = 0b100U,  ///< 1 KB boundary
            B_512 = 0b101U, ///< 512 B boundary
            B_256 = 0b110U, ///< 256 B boundary
            B_128 = 0b111U  ///< 128 B boundary
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        ///
        /// All secondary registers (CC2::NCRm) get initialized upon object construction.
        // -------------------------------------------------------------------------------------------------------------
        CC2();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the physical address of a given page table
        /// \note The secondary register is supposed to be either NCRm_C0_Register::Translation_Table_Base_0 or
        /// NCRm_C0_Register::Translation_Table_Base_1 for the resulting value to make sense
        /// \param tbb Register holding the physical address of the translation table
        /// \return Physical address of the translation table
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_TTB_Address(NCRm_C0_Register tbb) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether a given translation table is shared among multiple CPU cores.
        /// \note The secondary register is supposed to be either NCRm_C0_Register::Translation_Table_Base_0 or
        /// NCRm_C0_Register::Translation_Table_Base_1 for the resulting value to make sense
        /// \param reg TBB register
        /// \return true, if the translation table is shared. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_TTB_Shared(NCRm_C0_Register reg) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether a given translation table is inner cacheable or not.
        /// \note The secondary register is supposed to be either NCRm_C0_Register::Translation_Table_Base_0 or
        /// NCRm_C0_Register::Translation_Table_Base_1 for the resulting value to make sense
        /// \param reg TBB register
        /// \return true, if the translation table is inner cacheable. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_TTB_Inner_Cacheable(NCRm_C0_Register reg) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the set boundary type that determines the use of either TTB0 or TTB1
        /// \return Boundary (type) that splits the use of TTB0 and TTB1
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NBoundary Get_Boundary_Type() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the boundary value that determines the use of either TTB0 or TTB1
        /// \return  Boundary value that splits the use of TTB0 and TTB1
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Boundary() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns whether the PD0 is set or not (performing a page table walk).
        /// \return true, if the bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_PD0_Set() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns whether the PD1 is set or not (performing a page table walk).
        /// \return true, if the bit is set. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_PD1_Set() const;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C0.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R0();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Extracts bits determined by a given mask from a given secondary register.
        /// \note The secondary register is supposed to be either NCRm_C0_Register::Translation_Table_Base_0 or
        /// NCRm_C0_Register::Translation_Table_Base_1 for the resulting value to make sense
        /// \param reg Register from which bits will be extracted
        /// \param mask Mask used to extract the bits
        /// \return Extracted bits from the given register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline std::uint32_t Extract_Bits_From_TTBR(NCRm_C0_Register reg, NC0_TTB_Flags mask) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Extract bits from the NCRm_C0_Register::Translation_Table_Base_Control register.
        /// \param mask Mask used to extract the bits
        /// \return Extracted bits from the tbb control register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline std::uint32_t Extract_Bits_From_TTB_Ctrl(NC0_TTB_Control_Flags mask) const;
    };

} // namespace zero_mate::coprocessor::cp15