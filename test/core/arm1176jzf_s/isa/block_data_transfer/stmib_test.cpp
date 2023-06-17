#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(stmib_instruction, test_01)
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
    { 0xe9a11878 }, // stmib r1!, {r3-r6,r11,r12}
    { 0xe5912000 }  // ldr r2, [r1]
    });

    EXPECT_EQ(bus->Read<std::uint32_t>(204), 1);
    EXPECT_EQ(bus->Read<std::uint32_t>(208), 2);
    EXPECT_EQ(bus->Read<std::uint32_t>(212), 3);
    EXPECT_EQ(bus->Read<std::uint32_t>(216), 4);
    EXPECT_EQ(bus->Read<std::uint32_t>(220), 5);
    EXPECT_EQ(bus->Read<std::uint32_t>(224), 6);
    EXPECT_EQ(cpu.Get_CPU_Context()[1], 224);
    EXPECT_EQ(cpu.Get_CPU_Context()[2], 6);
}

TEST(stmib_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    for (std::uint32_t idx = 1; idx < arm1176jzf_s::CCPU_Context::Number_Of_Regs; ++idx)
    {
        cpu.Get_CPU_Context()[idx] = 42 + idx;
    }

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xe9a0ffff }  // stmib r0!, {r0-r15}
    });

    for (std::size_t idx = 1; idx < arm1176jzf_s::CCPU_Context::Number_Of_Regs; ++idx)
    {
        EXPECT_EQ(bus->Read<std::uint32_t>(static_cast<std::uint32_t>(200 + (idx * arm1176jzf_s::CCPU_Context::Reg_Size) + arm1176jzf_s::CCPU_Context::Reg_Size)), 42 + idx);
    }

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 200 + (arm1176jzf_s::CCPU_Context::Number_Of_Regs * arm1176jzf_s::CCPU_Context::Reg_Size));
}