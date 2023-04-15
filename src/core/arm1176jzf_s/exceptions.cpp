#include "exceptions.hpp"

namespace zero_mate::arm1176jzf_s::exceptions
{
    CCPU_Exception::CCPU_Exception(std::uint32_t exception_vector, CCPSR::NCPU_Mode mode, const char* name)
    : std::runtime_error{ name }
    , m_exception_vector{ exception_vector }
    , m_mode{ mode }
    {
    }

    std::uint32_t CCPU_Exception::Get_Exception_Vector() const
    {
        return m_exception_vector;
    }

    CCPSR::NCPU_Mode CCPU_Exception::Get_CPU_Mode() const
    {
        return m_mode;
    }

    CReset::CReset()
    : CCPU_Exception{ 0x00U, CCPSR::NCPU_Mode::SVC, "Reset exception" }
    {
    }

    CUndefined_Instruction::CUndefined_Instruction()
    : CCPU_Exception{ 0x04U, CCPSR::NCPU_Mode::UND, "Undefined instruction exception" }
    {
    }

    CSoftware_Interrupt::CSoftware_Interrupt()
    : CCPU_Exception{ 0x08U, CCPSR::NCPU_Mode::SVC, "Software interrupt exception" }
    {
    }

    CPrefetch_Abort::CPrefetch_Abort(std::uint32_t addr)
    : CCPU_Exception{ 0x0CU, CCPSR::NCPU_Mode::ABT, fmt::format("Prefetch abort exception at address 0x{:08X}", addr).c_str() }
    {
    }

    CData_Abort::CData_Abort(std::uint32_t addr)
    : CCPU_Exception{ 0x10U, CCPSR::NCPU_Mode::ABT, fmt::format("Data abort exception at address 0x{:08X}", addr).c_str() }
    {
    }

    CIRQ::CIRQ()
    : CCPU_Exception{ 0x18U, CCPSR::NCPU_Mode::IRQ, "IRQ exception" }
    {
    }

    CFIQ::CFIQ()
    : CCPU_Exception{ 0x1CU, CCPSR::NCPU_Mode::FIQ, "FIQ exception" }
    {
    }
}