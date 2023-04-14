#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/cpu_core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;
TEST(stmia_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
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
    { 0xe8a11878 }  // stm r1!, {r3-r6,r11,r12}
    });

    EXPECT_EQ(bus->Read<std::uint32_t>(200), 1);
    EXPECT_EQ(bus->Read<std::uint32_t>(204), 2);
    EXPECT_EQ(bus->Read<std::uint32_t>(208), 3);
    EXPECT_EQ(bus->Read<std::uint32_t>(212), 4);
    EXPECT_EQ(bus->Read<std::uint32_t>(216), 5);
    EXPECT_EQ(bus->Read<std::uint32_t>(220), 6);
    EXPECT_EQ(cpu.m_regs[1], 224);
}

TEST(stmia_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>();
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
    { 0xe8811878 }, // stmia r1, {r3-r6,r11,r12}
    { 0xe5912000 }  // ldr r2, [r1]
    });

    EXPECT_EQ(bus->Read<std::uint32_t>(200), 1);
    EXPECT_EQ(bus->Read<std::uint32_t>(204), 2);
    EXPECT_EQ(bus->Read<std::uint32_t>(208), 3);
    EXPECT_EQ(bus->Read<std::uint32_t>(212), 4);
    EXPECT_EQ(bus->Read<std::uint32_t>(216), 5);
    EXPECT_EQ(bus->Read<std::uint32_t>(220), 6);
    EXPECT_EQ(cpu.m_regs[1], 200);
    EXPECT_EQ(cpu.m_regs[2], 1);
}