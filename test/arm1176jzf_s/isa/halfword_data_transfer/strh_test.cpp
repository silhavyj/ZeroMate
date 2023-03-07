#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(strh_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02004 }, // mov r2, #-5
    { 0xe1e120b0 }, // strh r2, [r1]!
    { 0xe5b13000 }  // ldr r3, [r1]!
    });

    EXPECT_EQ(cpu.m_regs[1], 0x000000C8);
    EXPECT_EQ(cpu.m_regs[3], 0x0000FFFB);
}

TEST(strh_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e020a9 }, // mvn r2, #169
    { 0xe1c12fbc }, // strh r2, [r1, #252]
    { 0xe59130fc }  // ldr r3, [r1, #252]
    });

    EXPECT_EQ(cpu.m_regs[1], 0x000000C8);
    EXPECT_EQ(cpu.m_regs[3], 0x0000FF56);
}