#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"

TEST(adc_instruction, test_01)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a000aa }, // mov r0, #170
    { 0xe3a01b02 }, // mov r1, #2048
    { 0xe0b01001 }  // adcs r1, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[1], 2218);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(adc_instruction, test_02)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a01005 }, // mov r1, #5
    { 0xe1b020a1 }, // movs r2, r1, LSR #1
    { 0xe2b2209b }  // adcs r2, r2, #155
    });

    EXPECT_EQ(cpu.m_regs[2], 155 + 2 + 1);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(adc_instruction, test_03)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mvn r0, #0x80000000
    { 0xe3a01001 }, // mov r1, #1
    { 0xe0902001 }, // adds r2, r0, r1
    { 0xe0b03001 }  // adcs r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x80000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(adc_instruction, test_04)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mvn r0, #0x80000000
    { 0xe3a01001 }, // mov r1, #1
    { 0xe0802001 }, // add r2, r0, r1
    { 0xe0a03001 }  // adc r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x80000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(adc_instruction, test_05)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #-2147483648
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0900001 }, // adds r0, r0, r1
    { 0xe0b03001 }  // adcs r0, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(adc_instruction, test_06)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #-2147483648
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0800001 }, // add r0, r0, r1
    { 0xe0b03001 }  // adcs r0, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x7FFFFFFE);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}