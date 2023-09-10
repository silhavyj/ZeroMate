#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"

TEST(smlatb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3a020ff }, // mov r2, #0xFF
    { 0xe10120a1 }, // smlatb r1, r1, r0, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x100);
}

TEST(smlatb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3e02801 }, // mvn r2, #65536
    { 0xe10220a1 }, // smlatb r2, r1, r0, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFF00AB);
}

TEST(smlatb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ab }, // mov r0, #0xAB
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe3e020ff }, // mvn r2, #0xFF
    { 0xe10220a1 }, // smlatb r2, r1, r0, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFF00);
}