#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"

TEST(smlawt_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3a00008 }, // mov r0, #8
    { 0xe12000c1 }, // smlawt r0, r1, r0, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0x8);
}

TEST(smlawt_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00901 }, // mov r0, #16384
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe12200c1 }, // smlawt r2, r1, r0, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x4000);
}