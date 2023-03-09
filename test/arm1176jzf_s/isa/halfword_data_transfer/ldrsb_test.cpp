#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(ldrsb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02004 }, // mov r2, #-5
    { 0xe5812000 }, // str r2, [r1]
    { 0xe05100d1 }  // ldrsb r0, [r1], #0!
    });

    EXPECT_EQ(cpu.m_regs[0], 0xFFFFFFFB);
    EXPECT_EQ(cpu.m_regs[1], 0x000000C7);
    EXPECT_EQ(cpu.m_regs[2], 0xFFFFFFFB);
}

TEST(ldrsb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3a02a01 }, // mov r2, #4096
    { 0xe5812000 }, // str r2, [r1]
    { 0xe3a020bc }, // mov r2, #0xBC
    { 0xe5c12000 }, // strb r2, [r1]
    { 0xe3a03000 }, // mov r3, #0
    { 0xe13100d3 }  // ldrsb r0, [r1, -r3]!
    });

    EXPECT_EQ(cpu.m_regs[0], 0xFFFFFFBC);
    EXPECT_EQ(cpu.m_regs[1], 0x000000C8);
    EXPECT_EQ(cpu.m_regs[2], 0x000000BC);
}

TEST(ldrsb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3a02a01 }, // mov r2, #4096
    { 0xe5812000 }, // str r2, [r1]
    { 0xe3a0200c }, // mov r2, #0x0C
    { 0xe5c12000 }, // strb r2, [r1]
    { 0xe05100d1 }  // ldrsb r0, [r1], #-8!
    });

    EXPECT_EQ(cpu.m_regs[0], 0x0000000C);
    EXPECT_EQ(cpu.m_regs[1], 0x000000C7);
    EXPECT_EQ(cpu.m_regs[2], 0x0000000C);
}