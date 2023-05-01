#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(srsdb_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_SIZE);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe169f000 }, // msr spsr, r0
    { 0xe3a0e00e }, // mov lr, #14
    { 0xe3a0d0c8 }, // mov sp, #200
    { 0xf96d0513 }, // srsdb #19!
    { 0xe3a020c0 }, // mov r2, #192
    { 0xe5924000 }, // ldr r4, [r2]
    { 0xe3a020c4 }, // mov r2, #196
    { 0xe5925000 }  // ldr r5, [r2]
    });

    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 8), 14);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 4), 0xFF000054);

    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::SP_REG_IDX], 0xC0);
    EXPECT_EQ(cpu.Get_CPU_Context()[4], 14);
    EXPECT_EQ(cpu.Get_CPU_Context()[5], 0xFF000054);
}

TEST(srsdb_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_SIZE);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe169f000 }, // msr spsr, r0
    { 0xe3a0e00e }, // mov lr, #14
    { 0xe3a0d0c8 }, // mov sp, #200
    { 0xf94d0513 }  // srsdb #19
    });

    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 8), 14);
    EXPECT_EQ(bus->Read<std::uint32_t>(200 - 4), 0xFF000054);

    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::SP_REG_IDX], 200);
}