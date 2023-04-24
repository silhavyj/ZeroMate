#pragma once

#include <stdexcept>

#include "fmt/format.h"

#include "context.hpp"

namespace zero_mate::arm1176jzf_s::exceptions
{
    class CCPU_Exception : public std::runtime_error
    {
    public:
        explicit CCPU_Exception(std::uint32_t exception_vector, CCPU_Context::NCPU_Mode mode, const char* name);

        [[nodiscard]] std::uint32_t Get_Exception_Vector() const;
        [[nodiscard]] CCPU_Context::NCPU_Mode Get_CPU_Mode() const;

    protected:
        std::uint32_t m_exception_vector;
        CCPU_Context::NCPU_Mode m_mode;
    };

    class CReset final : public CCPU_Exception
    {
    public:
        CReset();
    };

    class CUndefined_Instruction final : public CCPU_Exception
    {
    public:
        CUndefined_Instruction();
    };

    class CSoftware_Interrupt : public CCPU_Exception
    {
    public:
        CSoftware_Interrupt();
    };

    class CPrefetch_Abort : public CCPU_Exception
    {
    public:
        explicit CPrefetch_Abort(std::uint32_t addr);
    };

    class CData_Abort : public CCPU_Exception
    {
    public:
        explicit CData_Abort(std::uint32_t addr, const char* msg);
    };

    class CIRQ : public CCPU_Exception
    {
    public:
        CIRQ();
    };

    class CFIQ : public CCPU_Exception
    {
    public:
        CFIQ();
    };
}