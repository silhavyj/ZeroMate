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