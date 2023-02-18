#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"

TEST(eor_instruction, test_01)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a0006f }, // mov r0, #111
    { 0xe0300000 }  // eors r0, r0, r0
    });

    EXPECT_EQ(cpu.m_regs[0], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(eor_instruction, test_02)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a000aa }, // mov r0, #0b10101010
    { 0xe3a01055 }, // mov r1, #0b01010101
    { 0xe0302001 }  // eors r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(eor_instruction, test_03)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a000aa }, // mov r0, #0b10101010
    { 0xe3a01055 }, // mov r1, #0b01010101
    { 0xe0302481 }  // eors r2, r0, r1, LSL #9
    });

    EXPECT_EQ(cpu.m_regs[2], 0xAAAA);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(eor_instruction, test_04)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0302001 }  // eors r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(eor_instruction, test_05)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a0104d }, // mov r1, #77
    { 0xe3a020ff }, // mov r2, #255
    { 0xe0211002 }, // eor r1, r1, r2
    { 0xe0212002 }, // eor r2, r1, r2
    { 0xe0211002 }  // eor r1, r1, r2
    });

    EXPECT_EQ(cpu.m_regs[1], 255);
    EXPECT_EQ(cpu.m_regs[2], 77);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}