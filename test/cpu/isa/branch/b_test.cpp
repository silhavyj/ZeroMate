#include <gtest/gtest.h>

#include "cpu/mocks/ram.hpp"
#include "cpu/arm1176jzf_s.hpp"

TEST(b_instruction, test_01)
{
    using namespace zero_mate::cpu;

    const std::vector<std::uint32_t> ram_content = {
        0xe320f000, // 00000000     nop
        0xea000000, // 00000004     b label1
        0xe320f000, // 00000008     nop
                    //          label1:
        0xe320f000, // 0000000C     nop
        0xe320f000  // 00000010     nop
    };

    CARM1176JZF_S cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    cpu.Step(2);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 12);
}

TEST(b_instruction, test_02)
{
    using namespace zero_mate::cpu;

    const std::vector<std::uint32_t> ram_content = {
        0xe320f000, // 00000000     nop
        0xe320f000, // 00000004     nop
                    //          label1:
        0xe320f000, // 00000008     nop
        0xe320f000, // 0000000C     nop
        0xeafffffc, // 00000010     b label1
    };

    CARM1176JZF_S cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    cpu.Step(5);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x8);
}

TEST(b_instruction, test_03)
{
    using namespace zero_mate::cpu;

    const std::vector<std::uint32_t> ram_content = {
        //          label1:
        0xeafffffe, // 00000000     b label1
    };

    CARM1176JZF_S cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    cpu.Step(10);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x0);
}

TEST(b_instruction, test_04)
{
    using namespace zero_mate::cpu;

    const std::vector<std::uint32_t> ram_content = {
        0xea000004, // 00000000     b label4
        0xe320f000, // 00000004     nop
        0xe320f000, // 00000008     bop
                    //          label2:
        0xe320f000, // 0000000C     nop
        0xe320f000, // 00000010     nop
                    //          label3:
        0xeafffffe, // 00000014     b label3
                    //          label4:
        0xe320f000, // 00000018     nop
        0xeafffffa, // 0000001C     b label2
    };

    CARM1176JZF_S cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    // Jump immediately to label4
    cpu.Step(1);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x18);

    // After a nop instruction, we should jump to label2
    cpu.Step(2);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x0C);

    // After two nop instructions, we should be at label3
    cpu.Step(2);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x14);

    // Infinite loop (stuck at label3)
    cpu.Step(2);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x14);
}