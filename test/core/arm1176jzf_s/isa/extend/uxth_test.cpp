#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"

TEST(uxth_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03b01 }, // mov r3, #1024
    { 0xe6ff3473 }  // uxth r3, r3, ROR #8
    });

    EXPECT_EQ(cpu.m_context[3], 4);
}

TEST(uxth_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03000 }, // mvn r3, #0
    { 0xe6ff3073 }  // uxth r3, r3
    });

    EXPECT_EQ(cpu.m_context[3], 0xFFFF);
}

TEST(uxth_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03000 }, // mvn r3, #0
    { 0xe6ff3c73 }  // uxth r3, r3, ROR #24
    });

    EXPECT_EQ(cpu.m_context[3], 0xFFFF);
}

TEST(uxth_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03502 }, // mvn r3, #0x00800000
    { 0xe6ff3873 }  // uxth r3, r3, ROR #16
    });

    EXPECT_EQ(cpu.m_context[3], 0xFF7F);
}