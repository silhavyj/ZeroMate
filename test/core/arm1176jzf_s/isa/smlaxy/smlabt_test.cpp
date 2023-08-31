#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"

TEST(smlabt_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3a02801 }, // mov r2, #65536
    { 0xe10120c1 }, // smlabt r1, r1, r0, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x00010001);
}

TEST(smlabt_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a010ab }, // mov r1, #0xAB
    { 0xe3e02801 }, // mvn r2, #65536
    { 0xe10120c1 }, // smlabt r1, r1, r0, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0xFFFEFF54);
}

TEST(smlabt_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe3e02000 }, // mvn r2, #0
    { 0xe10220c1 }, // smlabt r2, r1, r0, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFFFF);
}