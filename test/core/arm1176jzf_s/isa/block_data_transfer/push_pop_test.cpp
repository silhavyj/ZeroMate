#include "gtest/gtest.h"

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(push_pop_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a0d0c8 }, // mov sp, #200
    { 0xe3a03001 }, // mov r3, #1
    { 0xe3a04002 }, // mov r4, #2
    { 0xe3a05003 }, // mov r5, #3
    { 0xe3a06004 }, // mov r6, #4
    { 0xe3a0b005 }, // mov r11, #5
    { 0xe3a0c006 }, // mov r12, #6
    { 0xe92d1878 }, // push {r3-r6,r11,r12}
    { 0xe8bd00e0 }  // pop {r5-r7}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[5], 1);
    EXPECT_EQ(cpu.Get_CPU_Context()[6], 2);
    EXPECT_EQ(cpu.Get_CPU_Context()[7], 3);
}

TEST(push_pop_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a0d0c8 }, // mov sp, #200
    { 0xe92d581f }  // push { r0, r1, r2, r3, r4, fp, ip, lr }
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::SP_Reg_Idx], 0xA8);

    cpu.Execute({
    { 0xe8bd981f } // ldm sp!, { r0, r1, r2, r3, r4, fp, ip, pc }
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::SP_Reg_Idx], 0xC8);
}

TEST(push_pop_instruction, test_03)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe3a0d0c8, // mov sp, #200
        0xebffffff, // bl 0x8
        0xe24ee004, // sub lr, lr, #4
        0xe92d581f, // push { r0, r1, r2, r3, r4, fp, ip, lr }
        0xe8bd981f  // ldm sp!, { r0, r1, r2, r3, r4, fp, ip, pc }
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Steps(5 + 4 * 20);

    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 4);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::SP_Reg_Idx], 200);
}