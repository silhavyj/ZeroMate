#include <gtest/gtest.h>

#include "peripherals/ram.hpp"
#include "arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(bx_instruction, test_01)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe3a0100c, // 00000000 mov r1, #12
        0xe12fff11, // 00000004 bx r1
        0xe320f000, // 00000008 nop
        0xe320f000, // 0000000C nop
        0xe320f000  // 00000010 nop
    };

    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>(0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Step(2);
    EXPECT_EQ(cpu.m_regs[1], 12);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 12);
}

TEST(bx_instruction, test_02)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe3a04004, // 00000000 mov r4, #4
        0xe2811001, // 00000004 add r1, r1, #1
        0xe320f000, // 00000008 nop
        0xe320f000, // 0000000C nop
        0xe12fff14  // 00000010 bx r4
    };

    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>(0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Step(14);
    EXPECT_EQ(cpu.m_regs[1], 4);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 8);
}