#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(bl_instruction, test_01)
{
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

    auto ram = std::make_shared<peripheral::CRAM>(RAM_SIZE, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    // Skip the add subroutine (jump to main)
    cpu.Steps(1);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_REG_IDX], 0x0C);

    // Entered the subroutine
    cpu.Steps(3);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_REG_IDX], 0x04);

    // Returned from the subroutine (r0 should equal to 50)
    cpu.Steps(2);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_REG_IDX], 0x18);
    EXPECT_EQ(cpu.Get_CPU_Context()[0], 50);
}