#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"
#include "register_state_checker.hpp"

TEST(tst_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01106 }, // mov r1, #0x80000001
    { 0xe1100001 }  // tst r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_regs, { { .idx = 0, .expected_value = 0xFFFFFFFF },
                            { .idx = 1, .expected_value = 0x80000001 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(tst_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe3a00001 }, // mov r0, #1
    { 0xe3a01087 }, // mov r1, #0b10000111
    { 0xe1110200 }  // tst r1, r0, LSL #4
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_regs, { { .idx = 0, .expected_value = 1 },
                            { .idx = 1, .expected_value = 0b10000111 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(tst_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01007 }, // mov r1, #0b111
    { 0xe11001e1 }  // tst r0, r1, ror #3
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_regs, { { .idx = 0, .expected_value = 0xFFFFFFFF },
                            { .idx = 1, .expected_value = 0b111 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(tst_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_regs)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_regs);

    cpu.Execute({
    { 0xe3a00001 }, // mov r0, #1
    { 0xe3a01001 }, // mov r1, #1
    { 0xe1100001 }  // tst r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_regs, { { .idx = 0, .expected_value = 1 },
                            { .idx = 1, .expected_value = 1 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}