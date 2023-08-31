#include "gtest/gtest.h"

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(ldrh_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3a02a01 }, // mov r2, #4096
    { 0xe5812000 }, // str r2, [r1]
    { 0xe3a0208c }, // mov r2, #0x8C
    { 0xe5c12000 }, // strb r2, [r1]
    { 0xe05100b1 }  // ldrh r0, [r1], #-8!
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0x0000108C);
    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x000000C7);
    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x0000008C);
}

TEST(ldrh_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02000 }, // mvn r2, #0
    { 0xe5812000 }, // str r2, [r1]
    { 0xe3a02002 }, // mov r2, #2
    { 0xe1b100b2 }  // ldrh r0, [r1, r2]!
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0x0000FFFF);
    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x000000CA);
}