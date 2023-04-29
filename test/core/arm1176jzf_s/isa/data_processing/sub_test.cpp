#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(sub_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ba }, // mov r0, #186
    { 0xe3a01023 }, // mov r1, #35
    { 0xe0502001 }  // subs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 151);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(sub_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0502001 }  // subs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 0);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(sub_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0402001 }  // sub r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 0);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(sub_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0502001 }  // subs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 1);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(sub_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe0502001 }  // subs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(sub_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe2501001 }  // subs r1, r0, #1
    });

    EXPECT_EQ(cpu.m_context[1], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(sub_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mov r0, #0x7FFFFFFF
    { 0xe3e01000 }, // mov r1, #0xFFFFFFFF
    { 0xe0502001 }  // subs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 0x80000000);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(sub_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe2510102 } // subs r0, r1, #0x80000000
    });

    EXPECT_EQ(cpu.m_context[0], 0x80000000);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(sub_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0000f }, // mov r0, #15
    { 0xe3a01003 }, // mov r1, #0b11
    { 0xe0502001 }  // subs r2, r0, r1, ASR #0
    });

    EXPECT_EQ(cpu.m_context[2], 12);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(sub_instruction, test_10)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #0x80000000
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe05027c1 }  // subs r2, r0, r1, ASR #15
    });

    EXPECT_EQ(cpu.m_context[2], 0x80000001);

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::V), false);
}