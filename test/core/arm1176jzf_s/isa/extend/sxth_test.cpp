#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(sxth_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03102 }, // mvn r3, #0x80000000
    { 0xe6bf3873 }  // sxth r3, r3, ROR #16
    });

    EXPECT_EQ(cpu.m_context[3], 0x7FFF);
}

TEST(sxth_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a030ff }, // mov r3, #0xFF
    { 0xe6bf3073 }  // sxth r3, r3
    });

    EXPECT_EQ(cpu.m_context[3], 0xFF);
}

TEST(sxth_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03001 }, // mov r3, #1
    { 0xe6bf3073 }  // sxth r3, r3
    });

    EXPECT_EQ(cpu.m_context[3], 1);
}