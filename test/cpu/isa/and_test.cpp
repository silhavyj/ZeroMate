#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"

TEST(and_instruction, test_01)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01106 }, // mov r1, 0x80000001
    { 0xe0101001 }  // ands r1, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[1], 0x80000001);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
}

TEST(and_instruction, test_02)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01106 }, // mov r1, 0x80000001
    { 0xe0001001 }  // and r1, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[1], 0x80000001);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
}

TEST(and_instruction, test_03)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00001 }, // mov r0, #1
    { 0xe3a01097 }, // mov r1, #0b10010111
    { 0xe0112200 }  // ands r2, r1, r0, LSL #4
    });

    EXPECT_EQ(cpu.m_regs[2], 0b10000);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
}

TEST(and_instruction, test_04)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00001 }, // mov r0, #1
    { 0xe3a01087 }, // mov r1, #0b10000111
    { 0xe0112200 }  // ands r2, r1, r0, LSL #4
    });

    EXPECT_EQ(cpu.m_regs[2], 0);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
}

TEST(and_instruction, test_05)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01007 }, // mov r1, #b111
    { 0xe01021e1 }  // ands r2, r0, r1, ror #3
    });

    EXPECT_EQ(cpu.m_regs[2], 0b11100000'00000000'00000000'00000000);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
}