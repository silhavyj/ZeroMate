#pragma once

#include <cstdint>

namespace zero_mate::cpu
{
    class CCSPR final
    {
    public:
        static constexpr std::uint32_t N_BIT_IDX = 31U;
        static constexpr std::uint32_t Z_BIT_IDX = 30U;
        static constexpr std::uint32_t C_BIT_IDX = 29U;
        static constexpr std::uint32_t V_BIT_IDX = 28U;

        enum class NFlag : std::uint8_t
        {
            N, // Negative result from ALU
            Z, // Zero result from ALU
            C, // ALU operation carried out
            V  // ALU operation overflowed
        };

        explicit CCSPR(uint32_t value) noexcept;

        void Set_Flag(NFlag flag, bool set) noexcept;
        [[nodiscard]] bool Is_Flag_Set(NFlag flag) const noexcept;

    private:
        std::uint32_t m_value;
    };
}