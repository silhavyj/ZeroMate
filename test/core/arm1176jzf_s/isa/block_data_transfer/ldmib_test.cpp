#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(ldmib_instruction, test_01)
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
    { 0xe9811878 }, // stmib r1, {r3-r6,r11,r12}
    { 0xe9b1007c }  // ldmib r1!, {r2-r6}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 1);
    EXPECT_EQ(cpu.Get_CPU_Context()[3], 2);
    EXPECT_EQ(cpu.Get_CPU_Context()[4], 3);
    EXPECT_EQ(cpu.Get_CPU_Context()[5], 4);
    EXPECT_EQ(cpu.Get_CPU_Context()[6], 5);

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 220);
}