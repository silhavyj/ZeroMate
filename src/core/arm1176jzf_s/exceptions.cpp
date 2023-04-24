#include "exceptions.hpp"

namespace zero_mate::arm1176jzf_s::exceptions
{
    CCPU_Exception::CCPU_Exception(std::uint32_t exception_vector, CCPU_Context::NCPU_Mode mode, const char* name)
    : std::runtime_error{ name }
    , m_exception_vector{ exception_vector }
    , m_mode{ mode }
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

    CReset::CReset()
    : CCPU_Exception{ 0x00U, CCPU_Context::NCPU_Mode::Supervisor, "Reset exception" }
    {
    }

    CUndefined_Instruction::CUndefined_Instruction()
    : CCPU_Exception{ 0x04U, CCPU_Context::NCPU_Mode::Undefined, "Undefined instruction exception" }
    {
    }

    CSoftware_Interrupt::CSoftware_Interrupt()
    : CCPU_Exception{ 0x08U, CCPU_Context::NCPU_Mode::Supervisor, "Software interrupt exception" }
    {
    }

    CPrefetch_Abort::CPrefetch_Abort(std::uint32_t addr)
    : CCPU_Exception{ 0x0CU, CCPU_Context::NCPU_Mode::Abort, fmt::format("Prefetch abort exception at address 0x{:08X}", addr).c_str() }
    {
    }

    CData_Abort::CData_Abort(std::uint32_t addr, const char* msg)
    : CCPU_Exception{ 0x10U, CCPU_Context::NCPU_Mode::Abort, fmt::format("Data abort exception at address 0x{:08X} ({})", addr, msg).c_str() }
    {
    }

    CIRQ::CIRQ()
    : CCPU_Exception{ 0x18U, CCPU_Context::NCPU_Mode::IRQ, "IRQ exception" }
    {
    }

    CFIQ::CFIQ()
    : CCPU_Exception{ 0x1CU, CCPU_Context::NCPU_Mode::FIQ, "FIQ exception" }
    {
    }
}