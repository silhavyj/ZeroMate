#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(ldmib_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3a03001 }, // mov r3, #1
    { 0xe3a04002 }, // mov r4, #2
    { 0xe3a05003 }, // mov r5, #3
    { 0xe3a06004 }, // mov r6, #4
    { 0xe3a0b005 }, // mov r11, #5
    { 0xe3a0c006 }, // mov r12, #6
    { 0xe9811878 }, // stmib r1, {r3-r6,r11,r12}
    { 0xe9b1007c }  // ldmib r1!, {r2-r6}
    });

    EXPECT_EQ(cpu.m_regs[2], 1);
    EXPECT_EQ(cpu.m_regs[3], 2);
    EXPECT_EQ(cpu.m_regs[4], 3);
    EXPECT_EQ(cpu.m_regs[5], 4);
    EXPECT_EQ(cpu.m_regs[6], 5);

    EXPECT_EQ(cpu.m_regs[1], 220);
}

TEST(ldmib_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a0d0c8 }, // mov sp, #200
    { 0xe3a03001 }, // mov r3, #1
    { 0xe3a04002 }, // mov r4, #2
    { 0xe3a05003 }, // mov r5, #3
    { 0xe3a06004 }, // mov r6, #4
    { 0xe3a0b005 }, // mov r11, #5
    { 0xe3a0c006 }, // mov r12, #6
    { 0xe92d1878 }, // push {r3-r6,r11,r12}
    { 0xe8bd00e0 }  // pop {r5-r7}
    });

    EXPECT_EQ(cpu.m_regs[5], 1);
    EXPECT_EQ(cpu.m_regs[6], 2);
    EXPECT_EQ(cpu.m_regs[7], 3);
}