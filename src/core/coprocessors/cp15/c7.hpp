// ---------------------------------------------------------------------------------------------------------------------
/// \file c7.hpp
/// \date 27. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the primary register C7 of coprocessor CP15.
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
    /// \class CC7
    /// \brief This class represents primary register C7 of coprocessor CP15
    // -----------------------------------------------------------------------------------------------------------------
    class CC7 final : public IPrimary_Reg
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm
        /// \brief Enumeration of secondary registers of the C7 primary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm : std::uint32_t
        {
            C5 = 5,  ///< CRm = 5
            C6 = 6,  ///< CRm = 6
            C7 = 7,  ///< CRm = 7
            C10 = 10 ///< CRm = 10
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C5_Register
        /// \brief Enumeration of the registers of the NCRm::C5 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C5_Register : std::uint32_t
        {
            Flush_Prefetch_Buffer = 4 ///< Flush prefetch buffer
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C6_Register
        /// \brief Enumeration of the registers of the NCRm::C6 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C6_Register : std::uint32_t
        {
            Invalidate_Entire_Data_Cache = 0 ///< Invalidate entire data cache
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C7_Register
        /// \brief Enumeration of the registers of the NCRm::C7 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C7_Register : std::uint32_t
        {
            Invalidate_Both_Caches = 0 ///< Invalidate both caches
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NCRm_C10_Register
        /// \brief Enumeration of the registers of the NCRm::C10 secondary register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NCRm_C10_Register : std::uint32_t
        {
            Data_Synchronization_Barrier = 4 ///< Data synchronization barrier
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class
        ///
        /// All secondary registers (CC7::NCRm) get initialized upon object construction.
        // -------------------------------------------------------------------------------------------------------------
        CC7();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the flush prefetch buffer register is NOT set to 0.
        /// \return true if the register is not zero. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Flush_Prefetch_Buffer_Set() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the flush invalidate entire cache register is NOT set to 0.
        /// \return true if the register is not zero. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Invalidate_Entire_Data_Cache_Set() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the invalidate both caches register is NOT set to 0.
        /// \return true if the register is not zero. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Invalidate_Both_Caches_Set() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the data synchronization barrier register is NOT set to 0.
        /// \return true if the register is not zero. false otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Data_Synchronization_Barrier_Set() const;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C5.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R5();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C6.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R6();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C7.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R7();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes secondary register C10.
        ///
        /// This function is called from the constructor.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_CRm_R10();
    };

} // namespace zero_mate::coprocessor::cp15