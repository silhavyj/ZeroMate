#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(smulbb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a02000 }, // mov r2, #0
    { 0xe3a03008 }, // mov r3, #8
    { 0xe1630382 }, // smulbb r3, r2, r3
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0);
    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0);
}

TEST(smulbb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe1610180 }, // smulbb r1, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 1);
}

TEST(smulbb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ab }, // mov r0, #0xAB
    { 0xe3a0109b }, // mov r1, #155
    { 0xe3e02000 }, // mvn r2, #0
    { 0xe1620180 }, // smulbb r2, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x6789);
}