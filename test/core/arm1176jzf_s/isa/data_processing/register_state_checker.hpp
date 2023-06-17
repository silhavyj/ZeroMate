#pragma once

#include <cstdint>
#include <initializer_list>

namespace zero_mate::test
{
    template<typename CPU_Context>
    class CRegister_State_Checker final
    {
    public:
        struct TRegister
        {
            std::size_t idx{};
            std::uint32_t expected_value{};
        };

        using Changed_registers_t = std::initializer_list<TRegister>;

    public:
        void Record_State(const CPU_Context& cpu_context) noexcept
        {
            m_cpu_context = cpu_context;
        }

        [[nodiscard]] bool Is_Any_Other_Register_Modified(const CPU_Context& curr_cpu_context, Changed_registers_t changed_registers) const noexcept
        {
            const auto mode = m_cpu_context.Get_CPU_Mode();
            const auto curr_mode = curr_cpu_context.Get_CPU_Mode();

            if (mode != curr_mode)
            {
                return true;
            }

            if (m_cpu_context.Is_Mode_With_No_SPSR(mode) != curr_cpu_context.Is_Mode_With_No_SPSR(curr_mode))
            {
                return true;
            }

            if ((!m_cpu_context.Is_Mode_With_No_SPSR(mode) && !curr_cpu_context.Is_Mode_With_No_SPSR(curr_mode)) &&
                (m_cpu_context.Get_SPSR() != curr_cpu_context.Get_SPSR()))
            {
                return true;
            }

            for (std::uint32_t i = 0; i < arm1176jzf_s::CCPU_Context::Number_Of_Regs; ++i)
            {
                bool excluded_reg{ false };

                // Note: The number registers expected to have changed is relatively small,
                // so a raw for loop instead of a look-up table should be fine in terms of performance.
                for (const auto& reg : changed_registers)
                {
                    if (reg.idx == i)
                    {
                        if (reg.expected_value != curr_cpu_context[i])
                        {
                            return true;
                        }
                        excluded_reg = true;
                    }
                }

                if (!excluded_reg && m_cpu_context[i] != curr_cpu_context[i])
                {
                    return true;
                }
            }

            return false;
        }

    private:
        CPU_Context m_cpu_context;
    };
}
