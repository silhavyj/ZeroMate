#include <gtest/gtest.h>

#include "cpu/mocks/ram.hpp"
#include "cpu/arm1176jzf_s.hpp"

TEST(bx_instruction, test_01)
{
    using namespace zero_mate::cpu;

    const std::vector<std::uint32_t> ram_content = {
        0xe3a0100c, // 00000000 mov r1, #12
        0xe12fff11, // 00000004 bx r1
        0xe320f000, // 00000008 nop
        0xe320f000, // 0000000C nop
        0xe320f000  // 00000010 nop
    };

    CARM1176JZF_S cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };
    cpu.Step(2);

    EXPECT_EQ(cpu.m_regs[1], 12);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 12);
}

TEST(bx_instruction, test_02)
{
    using namespace zero_mate::cpu;

    const std::vector<std::uint32_t> ram_content = {
        0xe3a04004, // 00000000 mov r4, #4
        0xe2811001, // 00000004 add r1, r1, #1
        0xe320f000, // 00000008 nop
        0xe320f000, // 0000000C nop
        0xe12fff14  // 00000010 bx r4
    };

    CARM1176JZF_S cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };
    cpu.Step(14);

    EXPECT_EQ(cpu.m_regs[1], 4);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 8);
}