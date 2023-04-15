#include <gtest/gtest.h>

#include "core/arm1176jzf_s/cpu_core.hpp"

TEST(orr_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe3a01106 }, // mov r1, #0x80000001
    { 0xe1901001 }  // orrs r1, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[1], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}

TEST(orr_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3a01301 }, // mov r1, #0b00000100000000000000000000000000
    { 0xe1901001 }  // orrs r1, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[1], 0b00000100'00000000'00000000'00000000);

    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}

TEST(orr_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe1901001 }  // orrs r1, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[1], 0);

    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}

TEST(orr_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe1801001 }  // orr r1, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[1], 0);

    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}

TEST(orr_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mov r0, #0x7FFFFFFF
    { 0xe3a01001 }, // mov r1, #1
    { 0xe19020e1 }  // orrs r2, r0, r1, ROR #1
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}