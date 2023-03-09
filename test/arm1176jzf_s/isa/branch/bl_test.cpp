#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(bl_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    const std::vector<std::uint32_t> ram_content = {
        0xea000001, // 00000000     b main
                    //          add:
        0xe0810002, // 00000004     addr r0, r1, r2
        0xe12fff1e, // 00000008     bx lr
                    //          main:
        0xe3a01021, // 0000000C     mov r1, #33
        0xe3a02011, // 00000010     mov r2, #17
        0xebfffffa, // 00000014     bl add
        0xe320f000, // 00000018     nop
    };

    CCPU_Core cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    // Skip the add subroutine (jump to main)
    cpu.Step(1);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x0C);

    // Entered the subroutine
    cpu.Step(3);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x04);

    // Returned from the subroutine (r0 should equal to 50)
    cpu.Step(2);
    EXPECT_EQ(cpu.m_regs[cpu.PC_REG_IDX], 0x18);
    EXPECT_EQ(cpu.m_regs[0], 50);
}