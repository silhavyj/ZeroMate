#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"

TEST(uxtab16_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3e01102 }, // mvn r1, #0x80000000
    { 0xe6c02071 }  // uxtab16 r2, r0, r1
    });

    EXPECT_EQ(cpu.m_context[2], 0x00FF01FE);
}

TEST(uxtab16_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xe3e01102 }, // mvn r1, #0x80000000
    { 0xe6c02c71 }  // uxtab16 r2, r0, r1, ROR #24
    });

    EXPECT_EQ(cpu.m_context[2], 0x00FF017E);
}

TEST(uxtab16_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe6c02871 }  // uxtab16 r2, r0, r1, ROR #16
    });

    EXPECT_EQ(cpu.m_context[2], 0x00FE00FE);
}