#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <mutex>
/// \endcond

#include "logger.hpp"

namespace zero_mate::utils
{
    class CLogger_STDO final : public ILogger
    {
    public:
        CLogger_STDO() = default;

        void Print(const char* msg) override;
        void Debug(const char* msg) override;
        void Info(const char* msg) override;
        void Warning(const char* msg) override;
        void Error(const char* msg) override;

    private:
        std::mutex m_mtx;
    };
}