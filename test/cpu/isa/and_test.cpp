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