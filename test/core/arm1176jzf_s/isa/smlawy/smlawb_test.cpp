#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"

TEST(smlawb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01008 }, // mov r1, #8
    { 0xe3e02801 }, // mvn r2, #65536
    { 0xe1222081 }, // smlawb r2, r1, r0, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFEFFFE);
}

TEST(smlawb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01008 }, // mov r1, #8
    { 0xe1220180 }, // smlawb r2, r0, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFFFE);
}

TEST(smlawb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00a02 }, // mov r0, #8192
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe1220180 }, // smlawb r2, r0, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x201F);
}