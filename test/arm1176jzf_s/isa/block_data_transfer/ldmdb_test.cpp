#include <gtest/gtest.h>

#include "peripherals/ram.hpp"
#include "arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(ldmdb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3a03001 }, // mov r3, #1
    { 0xe3a04002 }, // mov r4, #2
    { 0xe3a05003 }, // mov r5, #3
    { 0xe3a06004 }, // mov r6, #4
    { 0xe3a0b005 }, // mov r11, #5
    { 0xe3a0c006 }, // mov r12, #6
    { 0xe9011878 }, // stmdb r1, {r3-r6,r11,r12}
    { 0xe931007c }  // ldmdb r1!, {r2-r6}
    });

    EXPECT_EQ(cpu.m_regs[2], 2);
    EXPECT_EQ(cpu.m_regs[3], 3);
    EXPECT_EQ(cpu.m_regs[4], 4);
    EXPECT_EQ(cpu.m_regs[5], 5);
    EXPECT_EQ(cpu.m_regs[6], 6);

    EXPECT_EQ(cpu.m_regs[1], 180);
}