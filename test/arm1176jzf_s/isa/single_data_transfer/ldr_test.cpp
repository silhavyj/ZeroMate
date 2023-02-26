#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(ldr_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a05014 }, // mov r5, #20
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3a00b01 }, // mov r0, #1024
    { 0xe7850001 }, // str r0, [r5, r1]
    { 0xe7950001 }  // ldr r0, [r5, r1]
    });

    EXPECT_EQ(cpu.m_regs[0], 1024);
}

TEST(ldr_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe7d50001 }, // ldrb r0, [r5, r1]
    });

    EXPECT_EQ(cpu.m_regs[0], 0x54);
}

TEST(ldr_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe2411001 }, // sub r1, r1, #1
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe7950001 }, // ldr r0, [r5, r1]
    { 0xe7952081 }  // ldr r2, [r5, r1, LSL #1]
    });

    EXPECT_EQ(cpu.m_regs[0], 0x54);
    EXPECT_EQ(cpu.m_regs[2], 0x54000000);
}

TEST(ldr_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c02 }, // mov r0, #512
    { 0xe3a010a9 }, // mov r1, #169
    { 0xe3a02002 }, // mov r2, #2
    { 0xe6c01002 }, // strb r1, [r0], r2
    { 0xe6d01002 }  // ldrb r1, [r0], r2
    });

    EXPECT_EQ(cpu.m_regs[0], 516);
    EXPECT_EQ(cpu.m_regs[1], 0);
    EXPECT_EQ(cpu.m_regs[2], 0x2);
}

TEST(ldr_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c02 }, // mov r0, #512
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe7801101 }, // str r1, [r0, r1, LSL #2]
    { 0xe7903101 }  // ldr r1, [r0, r1, LSL #2]
    });

    EXPECT_EQ(cpu.m_regs[3], 0xfffffffc);
}

TEST(ldr_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c01 }, // mov r0, #256
    { 0xe3e010ab }, // mvn r1, #0xAB
    { 0xe5001004 }, // str r1, [r0, #-4]
    { 0xe3a01035 }, // mov r1, #53
    { 0xe5401001 }, // strb r1, [r0, #-1]
    { 0xe5102004 }  // ldr r2, [r0, #-4]
    });

    EXPECT_EQ(cpu.m_regs[2], 0x35FFFF54);
}

TEST(ldr_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c01 }, // mov r0, #256
    { 0xe3e010ab }, // mvn r1, #0xAB
    { 0xe5001004 }, // str r1, [r0, #-4]
    { 0xe3a01035 }, // mov r1, #53
    { 0xe5c01001 }, // strb r1, [r0, #1]
    { 0xe5d02000 }, // ldrb r2, [r0]
    { 0xe5503001 }, // ldrb r3, [r0, #-1]
    { 0xe5d04001 }, // ldrb r4, [r0, #1]
    { 0xe5105004 }  // ldr r5, [r0, #-4]
    });

    EXPECT_EQ(cpu.m_regs[2], 0x00);
    EXPECT_EQ(cpu.m_regs[3], 0xFF);
    EXPECT_EQ(cpu.m_regs[4], 0x35);
    EXPECT_EQ(cpu.m_regs[5], 0xFFFFFF54);
}