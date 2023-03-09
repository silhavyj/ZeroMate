#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(ldrsh_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02004 }, // mov r2, #-5
    { 0xe5812000 }, // str r2, [r1]
    { 0xe05100f1 }  // ldrsh r0, [r1], #0!
    });

    EXPECT_EQ(cpu.m_regs[0], 0xFFFFFFFB);
    EXPECT_EQ(cpu.m_regs[1], 0x000000C7);
    EXPECT_EQ(cpu.m_regs[2], 0xFFFFFFFB);
}

TEST(ldrsh_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02004 }, // mov r2, #-5
    { 0xe5812000 }, // str r2, [r1]
    { 0xe05100f1 }  // ldrsh r0, [r1], #0!
    });

    EXPECT_EQ(cpu.m_regs[0], 0xFFFFFFFB);
    EXPECT_EQ(cpu.m_regs[1], 0x000000C7);
    EXPECT_EQ(cpu.m_regs[2], 0xFFFFFFFB);
}

TEST(ldrsh_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02000 }, // mvn r2, #0
    { 0xe5812000 }, // str r2, [r1]
    { 0xe3a0207a }, // mov r2, #0x7A
    { 0xe2411001 }, // sub r1, r1, #1
    { 0xe5c12000 }, // strb r2, [r1]
    { 0xe2411001 }, // sub r1, r1, #1
    { 0xe5c12000 }, // strb r2, [r1]
    { 0xe1d100f0 }  // ldrsh r0, [r1]
    });

    EXPECT_EQ(cpu.m_regs[0], 0x00007A7A);
    EXPECT_EQ(cpu.m_regs[1], 0x000000C6);
    EXPECT_EQ(cpu.m_regs[2], 0x0000007A);
}