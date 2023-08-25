#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(smulwt_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe3a00008 }, // mov r0, #8
    { 0xe12200e1 }, // smulwt r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x0);
}

TEST(smulwt_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00901 }, // mov r0, #16384
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe12201e0 }, // smulwt r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x0);
}

TEST(smulwt_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00801 }, // mov r0, #65536
    { 0xe3e010cc }, // mvn r1, #0xCC
    { 0xe12201e0 }, // smulwt r2, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFFFF);
}

TEST(smulwt_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3e01801 }, // mvn r1, #65536
    { 0xe12200e1 }, // smulwt r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x0);
}

TEST(smulwt_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3e01801 }, // mvn r1, #65536
    { 0xe12201e0 }, // smulwt r2, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xFFFFFFFF);
}