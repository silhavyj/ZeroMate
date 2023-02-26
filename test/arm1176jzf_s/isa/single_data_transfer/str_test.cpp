#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(str_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a05014 }, // mov r5, #20
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3a00b01 }, // mov r0, #1024
    { 0xe7850001 }  // str r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<std::uint32_t>(24), 1024);
}

TEST(str_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }  // strb r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<std::uint8_t>(228), 0x54);
}

TEST(str_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }  // strb r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<std::uint8_t>(220), 0x54);
}

TEST(str_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe2411001 }, // sub r1, r1, #1
    { 0xe7c50001 }  // strb r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<std::uint8_t>(220), 0x54);
    EXPECT_EQ(ram->Read<std::uint8_t>(219), 0x54);
}

TEST(str_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xe3a0100d }, // mov r1, #13
    { 0xe5801004 }, // str r1, [r0, #4]
    });

    EXPECT_EQ(ram->Read<std::uint32_t>(204), 13);
}

TEST(str_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c02 }, // mov r0, #512
    { 0xe3a010a9 }, // mov r1, #169
    { 0xe3a02002 }, // mov r2, #2
    { 0xe6c01002 }  // strb r1, [r0], r2
    });

    EXPECT_EQ(ram->Read<std::uint8_t>(512), 169);
    EXPECT_EQ(cpu.m_regs[0], 514);
}

TEST(str_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c02 }, // mov r0, #512
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe7801101 }  // str r1, [r0, r1, LSL #2]
    });

    EXPECT_EQ(ram->Read<std::uint32_t>(496), 0xfffffffc);
}

TEST(str_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c01 }, // mov r0, #256
    { 0xe3e010ab }, // mvn r1, #0xAB
    { 0xe5001004 }, // str r1, [r0, #-4]
    { 0xe3a01035 }, // mov r1, #53
    { 0xe5401001 }  // strb r1, [r0, #-1]
    });

    EXPECT_EQ(ram->Read<std::uint32_t>(252), 0x35FFFF54);
}

TEST(str_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a00c01 }, // mov r0, #256
    { 0xe3e010ab }, // mvn r1, #0xAB
    { 0xe5001004 }, // str r1, [r0, #-4]
    { 0xe3a01035 }, // mov r1, #53
    { 0xe5c01001 }  // strb r1, [r0, #1]
    });

    EXPECT_EQ(ram->Read<std::uint32_t>(252), 0xFFFFFF54);
    EXPECT_EQ(ram->Read<std::uint8_t>(257), 0x35);
    EXPECT_EQ(ram->Read<std::uint8_t>(256), 0x0);
    EXPECT_EQ(ram->Read<std::uint8_t>(255), 0xFF);
    EXPECT_EQ(ram->Read<std::uint32_t>(254), 0x3500FFFF);
}