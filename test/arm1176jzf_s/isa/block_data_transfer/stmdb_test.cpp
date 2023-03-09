#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(stmdb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

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

    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 24), 1);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 20), 2);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 16), 3);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 12), 4);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 8), 5);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 4), 6);

    EXPECT_EQ(cpu.m_regs[1], 200 - 24);
}

TEST(stmdb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

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

    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 24), 1);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 20), 2);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 16), 3);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 12), 4);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 8), 5);
    EXPECT_EQ(ram->Read<std::uint32_t>(200 - 4), 6);

    EXPECT_EQ(cpu.m_regs[cpu.SP_REG_IDX], 200 - 24);
}