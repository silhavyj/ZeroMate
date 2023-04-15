#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"

TEST(add_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000aa }, // mov r0, #170
    { 0xe3a01b02 }, // mov r1, #2048
    { 0xe0901001 }  // adds r1, r0, r1
    });

    EXPECT_EQ(cpu.m_context[1], 2218);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(add_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mvn r0, #-2147483648
    { 0xe3a01001 }, // mov r1, #1
    { 0xe0901001 }  // adds r1, r0, r1
    });

    EXPECT_EQ(cpu.m_context[1], 0x80000000);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(add_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #-2147483648
    { 0xe3e01000 }, // mov r1, #-1
    { 0xe0900001 }  // adds r0, r0, r1
    });

    EXPECT_EQ(cpu.m_context[1], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(add_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe0900001 }  // adds r0, r0, r1
    });

    EXPECT_EQ(cpu.m_context[1], 0);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(add_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0300f }, // mov r3, #15
    { 0xe1a00283 }, // mov r0, r3, LSL #5
    { 0xe3a01000 }, // mov r1, #0
    { 0xe0900001 }  // adds r0, r0, r1
    });

    EXPECT_EQ(cpu.m_context[0], 480);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}