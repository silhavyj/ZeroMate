#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(smultt_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe16100e1 }, // smultt r1, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 1);
}

TEST(smultt_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe16200e1 }, // smultt r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0);
}

TEST(smultt_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00801 }, // mvn r0, #65536
    { 0xe3a01801 }, // mov r1, #65536
    { 0xe16200e1 }, // smultt r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFFFE);
}