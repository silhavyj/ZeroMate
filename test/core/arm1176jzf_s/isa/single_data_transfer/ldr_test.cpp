#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(ldr_instruction, test_01)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a05014 }, // mov r5, #20
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3a00b01 }, // mov r0, #1024
    { 0xe7850001 }, // str r0, [r5, r1]
    { 0xe7950001 }  // ldr r0, [r5, r1]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 1024);
}

TEST(ldr_instruction, test_02)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe7d50001 }, // ldrb r0, [r5, r1]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0x54);
}

TEST(ldr_instruction, test_04)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe2411001 }, // sub r1, r1, #1
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe7950001 }, // ldr r0, [r5, r1]
    { 0xe7952081 }  // ldr r2, [r5, r1, LSL #1]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0x54);
    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x54000000);
}

TEST(ldr_instruction, test_05)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a00c02 }, // mov r0, #512
    { 0xe3a010a9 }, // mov r1, #169
    { 0xe3a02002 }, // mov r2, #2
    { 0xe6c01002 }, // strb r1, [r0], r2
    { 0xe6d01002 }  // ldrb r1, [r0], r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 516);
    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0);
    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x2);
}

TEST(ldr_instruction, test_06)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a00c02 }, // mov r0, #512
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe7801101 }, // str r1, [r0, r1, LSL #2]
    { 0xe7903101 }  // ldr r1, [r0, r1, LSL #2]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0xfffffffc);
}

TEST(ldr_instruction, test_07)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a00c01 }, // mov r0, #256
    { 0xe3e010ab }, // mvn r1, #0xAB
    { 0xe5001004 }, // str r1, [r0, #-4]
    { 0xe3a01035 }, // mov r1, #53
    { 0xe5401001 }, // strb r1, [r0, #-1]
    { 0xe5102004 }  // ldr r2, [r0, #-4]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x35FFFF54);
}

TEST(ldr_instruction, test_08)
{
    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Execute({
    { 0xe3a00c01 }, // mov r0, #256
    { 0xe3e010ab }, // mvn r1, #0xAB
    { 0xe5001004 }, // str r1, [r0, #-4]
    { 0xe3a01035 }, // mov r1, #53
    { 0xe5c01001 }, // strb r1, [r0, #1]
    { 0xe5d02000 }, // ldrb r2, [r0]
    { 0xe5503001 }, // ldrb r3, [r0, #-1]
    { 0xe5d04001 }, // ldrb r4, [r0, #1]
    { 0xe5105004 }  // ldr r5, [r0, #-4]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x00);
    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0xFF);
    EXPECT_EQ(cpu.Get_CPU_Context()[4], 0x35);
    EXPECT_EQ(cpu.Get_CPU_Context()[5], 0xFFFFFF54);
}

TEST(ldr_instruction, test_09)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe59f3004, // ldr r3, [pc]
        0xe3a01001, // mov r1, #1
        0xe3a02002, // mov r2, #2
        0xe3a02003, // mov r2, #3
        0xe3a02004  // mov r2, #4
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Step();

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0xe3a02003);
}