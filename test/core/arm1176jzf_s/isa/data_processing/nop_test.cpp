#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"
#include "register_state_checker.hpp"

TEST(nop_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    cpu.m_context.Set_CPU_Mode(CCPU_Context::NCPU_Mode::IRQ);

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe320f000 } // nop
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(cpu.m_context, {{}}), false);
    // clang-format on
}