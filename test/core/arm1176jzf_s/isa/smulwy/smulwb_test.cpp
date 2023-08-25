#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(smulwb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01008 }, // mov r1, #8
    { 0xe12200a1 }, // smulwb r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFFFF);
}

TEST(smulwb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01008 }, // mov r1, #8
    { 0xe12201a0 }, // smulwb r2, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFFFF);
}

TEST(smulwb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00a02 }, // mov r0, #8192
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe12201a0 }, // smulwb r2, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x1F);
}

TEST(smulwb_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe12201a0 }, // smulwb r2, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x0);
}