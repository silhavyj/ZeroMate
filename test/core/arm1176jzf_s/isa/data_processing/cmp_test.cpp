#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"
#include "register_state_checker.hpp"

TEST(cmp_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3a000ba }, // mov r0, #186
    { 0xe3a01023 }, // mov r1, #35
    { 0xe1500001 }  // cmp r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 186 },
                            { .idx = 1, .expected_value = 35 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmp_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe1500001 }  // cmp r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 0xFFFFFFFF },
                            { .idx = 1, .expected_value = 0xFFFFFFFF } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmp_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe1500001 }  // cmp r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 0x0 },
                            { .idx = 1, .expected_value = 0xFFFFFFFF } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmp_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe1500001 }  // cmp r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 0xFFFFFFFF },
                            { .idx = 1, .expected_value = 0x0 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmp_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3500001 }  // cmp r0, #1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 0 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmp_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3e00102 }, // mov r0, #0x7FFFFFFF
    { 0xe3e01000 }, // mov r1, #0xFFFFFFFF
    { 0xe1500001 }  // cmp r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 0x7FFFFFFF },
                            { .idx = 1, .expected_value = 0xFFFFFFFF } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(cmp_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3510102 } // cmp r1, #0x80000000
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, {{}}), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(cmp_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3a0000f }, // mov r0, #15
    { 0xe3a01003 }, // mov r1, #0b11
    { 0xe1500001 }  // cmp r0, r1, ASR #0
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 15 },
                            { .idx = 1, .expected_value = 0b11 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmp_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<decltype(cpu.m_context)> register_state_checker{};
    register_state_checker.Record_State(cpu.m_context);

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #0x80000000
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe15007c1 }  // cmp r0, r1, ASR #15
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.m_context, { { .idx = 0, .expected_value = 0x80000000 },
                            { .idx = 1, .expected_value = 0xFFFFFFFF } }), false);
    // clang-format on

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}