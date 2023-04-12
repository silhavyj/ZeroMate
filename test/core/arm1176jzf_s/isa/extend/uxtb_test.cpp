#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"

TEST(uxtb_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03b01 }, // mov r3, #1024
    { 0xe6ef3473 }  // uxtb r3, r3, ROR #8
    });

    EXPECT_EQ(cpu.m_regs[3], 4);
}

TEST(uxtb_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03000 }, // mvn r3, #0
    { 0xe6ef3073 }  // uxtb r3, r3
    });

    EXPECT_EQ(cpu.m_regs[3], 0xFF);
}

TEST(uxtb_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03000 }, // mvn r3, #0
    { 0xe6ef3c73 }  // uxtb r3, r3, ROR #24
    });

    EXPECT_EQ(cpu.m_regs[3], 0xFF);
}

TEST(uxtb_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e03502 }, // mvn r3, #0x00800000
    { 0xe6ef3873 }  // uxtb r3, r3, ROR #16
    });

    EXPECT_EQ(cpu.m_regs[3], 0x7F);
}