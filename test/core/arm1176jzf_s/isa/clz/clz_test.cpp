#include "gtest/gtest.h"
#include "fmt/format.h"

#include "core/arm1176jzf_s/core.hpp"

TEST(clz_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0009b }, // mov r0, #155
    { 0xe16f1f10 }  // clz r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x18);
}

TEST(clz_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe16f1f10 }  // clz r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 32);
}

TEST(clz_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe16f1f10 }  // clz r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0);
}