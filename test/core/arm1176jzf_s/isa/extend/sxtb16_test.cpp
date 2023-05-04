#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(sxtb16_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e030ab }, // mvn r3, #0xAB
    { 0xe68f3073 }  // sxtb16 r3, r3
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0xFFFF0054);
}

TEST(sxtb16_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e030ab }, // mvn r3, #0xAB
    { 0xe68f3473 }  // sxtb16 r3, r3, ROR #8
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0xFFFFFFFF);
}

TEST(sxtb16_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03102 }, // mov r3, #0x80000000
    { 0xe68f3c73 }  // sxtb16 r3, r3, ROR #24
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x0000FF80);
}

TEST(sxtb16_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03001 }, // mov r3, #0x1
    { 0xe68f3873 }  // sxtb16 r3, r3, ROR #16
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x00010000);
}