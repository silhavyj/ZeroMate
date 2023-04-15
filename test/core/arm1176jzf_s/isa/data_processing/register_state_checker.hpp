#pragma once

#include <cstdint>
#include <initializer_list>

namespace zero_mate::test
{
    template<typename Registers>
    class CRegister_State_Checker final
    {
    public:
        struct TRegister
        {
            std::size_t idx{};
            std::uint32_t expected_value{};
        };

        using Changed_registers_t = std::initializer_list<TRegister>;

        void Record_State(const Registers& regs) noexcept
        {
            m_regs = regs;
        }

        [[nodiscard]] bool Is_Any_Other_Register_Modified(const Registers& curr_regs, Changed_registers_t changed_registers) const noexcept
        {
            for (std::uint32_t i = 0; i < arm1176jzf_s::CCPU_Context::NUMBER_OF_REGS; ++i)
            {
                bool excluded_reg{ false };

                // Note: The number registers expected to have changed is relatively small,
                // so a raw for loop instead of a look-up table should be fine in terms of performance.
                for (const auto& reg : changed_registers)
                {
                    if (reg.idx == i)
                    {
                        if (reg.expected_value != curr_regs[i])
                        {
                            return true;
                        }
                        excluded_reg = true;
                    }
                }

                if (!excluded_reg && m_regs[i] != curr_regs[i])
                {
                    return true;
                }
            }

            return false;
        }

    private:
        Registers m_regs;
    };
}
