#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(smultb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe16100a1 }, // smultb r1, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 1);
}

TEST(smultb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e000ab }, // mvn r0, #0xAB
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe16200a1 }, // smultb r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xAC);
}

TEST(smultb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ab }, // mov r0, #0xAB
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe16200a1 }, // smultb r2, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x0);
}