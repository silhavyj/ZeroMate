#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/cpu_core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(ldrsb_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

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
    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

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
    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

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