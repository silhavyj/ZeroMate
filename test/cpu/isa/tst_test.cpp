#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"
#include "helpers/register_state_checker.hpp"

TEST(tst_instruction, test_01)
{
    using namespace zero_mate::cpu;
    using namespace zero_mate::test::helpers;

    CARM1176JZF_S cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01106 }, // mov r1, 0x80000001
    { 0xe1100001 }  // tst r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_regs, { { .idx = 0, .expected_value = 0xFFFFFFFF },
                            { .idx = 1, .expected_value = 0x80000001 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
}