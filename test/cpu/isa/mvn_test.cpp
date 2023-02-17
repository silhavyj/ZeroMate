#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"

TEST(mvn_instruction, test_01)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3f05000 } // mvns r5, #0
    });

    EXPECT_EQ(cpu.m_regs[5], 0xFFFFFFFF);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
}

TEST(mvn_instruction, test_02)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00007 }, // mov r0, #7
    { 0x11f001e0 }  // mvnsne r0, r0, ror #3
    });

    EXPECT_EQ(cpu.m_regs[0], 0b00011111'11111111'11111111'11111111);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
}

TEST(mvn_instruction, test_03)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a04102 }, // mov r4, 0x80000000
    { 0xe3a05001 }, // mov r5, #1
    { 0xe1f06514 }  // mvns r6, r4, lsl r5
    });

    EXPECT_EQ(cpu.m_regs[6], 0xFFFFFFFF);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
}

TEST(mvn_instruction, test_04)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a04003 }, // mov r4, #0b11
    { 0xe1b060e4 }  // movs r6, r4, ROR #1
    });

    EXPECT_EQ(cpu.m_regs[6], 0b10000000'00000000'00000000'00000001);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);

    cpu.Execute({
    { 0x21f00004 } // mvnhss r0, r4, ror #0
    });

    EXPECT_EQ(cpu.m_regs[0], 0xFFFFFFFC);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
}