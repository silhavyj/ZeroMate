#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"

TEST(mvn_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3f05000 } // mvns r5, #0
    });

    EXPECT_EQ(cpu.m_context[5], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(mvn_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00007 }, // mov r0, #7
    { 0x11f001e0 }  // mvnsne r0, r0, ror #3
    });

    EXPECT_EQ(cpu.m_context[0], 0b00011111'11111111'11111111'11111111);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(mvn_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a04102 }, // mov r4, #0x80000000
    { 0xe3a05001 }, // mov r5, #1
    { 0xe1f06514 }  // mvns r6, r4, lsl r5
    });

    EXPECT_EQ(cpu.m_context[6], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(mvn_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a04003 }, // mov r4, #0b11
    { 0xe1b060e4 }  // movs r6, r4, ROR #1
    });

    EXPECT_EQ(cpu.m_context[6], 0b10000000'00000000'00000000'00000001);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);

    cpu.Execute({
    { 0x21f00004 } // mvnhss r0, r4, ror #0
    });

    EXPECT_EQ(cpu.m_context[0], 0xFFFFFFFC);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(mvn_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0x13e0b2bf } // mvnne r11, #0xF000000B
    });

    EXPECT_EQ(cpu.m_context[11], 0x0FFFFFF4);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(mvn_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01001 }, // mov r1, #1
    { 0xe1e00f81 }  // mvn r0, r1, lsl #31
    });

    EXPECT_EQ(cpu.m_context[0], 0x7FFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(mvn_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01001 }, // mov r1, #1
    { 0xe0300000 }, // eors r0, r0, r0
    { 0x01f000c1 }  // mvnseq r0, r1, asr #1
    });

    EXPECT_EQ(cpu.m_context[0], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(mvn_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01001 }, // mov r1, #1
    { 0xe3e000fe }, // mvn r0, #0x000000FE
    { 0xe1f02051 }  // mvns r2, r1, ASR r0
    });

    EXPECT_EQ(cpu.m_context[2], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}