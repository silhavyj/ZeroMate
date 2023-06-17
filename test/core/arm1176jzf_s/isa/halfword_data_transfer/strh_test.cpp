#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(strh_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e02004 }, // mov r2, #-5
    { 0xe1e120b0 }, // strh r2, [r1]!
    { 0xe5b13000 }  // ldr r3, [r1]!
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x000000C8);
    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x0000FFFB);
}

TEST(strh_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a010c8 }, // mov r1, #200
    { 0xe3e020a9 }, // mvn r2, #169
    { 0xe1c12fbc }, // strh r2, [r1, #252]
    { 0xe59130fc }  // ldr r3, [r1, #252]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x000000C8);
    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x0000FF56);
}