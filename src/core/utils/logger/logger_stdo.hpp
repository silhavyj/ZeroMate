#pragma once

#include <string_view>

#include "logger.hpp"

namespace zero_mate::utils
{
    class CLogger_STDO final : public ILogger
    {
    public:
        CLogger_STDO();

        void Print(const char* msg) override;
        void Debug(const char* msg, const std::source_location& location = std::source_location::current()) override;
        void Info(const char* msg, const std::source_location& location = std::source_location::current()) override;
        void Warning(const char* msg, const std::source_location& location = std::source_location::current()) override;
        void Error(const char* msg, const std::source_location& location = std::source_location::current()) override;
    };
}