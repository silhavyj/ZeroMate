#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"

TEST(smlabb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a02000 }, // mov r2, #0
    { 0xe3a03008 }, // mov r3, #8
    { 0xe3a040ff }, // mov r4, #0xFF
    { 0xe1034382 }  // smlabb r3, r2, r3, r4
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0xFF);
}

TEST(smlabb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3a02801 }, // mov r2, #65536
    { 0xe1012180 }, // smlabb r1, r0, r1, r2
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x00010001);
}

TEST(smlabb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ab }, // mov r0, #0xAB
    { 0xe3a0109b }, // mov r1, #155
    { 0xe3e02000 }, // mvn r2, #0
    { 0xe3a03801 }, // mov r3, #65536
    { 0xe1023180 }, // smlabb r2, r0, r1, r3
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x16789);
}