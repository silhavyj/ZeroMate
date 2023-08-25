#include <gtest/gtest.h>

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