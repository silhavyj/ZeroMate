#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"
#include "register_state_checker.hpp"

TEST(teq_instruction, test_01)
{
    using namespace zero_mate::cpu;
    using namespace zero_mate::test;

    CARM1176JZF_S cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe1300000 } // teq r0, r0
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(cpu.m_regs, {{}}), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(teq_instruction, test_02)
{
    using namespace zero_mate::cpu;
    using namespace zero_mate::test;

    CARM1176JZF_S cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe1300001 }  // teq r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_regs, { { .idx = 0, .expected_value = 0x00000000 },
                            { .idx = 1, .expected_value = 0xFFFFFFFF } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(teq_instruction, test_03)
{
    using namespace zero_mate::cpu;
    using namespace zero_mate::test;

    CARM1176JZF_S cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe3a0000f }, // mov r0, #15
    { 0xe3a02001 }, // mov r2, #1
    { 0xe1b010e2 }  // movs r1, r2, ROR #1
    });

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);

    cpu.Execute({
    { 0xe1300001 } // teq r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_regs, { { .idx = 0, .expected_value = 15 },
                            { .idx = 2, .expected_value = 1  },
                            { .idx = 1, .expected_value = 0x80000000 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}