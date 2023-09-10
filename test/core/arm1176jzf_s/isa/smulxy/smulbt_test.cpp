#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"

TEST(smulbt_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe16100c1 }, // smulbt r1, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 1);
}

TEST(smulbt_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a010ab }, // mov r1, #0xAB
    { 0xe16100c1 }, // smulbt r1, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0xFFFFFF55);
}

TEST(smulbt_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe16200c1 }, // smulbt r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x0);
}