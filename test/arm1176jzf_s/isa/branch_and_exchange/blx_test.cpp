#include <gtest/gtest.h>

#include "peripherals/ram.hpp"
#include "arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(blx_instruction, test_01)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe3a04010, // 00000000 mov r4, #0x10
        0xe0200000, // 00000004 eor r0, r0, r0
        0xe12fff34, // 00000008 blx r4
        0xe320f000, // 0000000C nop
        0xe3500003, // 00000010 cmp r0, #3
        0x01a0f00e, // 00000014 moveq pc, lr
        0xe2800001, // 00000018 add r0, r0, #1
        0xe12fff14  // 0000001C bx r4
    };

    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>(0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    // blx r4
    cpu.Step(3);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x10);
    EXPECT_EQ(cpu.m_regs[0], 0);

    // bx r4 (first iteration)
    cpu.Step(4);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x10);
    EXPECT_EQ(cpu.m_regs[0], 1);

    // 2 more iterations + cmp and mov (r0 should be 3)
    cpu.Step(10);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x0C);
    EXPECT_EQ(cpu.m_regs[0], 3);
}