#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(ldrsh_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_SIZE);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02004 }, // mov r2, #-5
    { 0xe5812000 }, // str r2, [r1]
    { 0xe05100f1 }  // ldrsh r0, [r1], #0!
    });

    EXPECT_EQ(cpu.m_context[0], 0xFFFFFFFB);
    EXPECT_EQ(cpu.m_context[1], 0x000000C7);
    EXPECT_EQ(cpu.m_context[2], 0xFFFFFFFB);
}

TEST(ldrsh_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_SIZE);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02004 }, // mov r2, #-5
    { 0xe5812000 }, // str r2, [r1]
    { 0xe05100f1 }  // ldrsh r0, [r1], #0!
    });

    EXPECT_EQ(cpu.m_context[0], 0xFFFFFFFB);
    EXPECT_EQ(cpu.m_context[1], 0x000000C7);
    EXPECT_EQ(cpu.m_context[2], 0xFFFFFFFB);
}

TEST(ldrsh_instruction, test_03)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_SIZE);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

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

    EXPECT_EQ(cpu.m_context[0], 0x00007A7A);
    EXPECT_EQ(cpu.m_context[1], 0x000000C6);
    EXPECT_EQ(cpu.m_context[2], 0x0000007A);
}