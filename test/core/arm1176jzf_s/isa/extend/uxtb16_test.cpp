#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(uxtb16_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e030ab }, // mvn r3, #0xAB
    { 0xe6cf3073 }  // uxtb16 r3, r3
    });

    EXPECT_EQ(cpu.m_context[3], 0x00FF0054);
}

TEST(uxtb16_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e030ab }, // mvn r3, #0xAB
    { 0xe6cf3473 }  // uxtb16 r3, r3, ROR #8
    });

    EXPECT_EQ(cpu.m_context[3], 0x00FF00FF);
}

TEST(uxtb16_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03102 }, // mov r3, #0x80000000
    { 0xe6cf3c73 }  // uxtb16 r3, r3, ROR #24
    });

    EXPECT_EQ(cpu.m_context[3], 0x00000080);
}

TEST(uxtb16_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03001 }, // mov r3, #0x1
    { 0xe6cf3873 }  // uxtb16 r3, r3, ROR #16
    });

    EXPECT_EQ(cpu.m_context[3], 0x00010000);
}

TEST(uxtb16_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe6cf2870 }  // uxtb16 r2, r0, ROR #16
    });

    EXPECT_EQ(cpu.m_context[2], 0x00FF00FF);
}