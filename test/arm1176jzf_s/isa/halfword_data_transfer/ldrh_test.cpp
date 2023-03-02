#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(ldrh_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3a02a01 }, // mov r2, #4096
    { 0xe5812000 }, // str r2, [r1]
    { 0xe3a0208c }, // mov r2, #0x8C
    { 0xe5c12000 }, // strb r2, [r1]
    { 0xe05100b1 }  // ldrh r0, [r1], #-8!
    });

    EXPECT_EQ(cpu.m_regs[0], 0x0000108C);
    EXPECT_EQ(cpu.m_regs[1], 0x000000C7);
    EXPECT_EQ(cpu.m_regs[2], 0x0000008C);
}