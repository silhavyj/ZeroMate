#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"

TEST(bic_instruction, test_01)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe1d02001 }  // bics r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(bic_instruction, test_02)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe1d02001 }  // bics r2, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}