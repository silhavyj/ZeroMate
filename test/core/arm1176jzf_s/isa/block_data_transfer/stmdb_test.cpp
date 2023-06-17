#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(stmdb_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3a03001 }, // mov r3, #1
    { 0xe3a04002 }, // mov r4, #2
    { 0xe3a05003 }, // mov r5, #3
    { 0xe3a06004 }, // mov r6, #4
    { 0xe3a0b005 }, // mov r11, #5
    { 0xe3a0c006 }, // mov r12, #6
    { 0xe9211878 }  // stmdb r1!, {r3-r6,r11,r12}
    });

    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 24), 1);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 20), 2);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 16), 3);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 12), 4);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 8), 5);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 4), 6);

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 200 - 24);
}

TEST(stmdb_instruction, test_02)
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
    { 0xe92d1878 }  // push {r3-r6,r11,r12}
    });

    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 24), 1);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 20), 2);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 16), 3);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 12), 4);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 8), 5);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 4), 6);

    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::SP_Reg_Idx], 200 - 24);
}