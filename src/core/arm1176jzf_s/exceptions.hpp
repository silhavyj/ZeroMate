// ---------------------------------------------------------------------------------------------------------------------
/// \file exceptions.hpp
/// \date 23. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines all exceptions that can be thrown by the CPU during execution.
///
/// More information about ARM CPU exceptions can be found over at:
/// https://developer.arm.com/documentation/dui0056/d/handling-processor-exceptions/about-processor-exceptions
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <stdexcept>
/// \endcond

// 3rd party library includes

#include "fmt/format.h"

// Project file imports

#include "context.hpp"

namespace zero_mate::arm1176jzf_s::exceptions
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCPU_Exception
    /// \brief This class represents a parent class for all the CPU exceptions.
    // -----------------------------------------------------------------------------------------------------------------
    class CCPU_Exception : public std::runtime_error
    {
    public:
        /// High base address of the IVT table (reallocation is enabled in CP15)
        static constexpr std::uint32_t IVT_High_Base_Addr = 0xFFFF0000;

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NType
        /// \brief Type of the exception.
        // -------------------------------------------------------------------------------------------------------------
        enum class NType
        {
            Reset,                 ///< Reset the CPU
            Undefined_Instruction, ///< Undefined instruction
            Software_Interrupt,    ///< SWI (software interrupt; used for syscalls)
            Prefetch_Abort,        ///< Prefetch abort (the CPU failed to fetch the next instruction)
            Data_Abort,            ///< Data abort when reading/writing to the bus
            IRQ,                   ///< Interrupt
            FIQ                    ///< Fast interrupt
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        /// \param exception_vector Address of the handler of the exception (IVT = interrupt vector table)
        /// \param mode Mode into which the CPU will switch when the exception is thrown
        /// \param name Description of the exception for logging purposes
        /// \param type Type of the exception
        // -------------------------------------------------------------------------------------------------------------
        explicit CCPU_Exception(std::uint32_t exception_vector,
                                CCPU_Context::NCPU_Mode mode,
                                const char* name,
                                NType type);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the address of the handler of the exception.
        /// \return Address of the handler (IVT = interrupt vector table)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Exception_Vector() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the mode into which the CPU will switch when the exception is thrown.
        /// \return Mode of the exception.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CCPU_Context::NCPU_Mode Get_CPU_Mode() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the type of the exception
        /// \return Exception type
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] NType Get_Type() const;

    protected:
        std::uint32_t m_exception_vector; ///< Address of the exception handler (IVT = interrupt vector table)
        CCPU_Context::NCPU_Mode m_mode;   ///< Mode into which the CPU will switch when the exception is thrown
        NType m_type;                     ///< Type of the exception
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CReset
    /// \brief This class represents the reset exception.
    // -----------------------------------------------------------------------------------------------------------------
    class CReset final : public CCPU_Exception
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CReset();
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CUndefined_Instruction
    /// \brief This class represents the undefined instruction exception.
    // -----------------------------------------------------------------------------------------------------------------
    class CUndefined_Instruction final : public CCPU_Exception
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CUndefined_Instruction();
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CSoftware_Interrupt
    /// \brief This class represents the software interrupt (SWI) exception.
    // -----------------------------------------------------------------------------------------------------------------
    class CSoftware_Interrupt : public CCPU_Exception
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CSoftware_Interrupt();
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CPrefetch_Abort
    /// \brief This class represents the prefetch abort exception.
    // -----------------------------------------------------------------------------------------------------------------
    class CPrefetch_Abort : public CCPU_Exception
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        /// \param addr Address where the prefetch abort was triggered
        // -------------------------------------------------------------------------------------------------------------
        explicit CPrefetch_Abort(std::uint32_t addr);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        /// \param addr Address where the prefetch abort was triggered
        /// \param msg Message describing what the cause of the exception being thrown
        // -------------------------------------------------------------------------------------------------------------
        explicit CPrefetch_Abort(std::uint32_t addr, const char* msg);
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CData_Abort
    /// \brief This class represents the data abort exception.
    // -----------------------------------------------------------------------------------------------------------------
    class CData_Abort : public CCPU_Exception
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        /// \param addr Address where the data abort was triggered
        /// \param msg Message describing what the cause of the exception being thrown
        // -------------------------------------------------------------------------------------------------------------
        explicit CData_Abort(std::uint32_t addr, const char* msg);
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CIRQ
    /// \brief This class represents the IRQ (interrupt) exception.
    // -----------------------------------------------------------------------------------------------------------------
    class CIRQ : public CCPU_Exception
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CIRQ();
    };

    // -----------------------------------------------------------------------------------------------------------------
    /// \class CFIQ
    /// \brief This class represents the FIQ (fast interrupt) exception.
    // -----------------------------------------------------------------------------------------------------------------
    class CFIQ : public CCPU_Exception
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Constructor of the class.
        // -------------------------------------------------------------------------------------------------------------
        CFIQ();
    };

} // namespace zero_mate::arm1176jzf_s::exceptions