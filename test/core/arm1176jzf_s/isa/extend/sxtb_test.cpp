#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(sxtb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03102 }, // mvn r3, #0x80000000
    { 0xe6af3873 }  // sxtb r3, r3, ROR #16
    });

    EXPECT_EQ(cpu.m_context[3], 0xFFFFFFFF);
}

TEST(sxtb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a030ff }, // mov r3, #0xFF
    { 0xe6af3073 }  // sxtb r3, r3
    });

    EXPECT_EQ(cpu.m_context[3], 0xFFFFFFFF);
}

TEST(sxtb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03001 }, // mov r3, #1
    { 0xe6af3073 }  // sxtb r3, r3
    });

    EXPECT_EQ(cpu.m_context[3], 1);
}