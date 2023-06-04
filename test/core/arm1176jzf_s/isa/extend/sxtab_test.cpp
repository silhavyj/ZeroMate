#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(sxtab_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3a01102 }, // mov r1, #0x80000000
    { 0xe6a02c71 }  // sxtab r2, r0, r1, ROR #24
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x7F);
}

TEST(sxtab_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3e01102 }, // mvn r1, #0x80000000
    { 0xe6a02871 }  // sxtab r2, r0, r1, ROR #16
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFE);
}

TEST(sxtab_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00b01 }, // mvn r0, #1024
    { 0xe3e010ab }, // mvn r1, #0xAB
    { 0xe6a02071 }  // sxtab r2, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFC53);
}