// ---------------------------------------------------------------------------------------------------------------------
/// \file exceptions.cpp
/// \date 23. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements all exceptions that can be thrown by the CPU during execution.
///
/// More information about ARM CPU exceptions can be found over at:
/// https://developer.arm.com/documentation/dui0056/d/handling-processor-exceptions/about-processor-exceptions
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "exceptions.hpp"

namespace zero_mate::arm1176jzf_s::exceptions
{
    CCPU_Exception::CCPU_Exception(std::uint32_t exception_vector,
                                   CCPU_Context::NCPU_Mode mode,
                                   const char* name,
                                   NType type)
    : std::runtime_error{ name }
    , m_exception_vector{ exception_vector }
    , m_mode{ mode }
    , m_type{ type }
    {
    }

    std::uint32_t CCPU_Exception::Get_Exception_Vector() const
    {
        return m_exception_vector;
    }

    CCPU_Context::NCPU_Mode CCPU_Exception::Get_CPU_Mode() const
    {
        return m_mode;
    }

    CCPU_Exception::NType CCPU_Exception::Get_Type() const
    {
        return m_type;
    }

    CReset::CReset()
    : CCPU_Exception{ 0x00U, CCPU_Context::NCPU_Mode::Supervisor, "Reset exception", NType::Reset }
    {
    }

    // clang-format off
    CUndefined_Instruction::CUndefined_Instruction()
    : CCPU_Exception{ 0x04U,
                      CCPU_Context::NCPU_Mode::Undefined,
                      "Undefined instruction exception",
                      NType::Undefined_Instruction }
    {
    }

    CSoftware_Interrupt::CSoftware_Interrupt()
    : CCPU_Exception{ 0x08U,
                      CCPU_Context::NCPU_Mode::Supervisor,
                      "Software interrupt exception",
                      NType::Software_Interrupt }
    {
    }

    CPrefetch_Abort::CPrefetch_Abort(std::uint32_t addr)
    : CPrefetch_Abort(addr, "")
    {
    }

    CPrefetch_Abort::CPrefetch_Abort(std::uint32_t addr, const char* msg)
    : CCPU_Exception{ 0x0CU,
                      CCPU_Context::NCPU_Mode::Abort,
                      fmt::format("Prefetch abort exception at address 0x{:08X} ({})", addr, msg).c_str(),
                      NType::Prefetch_Abort }
    {
    }

    CData_Abort::CData_Abort(std::uint32_t addr, const char* msg)
    : CCPU_Exception{ 0x10U,
                      CCPU_Context::NCPU_Mode::Abort,
                      fmt::format("Data abort exception at address 0x{:08X} ({})", addr, msg).c_str(),
                      NType::Data_Abort }
    {
    }

    CIRQ::CIRQ()
    : CCPU_Exception{ 0x18U, CCPU_Context::NCPU_Mode::IRQ, "IRQ exception", NType::IRQ }
    {
    }

    CFIQ::CFIQ()
    : CCPU_Exception{ 0x1CU, CCPU_Context::NCPU_Mode::FIQ, "FIQ exception", NType::FIQ }
    {
    }

} // namespace zero_mate::arm1176jzf_s::exceptions