#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"

TEST(rsb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a010ba }, // mov r1, #186
    { 0xe3a00023 }, // mov r0, #35
    { 0xe0702001 }  // rsbs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 151);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe0702001 }  // rsbs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01000 }, // mvn r0, #0
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe0602001 }  // rsb r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01000 }, // mov r1, #0
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe0702001 }  // rsbs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 1);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3a00000 }, // mov r0, #0
    { 0xe0702001 }  // rsbs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe2710001 }  // rsbs r0, r1, #1
    });

    EXPECT_EQ(cpu.m_regs[1], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01102 }, // mov r1, #0x7FFFFFFF
    { 0xe3e00000 }, // mov r0, #0xFFFFFFFF
    { 0xe0702001 }  // rsbs r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0x80000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(rsb_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe2701102 } // rsbs r1, r0, #0x80000000
    });

    EXPECT_EQ(cpu.m_regs[0], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0100f }, // mov r, #15
    { 0xe3a00003 }, // mov r0, #0b11
    { 0xe0702001 }  // rsbs r2, r0, r1, ASR #0
    });

    EXPECT_EQ(cpu.m_regs[2], 12);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(rsb_instruction, test_10)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01102 }, // mov r1, #0x80000000
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe07027c1 }  // rsbs r2, r0, r1, ASR #15
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFFFF0001);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}