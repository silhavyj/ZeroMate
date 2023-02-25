#include <gtest/gtest.h>

#include "cpu/mocks/ram.hpp"
#include "cpu/arm1176jzf_s.hpp"

TEST(str_instruction, test_01)
{
    using namespace zero_mate::cpu;

    auto ram = std::make_shared<mocks::CRAM>();
    CARM1176JZF_S cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a05014 }, // mov r5, #20
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3a00b01 }, // mov r0, #1024
    { 0xe7850001 }  // str r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<CARM1176JZF_S::word_t>(24), 1024);
}

TEST(str_instruction, test_02)
{
    using namespace zero_mate::cpu;

    auto ram = std::make_shared<mocks::CRAM>();
    CARM1176JZF_S cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3a01004 }, // mov r1, #4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }  // strb r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<CARM1176JZF_S::byte_t>(228), 0x54);
}

TEST(str_instruction, test_03)
{
    using namespace zero_mate::cpu;

    auto ram = std::make_shared<mocks::CRAM>();
    CARM1176JZF_S cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }  // strb r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<CARM1176JZF_S::byte_t>(220), 0x54);
}

TEST(str_instruction, test_04)
{
    using namespace zero_mate::cpu;

    auto ram = std::make_shared<mocks::CRAM>();
    CARM1176JZF_S cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a050e0 }, // mov r5, #224
    { 0xe3e01003 }, // mov r1, #-4
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe7c50001 }, // strb r0, [r5, r1]
    { 0xe2411001 }, // sub r1, r1, #1
    { 0xe7c50001 }  // strb r0, [r5, r1]
    });

    EXPECT_EQ(ram->Read<CARM1176JZF_S::byte_t>(220), 0x54);
    EXPECT_EQ(ram->Read<CARM1176JZF_S::byte_t>(219), 0x54);
}

TEST(str_instruction, test_05)
{
    using namespace zero_mate::cpu;

    auto ram = std::make_shared<mocks::CRAM>();
    CARM1176JZF_S cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xe3a0100d }, // mov r1, #13
    { 0xe5801004 }, // str r1, [r0, #4]
    });

    EXPECT_EQ(ram->Read<CARM1176JZF_S::word_t>(204), 13);
}