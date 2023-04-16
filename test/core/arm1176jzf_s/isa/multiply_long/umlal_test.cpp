#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(umlal_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00009 }, // mov r0, #0xFFFFFFF6
    { 0xe3e01009 }, // mov r1, #0xFFFFFFF6
    { 0xe0b01190 }  // umlals r1, r0, r0, r1
    });

    EXPECT_EQ(cpu.m_context[0], 0xFFFFFFE3);
    EXPECT_EQ(cpu.m_context[1], 0x0000005A);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(umlal_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00009 }, // mov r0, #0xFFFFFFF6
    { 0xe3e01009 }, // mov r1, #0xFFFFFFF6
    { 0xe0b23190 }  // umlals r3, r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 0xFFFFFFEC);
    EXPECT_EQ(cpu.m_context[3], 0x00000064);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(umlal_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00005 }, // mov r0, #5
    { 0xe3a01003 }, // mov r1, #3
    { 0xe0b01190 }  // umlals r1, r0, r0, r1
    });

    EXPECT_EQ(cpu.m_context[0], 5);
    EXPECT_EQ(cpu.m_context[1], 18);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(umlal_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0b32190 }  // umlals r2, r3, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 0);
    EXPECT_EQ(cpu.m_context[3], 0);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}